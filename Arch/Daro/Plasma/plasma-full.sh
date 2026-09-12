#!/bin/bash

# Exit on error, on unset variables, and propagate errors through pipes
set -euo pipefail

# Aviso de en qué línea falló el script, si falla
trap 'echo "==> ERROR: el script falló en la línea $LINENO (comando: $BASH_COMMAND)" >&2' ERR

# Identificar usuario real (en caso de ejecutar con sudo)
REAL_USER=${SUDO_USER:-$USER}
USER_HOME=$(eval echo "~$REAL_USER")

# ==========================================
# 0. UTILIDAD: DESCARGA DE ELEMENTOS DE KDE STORE (API OCS)
# ==========================================
# Dado el ID numérico de un elemento de KDE Store (el que aparece en la URL,
# ej. store.kde.org/p/1422319 -> 1422319), consulta la API pública OCS y
# descarga el archivo del paquete. Como el link de descarga real se pide en
# el momento (y no se guarda hardcodeado), nunca queda vencido.
fetch_kde_store_file() {
    local content_id="$1"
    local dest_dir="$2"
    local api_url="https://api.kde-look.org/ocs/v1/content/data/${content_id}"
    local xml
    xml=$(curl -fsSL "$api_url") || { echo "==> Aviso: no se pudo consultar KDE Store (id $content_id)." >&2; return 1; }

    local dl_url dl_name
    dl_url=$(echo "$xml" | grep -oP '(?<=<downloadlink1>)[^<]+')
    dl_name=$(echo "$xml" | grep -oP '(?<=<downloadname1>)[^<]+')

    if [ -z "$dl_url" ]; then
        echo "==> Aviso: KDE Store no devolvió un link de descarga para el id $content_id." >&2
        return 1
    fi

    curl -fsSL "$dl_url" -o "$dest_dir/$dl_name" || { echo "==> Aviso: falló la descarga de $dl_name." >&2; return 1; }
    echo "$dest_dir/$dl_name"
}

# Descomprime un archivo (tar.gz/tar.xz/tar.bz2/zip) detectando el formato por extensión
extract_archive() {
    local archive="$1"
    local dest="$2"
    mkdir -p "$dest"
    case "$archive" in
        *.tar.gz|*.tgz) tar -xzf "$archive" -C "$dest" ;;
        *.tar.xz)       tar -xJf "$archive" -C "$dest" ;;
        *.tar.bz2)      tar -xjf "$archive" -C "$dest" ;;
        *.zip)          unzip -q "$archive" -d "$dest" ;;
        *) echo "==> Aviso: formato de archivo no reconocido: $archive" >&2; return 1 ;;
    esac
}

# ==========================================
# 1. CONFIGURACIÓN DE RESPALDO Y PACMAN
# ==========================================
if [ ! -f /etc/pacman.conf.bak_repos ]; then
    echo "==> Creando respaldo de /etc/pacman.conf..."
    sudo cp /etc/pacman.conf /etc/pacman.conf.bak_repos
fi

echo "==> Activando ILoveCandy y descargas paralelas en pacman.conf..."
if ! grep -q "^ILoveCandy" /etc/pacman.conf; then
    sudo sed -i '/^\[options\]/a ILoveCandy' /etc/pacman.conf
fi

if grep -q "^#ParallelDownloads" /etc/pacman.conf; then
    sudo sed -i 's/^#ParallelDownloads.*/ParallelDownloads = 5/g' /etc/pacman.conf
elif ! grep -q "^ParallelDownloads" /etc/pacman.conf; then
    sudo sed -i '/^\[options\]/a ParallelDownloads = 5' /etc/pacman.conf
fi


# ==========================================
# 1.1 CONFIGURACIÓN DEL REPOSITORIO MULTILIB
# ==========================================
echo "==> Verificando repositorio multilib..."

if grep -q "^\[multilib\]" /etc/pacman.conf; then
    echo "==> El repositorio multilib ya está habilitado."
elif grep -q "^#\[multilib\]" /etc/pacman.conf; then
    echo "==> Habilitando repositorio multilib (estaba comentado)..."
    sudo sed -i '/^#\[multilib\]/,/^#Include/ s/^#//' /etc/pacman.conf
else
    echo "==> Agregando repositorio multilib (no existía en el archivo)..."
    sudo bash -c 'cat << EOF >> /etc/pacman.conf

[multilib]
Include = /etc/pacman.d/mirrorlist
EOF'
fi

sudo pacman -Sy


# ==========================================
# 2. CONFIGURACIÓN DEL REPOSITORIO NEMESIS_REPO (KIRO)
# ==========================================
echo "==> Configurando el repositorio nemesis_repo..."

# Aseguramos que el keyring de pacman esté inicializado antes de importar claves
sudo pacman-key --init 2>/dev/null || true

if ! grep -q "\[nemesis_repo\]" /etc/pacman.conf; then
    echo "==> Agregando repositorio temporal nemesis_repo para bootstrap..."
    sudo bash -c 'cat << EOF >> /etc/pacman.conf

[nemesis_repo]
Server = https://erikdubois.github.io/\$repo/\$arch
EOF'
fi

sudo pacman -Sy

echo "==> Importando clave PGP de Kiro (149ABD0C3A0563EE)..."
sudo pacman-key --recv-keys 149ABD0C3A0563EE --keyserver keyserver.ubuntu.com || \
sudo pacman-key --recv-keys 149ABD0C3A0563EE --keyserver keys.openpgp.org || \
{ sleep 5; sudo pacman-key --recv-keys 149ABD0C3A0563EE --keyserver keyserver.ubuntu.com; }

sudo pacman-key --lsign-key 149ABD0C3A0563EE

echo "==> Instalando kiro-keyring y kiro-mirrorlist..."
sudo pacman -Sy --needed kiro-keyring kiro-mirrorlist --noconfirm

echo "==> Actualizando pacman.conf para usar kiro-mirrorlist..."
sudo sed -i 's|Server = https://erikdubois.github.io/\$repo/\$arch|Include = /etc/pacman.d/kiro-mirrorlist|g' /etc/pacman.conf


# ==========================================
# 3. CONFIGURACIÓN DEL REPOSITORIO CHAOTIC-AUR
# ==========================================
echo "==> Configurando el repositorio Chaotic-AUR..."

sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com || \
sudo pacman-key --recv-key 3056513887B78AEB --keyserver hkps://keyserver.ubuntu.com:443 || \
{ sleep 5; sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com; }
sudo pacman-key --lsign-key 3056513887B78AEB

sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' --noconfirm
sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst' --noconfirm

if ! grep -q "\[chaotic-aur\]" /etc/pacman.conf; then
    echo "==> Agregando [chaotic-aur] a pacman.conf..."
    sudo bash -c 'cat << EOF >> /etc/pacman.conf

[chaotic-aur]
Include = /etc/pacman.d/chaotic-mirrorlist
EOF'
fi

echo "==> Actualizando la base de datos de repositorios..."
sudo pacman -Sy


# ==========================================
# 4. INSTALACIÓN DE PAQUETES OFICIALES Y CHAOTIC-AUR
# ==========================================
echo "==> Instalando Plasma, sddm, aplicaciones, dependencias y paquetes del sistema..."
sudo pacman -S --noconfirm --needed \
  plasma \
  sddm \
  sddm-kcm \
  amd-ucode \
  intel-ucode \
  okular \
  vlc \
  unrar \
  unarchiver \
  unzip \
  p7zip \
  firefox \
  firefox-i18n-es-ar \
  libreoffice-fresh-es \
  hunspell-es_uy \
  telegram-desktop \
  fastfetch \
  ntfs-3g \
  archlinux-tweak-tool-gtk4 \
  konsole \
  dolphin \
  kcalc \
  vlc-plugins-all \
  hardinfo2 \
  mpv \
  btop \
  gparted \
  nano \
  shelly \
  ark \
  powerdevil \
  plasma-systemmonitor \
  kwalletmanager \
  yakuake \
  kvantum \
  kvantum-qt5 \
  qbittorrent \
  obs-studio \
  audacity \
  ardour \
  kdenlive \
  ventoy \
  papirus-icon-theme \
  mint-l-icons \
  mint-x-icons \
  mint-y-icons \
  mate-icon-theme-faenza \
  rustdesk-bin \
  gnome-boxes \
  koko \
  kate \
  os-prober


# ==========================================
# 4.1 DESINSTALACIÓN DE PAQUETES NO DESEADOS
# ==========================================
echo "==> Desinstalando discover..."
for pkg in discover; do
    if pacman -Qi "$pkg" &>/dev/null; then
        echo "==> Eliminando $pkg..."
        sudo pacman -Rns --noconfirm "$pkg"
    else
        echo "==> $pkg no está instalado, se omite."
    fi
done


# ==========================================
# 5. INSTALACIÓN DE YAY Y PAQUETES AUR
# ==========================================

echo "==> Asegurando base-devel e instalando YAY..."
sudo pacman -S --needed base-devel git --noconfirm

rm -rf yay
git clone https://aur.archlinux.org/yay.git
cd yay || exit
makepkg -si --noconfirm
cd ..
rm -rf yay

echo "==> Instalando paquetes adicionales..."
yay -S stacer-bin sinergia-dd-burner iptvnator-bin yamis-icon-theme-git fetch-git --noconfirm

# ==========================================
# 5.1 TEMA GLOBAL BREEZE DARK POR DEFECTO
# ==========================================
echo "==> Fijando Breeze Dark como Tema Global por defecto..."
BREEZEDARK_ID="org.kde.breezedark.desktop"
USER_UID=$(id -u "$REAL_USER")
RUNTIME_DIR="/run/user/$USER_UID"
if [ ! -d "$RUNTIME_DIR" ]; then
    RUNTIME_DIR=$(sudo -u "$REAL_USER" mktemp -d)
fi

sudo -u "$REAL_USER" mkdir -p "$USER_HOME/.config"
if command -v plasma-apply-lookandfeel &>/dev/null; then
    sudo -u "$REAL_USER" env QT_QPA_PLATFORM=offscreen XDG_RUNTIME_DIR="$RUNTIME_DIR" \
        plasma-apply-lookandfeel -a "$BREEZEDARK_ID" || \
        echo "==> Aviso: plasma-apply-lookandfeel devolvió un error, se usará el respaldo directo sobre kdeglobals."
else
    echo "==> Aviso: plasma-apply-lookandfeel no está disponible, se usará el respaldo directo sobre kdeglobals."
fi

KDEGLOBALS="$USER_HOME/.config/kdeglobals"
if [ -f "$KDEGLOBALS" ] && grep -q "^\[KDE\]" "$KDEGLOBALS"; then
    if grep -q "^LookAndFeelPackage=" "$KDEGLOBALS"; then
        sudo -u "$REAL_USER" sed -i "s|^LookAndFeelPackage=.*|LookAndFeelPackage=$BREEZEDARK_ID|" "$KDEGLOBALS"
    else
        sudo -u "$REAL_USER" sed -i "/^\[KDE\]/a LookAndFeelPackage=$BREEZEDARK_ID" "$KDEGLOBALS"
    fi
else
    sudo -u "$REAL_USER" bash -c "printf '\n[KDE]\nLookAndFeelPackage=%s\n' '$BREEZEDARK_ID' >> '$KDEGLOBALS'"
fi
echo "==> Breeze Dark fijado como Tema Global por defecto."

# ==========================================
# 5.2 ICONOS VORTEX-DARK-ICONS POR DEFECTO + ÍCONO DE LANZADOR ARCH LINUX
# ==========================================
echo "==> Instalando el tema de iconos Vortex-Dark-Icons desde KDE Store..."

ICONS_TMP=$(mktemp -d)
ICONS_ARCHIVE=$(fetch_kde_store_file "1493433" "$ICONS_TMP") || true

ICON_THEME_ID="Vortex-Dark-Icons"

if [ -n "${ICONS_ARCHIVE:-}" ] && [ -f "$ICONS_ARCHIVE" ]; then
    ICONS_EXTRACT="$ICONS_TMP/extracted"
    extract_archive "$ICONS_ARCHIVE" "$ICONS_EXTRACT" || true

    ICONS_INDEX_THEME=$(find "$ICONS_EXTRACT" -maxdepth 3 -iname "index.theme" | head -n1 || true)
    if [ -n "$ICONS_INDEX_THEME" ]; then
        ICONS_SRC_DIR=$(dirname "$ICONS_INDEX_THEME")
        ICON_THEME_ID=$(basename "$ICONS_SRC_DIR")
        sudo mkdir -p "/usr/share/icons/$ICON_THEME_ID"
        sudo cp -r "$ICONS_SRC_DIR"/* "/usr/share/icons/$ICON_THEME_ID/"
        echo "==> Iconos '$ICON_THEME_ID' instalados en /usr/share/icons/$ICON_THEME_ID"
    else
        echo "==> Aviso: no se encontró index.theme en el paquete descargado; se omite la instalación de los iconos."
    fi
else
    echo "==> Aviso: no se pudo descargar Vortex-Dark-Icons automáticamente. Se continúa sin instalarlo (podés hacerlo manualmente después)."
fi
rm -rf "$ICONS_TMP"

# Buscar el archivo archlinux-logo ya presente en el sistema, para el ícono del lanzador
echo "==> Buscando el archivo archlinux-logo ya presente en el sistema..."
ARCH_LOGO_FILE=$(find /usr/share/icons "$USER_HOME/.local/share/icons" -iname "archlinux.svg" -type f 2>/dev/null | head -n1 || true)
if [ -z "$ARCH_LOGO_FILE" ]; then
    ARCH_LOGO_FILE=$(find /usr/share "$USER_HOME" -iname "archlinux-logo*" -type f \( -iname "*.svg" -o -iname "*.png" -o -iname "*.svgz" \) 2>/dev/null | head -n1 || true)
fi
echo "==> Archivo archlinux-logo detectado: ${ARCH_LOGO_FILE:-(ninguno)}"

if [ -n "$ARCH_LOGO_FILE" ]; then
    ARCH_LOGO_EXT="${ARCH_LOGO_FILE##*.}"

    # Tema de iconos compuesto que hereda de Vortex-Dark-Icons y pisa el ícono del lanzador
    LAUNCHER_THEME_DIR="$USER_HOME/.local/share/icons/${ICON_THEME_ID}-ArchLauncher"
    sudo -u "$REAL_USER" mkdir -p "$LAUNCHER_THEME_DIR/scalable/apps" "$LAUNCHER_THEME_DIR/scalable/places"
    for name in start-here-kde-plasma start-here-kde start-here; do
        sudo -u "$REAL_USER" cp "$ARCH_LOGO_FILE" "$LAUNCHER_THEME_DIR/scalable/apps/$name.$ARCH_LOGO_EXT"
        sudo -u "$REAL_USER" cp "$ARCH_LOGO_FILE" "$LAUNCHER_THEME_DIR/scalable/places/$name.$ARCH_LOGO_EXT"
    done
    sudo -u "$REAL_USER" bash -c "cat > '$LAUNCHER_THEME_DIR/index.theme'" << EOF
[Icon Theme]
Name=$ICON_THEME_ID with Arch Launcher
Comment=$ICON_THEME_ID icon set with the Arch Linux launcher icon
Inherits=$ICON_THEME_ID,hicolor
Directories=scalable/apps,scalable/places

[scalable/apps]
Size=64
MinSize=8
MaxSize=512
Type=Scalable
Context=Applications

[scalable/places]
Size=64
MinSize=8
MaxSize=512
Type=Scalable
Context=Places
EOF
    echo "==> Tema de iconos compuesto ${ICON_THEME_ID}-ArchLauncher creado (hereda de $ICON_THEME_ID)."
    ICON_THEME_ID="${ICON_THEME_ID}-ArchLauncher"

    # Editar el script de layout que Plasma ejecuta en el primer inicio de sesión
    # para forzar el icono del widget del lanzador a la ruta absoluta del archivo.
    LAYOUT_JS="/usr/share/plasma/shells/org.kde.plasma.desktop/contents/layout.js"
    if [ -f "$LAYOUT_JS" ]; then
        sudo cp "$LAYOUT_JS" "$LAYOUT_JS.bak_orig" 2>/dev/null || true
        sudo awk -v iconpath="$ARCH_LOGO_FILE" '
            {
                print
                if ($0 ~ /addWidget\("org\.kde\.plasma\.kickoff"\)/) {
                    varname = $0
                    sub(/^[ \t]*(var|let|const)[ \t]+/, "", varname)
                    sub(/[ \t]*=.*/, "", varname)
                    if (varname != "" && varname !~ / /) {
                        print varname ".currentConfigGroup = [\"General\"];"
                        print varname ".writeConfig(\"icon\", \"" iconpath "\");"
                    }
                }
            }
        ' "$LAYOUT_JS.bak_orig" | sudo tee "$LAYOUT_JS" > /dev/null
        echo "==> layout.js parcheado para usar $ARCH_LOGO_FILE como ícono del lanzador de aplicaciones."
    else
        echo "==> Aviso: no se encontró layout.js en la ruta esperada, se omite el parche del lanzador."
    fi
else
    echo "==> Aviso: no se encontró ningún archivo archlinux-logo en el sistema, se usará $ICON_THEME_ID sin ícono de lanzador personalizado."
fi

KDEGLOBALS="$USER_HOME/.config/kdeglobals"
sudo -u "$REAL_USER" mkdir -p "$USER_HOME/.config"
if [ -f "$KDEGLOBALS" ] && grep -q "^\[Icons\]" "$KDEGLOBALS"; then
    if grep -q "^Theme=" "$KDEGLOBALS"; then
        sudo -u "$REAL_USER" sed -i "s|^Theme=.*|Theme=$ICON_THEME_ID|" "$KDEGLOBALS"
    else
        sudo -u "$REAL_USER" sed -i "/^\[Icons\]/a Theme=$ICON_THEME_ID" "$KDEGLOBALS"
    fi
else
    sudo -u "$REAL_USER" bash -c "printf '\n[Icons]\nTheme=%s\n' '$ICON_THEME_ID' >> '$KDEGLOBALS'"
fi
echo "==> Icon theme $ICON_THEME_ID fijado por defecto."

# ==========================================
# 5.3 TRANSPARENCIA POR DEFECTO EN KONSOLE
# ==========================================
echo "==> Configurando transparencia por defecto en Konsole..."
KONSOLE_DATA_DIR="$USER_HOME/.local/share/konsole"
sudo -u "$REAL_USER" mkdir -p "$KONSOLE_DATA_DIR"

BASE_COLORSCHEME="/usr/share/konsole/Breeze.colorscheme"
TRANSPARENT_SCHEME="$KONSOLE_DATA_DIR/BreezeTransparent.colorscheme"
if [ -f "$BASE_COLORSCHEME" ]; then
    sudo -u "$REAL_USER" cp "$BASE_COLORSCHEME" "$TRANSPARENT_SCHEME"
else
    echo "==> Aviso: no se encontró el color scheme base de Breeze, se crea uno mínimo."
    sudo -u "$REAL_USER" bash -c "printf '[Background]\nColor=35,38,41\n[Foreground]\nColor=252,252,252\n[General]\nDescription=BreezeTransparent\n' > '$TRANSPARENT_SCHEME'"
fi
if grep -q "^\[General\]" "$TRANSPARENT_SCHEME" && grep -q "^Opacity=" "$TRANSPARENT_SCHEME"; then
    sudo -u "$REAL_USER" sed -i "s|^Opacity=.*|Opacity=0.85|" "$TRANSPARENT_SCHEME"
elif grep -q "^\[General\]" "$TRANSPARENT_SCHEME"; then
    sudo -u "$REAL_USER" sed -i "/^\[General\]/a Opacity=0.85" "$TRANSPARENT_SCHEME"
else
    sudo -u "$REAL_USER" bash -c "printf '\n[General]\nOpacity=0.85\n' >> '$TRANSPARENT_SCHEME'"
fi

TRANSPARENT_PROFILE="$KONSOLE_DATA_DIR/Transparent.profile"
sudo -u "$REAL_USER" bash -c "printf '[Appearance]\nColorScheme=BreezeTransparent\n\n[General]\nName=Transparent\nParent=FALLBACK/\n' > '$TRANSPARENT_PROFILE'"

KONSOLERC="$USER_HOME/.config/konsolerc"
sudo -u "$REAL_USER" mkdir -p "$USER_HOME/.config"
if [ -f "$KONSOLERC" ] && grep -q "^\[Desktop Entry\]" "$KONSOLERC"; then
    if grep -q "^DefaultProfile=" "$KONSOLERC"; then
        sudo -u "$REAL_USER" sed -i "s|^DefaultProfile=.*|DefaultProfile=Transparent.profile|" "$KONSOLERC"
    else
        sudo -u "$REAL_USER" sed -i "/^\[Desktop Entry\]/a DefaultProfile=Transparent.profile" "$KONSOLERC"
    fi
else
    sudo -u "$REAL_USER" bash -c "printf '[Desktop Entry]\nDefaultProfile=Transparent.profile\n' >> '$KONSOLERC'"
fi
echo "==> Konsole configurado con transparencia (Opacity=0.85) como perfil por defecto."

# Habilitar el efecto de escritorio Blur, para que la transparencia se vea bien
KWINRC="$USER_HOME/.config/kwinrc"
sudo -u "$REAL_USER" touch "$KWINRC"
if grep -q "^\[Plugins\]" "$KWINRC" 2>/dev/null; then
    if grep -q "^blurEnabled=" "$KWINRC"; then
        sudo -u "$REAL_USER" sed -i "s|^blurEnabled=.*|blurEnabled=true|" "$KWINRC"
    else
        sudo -u "$REAL_USER" sed -i "/^\[Plugins\]/a blurEnabled=true" "$KWINRC"
    fi
else
    sudo -u "$REAL_USER" bash -c "printf '\n[Plugins]\nblurEnabled=true\n' >> '$KWINRC'"
fi

# ==========================================
# 5.4 CONFIGURAR WALLPAPER POR DEFECTO EN PLASMA (Nexus)
# ==========================================
echo "==> Configurando wallpaper por defecto (Nexus)..."

WALLPAPER_NAME="Nexus"
WALLPAPER_DIR="/usr/share/wallpapers/$WALLPAPER_NAME"

if [ ! -d "$WALLPAPER_DIR" ]; then
    echo "==> Aviso: no se encontró /usr/share/wallpapers/$WALLPAPER_NAME. Verificá el nombre exacto del wallpaper instalado."
fi

WALLPAPER_FILE=$(find "$WALLPAPER_DIR/contents/images" -type f \( -iname "*.png" -o -iname "*.jpg" \) 2>/dev/null | sort -V | tail -n1 || true)

# 1. Asegurar que el fondo por defecto esté fijado en los 'defaults' de Breeze Dark
LNF_DEFAULTS="/usr/share/plasma/look-and-feel/org.kde.breezedark.desktop/contents/defaults"
if [ -f "$LNF_DEFAULTS" ]; then
    sudo sed -i '/^Image=/d' "$LNF_DEFAULTS" 2>/dev/null || true
    if grep -q "^\[Wallpaper\]" "$LNF_DEFAULTS"; then
        sudo sed -i "/^\[Wallpaper\]/a Image=$WALLPAPER_NAME" "$LNF_DEFAULTS"
    else
        sudo bash -c "printf '\n[Wallpaper]\nImage=%s\n' '$WALLPAPER_NAME' >> '$LNF_DEFAULTS'"
    fi
fi

# 2. Configurar la estructura en plasma-org.kde.plasma.desktop-appletsrc para el usuario
PLASMRC="$USER_HOME/.config/plasma-org.kde.plasma.desktop-appletsrc"
sudo -u "$REAL_USER" mkdir -p "$USER_HOME/.config"

if [ ! -f "$PLASMRC" ] || ! grep -q "\[Containments\]" "$PLASMRC"; then
    # Generar la estructura base limpia que requiere Plasma para el fondo
    sudo -u "$REAL_USER" bash -c "cat > '$PLASMRC'" << EOF
[Containments][1]
activityId=
wallpaperplugin=org.kde.image

[Containments][1][Wallpaper][org.kde.image][General]
Image=file:///usr/share/wallpapers/$WALLPAPER_NAME
ImageName=$WALLPAPER_NAME
EOF
else
    # Si el archivo ya existe, actualizar o inyectar las líneas de imagen
    if grep -q "\[Wallpaper\]\[org.kde.image\]\[General\]" "$PLASMRC"; then
        sudo -u "$REAL_USER" sed -i "s|^Image=.*|Image=file:///usr/share/wallpapers/$WALLPAPER_NAME|" "$PLASMRC"
        sudo -u "$REAL_USER" sed -i "s|^ImageName=.*|ImageName=$WALLPAPER_NAME|" "$PLASMRC"
    else
        sudo -u "$REAL_USER" bash -c "cat >> '$PLASMRC'" << EOF

[Containments][1][Wallpaper][org.kde.image][General]
Image=file:///usr/share/wallpapers/$WALLPAPER_NAME
ImageName=$WALLPAPER_NAME
EOF
    fi
fi

# 3. Forzar el refresco dinámico si hay una sesión activa de Plasma
USER_UID=$(id -u "$REAL_USER")
RUNTIME_DIR="/run/user/$USER_UID"
if [ -d "$RUNTIME_DIR" ] && [ -n "$WALLPAPER_FILE" ] && command -v plasma-apply-wallpaperimage &>/dev/null; then
    sudo -u "$REAL_USER" XDG_RUNTIME_DIR="$RUNTIME_DIR" DBUS_SESSION_BUS_ADDRESS="unix:path=$RUNTIME_DIR/bus" \
        plasma-apply-wallpaperimage "$WALLPAPER_FILE" 2>/dev/null || true
fi

echo "==> Fondo 'Nexus' configurado por defecto."

# ==========================================
# 5.5 PANTALLA DE BIENVENIDA (SPLASH DE PLASMA): ARCH SIMPLE BLUE KDE 6
# ==========================================
echo "==> Instalando el splash 'Arch Simple Blue KDE 6' desde KDE Store..."

SPLASH_TMP=$(mktemp -d)
SPLASH_ARCHIVE=$(fetch_kde_store_file "2136517" "$SPLASH_TMP") || true

if [ -n "${SPLASH_ARCHIVE:-}" ] && [ -f "$SPLASH_ARCHIVE" ]; then
    SPLASH_EXTRACT="$SPLASH_TMP/extracted"
    extract_archive "$SPLASH_ARCHIVE" "$SPLASH_EXTRACT" || true

    # Buscar el paquete real dentro de lo descargado (puede venir un .git y una
    # carpeta contenedora) localizando contents/splash/Splash.qml
    SPLASH_QML=$(find "$SPLASH_EXTRACT" -maxdepth 6 -path "*/contents/splash/Splash.qml" | head -n1 || true)

    if [ -n "$SPLASH_QML" ]; then
        SPLASH_SRC_DIR=$(dirname "$(dirname "$(dirname "$SPLASH_QML")")")

        SPLASH_ID=""
        if [ -f "$SPLASH_SRC_DIR/metadata.json" ]; then
            SPLASH_ID=$(grep -oP '"Id"\s*:\s*"\K[^"]+' "$SPLASH_SRC_DIR/metadata.json" | head -n1 || true)
        fi
        if [ -z "$SPLASH_ID" ] && [ -f "$SPLASH_SRC_DIR/metadata.desktop" ]; then
            SPLASH_ID=$(grep -oP '(?<=^X-KDE-PluginInfo-Name=).+' "$SPLASH_SRC_DIR/metadata.desktop" | head -n1 || true)
        fi
        SPLASH_ID=${SPLASH_ID:-archsimpleblue}

        rm -rf "$SPLASH_SRC_DIR/.git"

        # Los splash de Plasma 6 se instalan como paquete Plasma/LookAndFeel,
        # NO en /usr/share/plasma/splash/
        sudo mkdir -p "/usr/share/plasma/look-and-feel/$SPLASH_ID"
        sudo cp -r "$SPLASH_SRC_DIR"/* "/usr/share/plasma/look-and-feel/$SPLASH_ID/"
        echo "==> Splash '$SPLASH_ID' instalado en /usr/share/plasma/look-and-feel/$SPLASH_ID"

        KSPLASHRC="$USER_HOME/.config/ksplashrc"
        sudo -u "$REAL_USER" mkdir -p "$USER_HOME/.config"
        if [ -f "$KSPLASHRC" ] && grep -q "^\[KSplash\]" "$KSPLASHRC"; then
            if grep -q "^Theme=" "$KSPLASHRC"; then
                sudo -u "$REAL_USER" sed -i "s|^Theme=.*|Theme=$SPLASH_ID|" "$KSPLASHRC"
            else
                sudo -u "$REAL_USER" sed -i "/^\[KSplash\]/a Theme=$SPLASH_ID" "$KSPLASHRC"
            fi
        else
            sudo -u "$REAL_USER" bash -c "printf '\n[KSplash]\nTheme=%s\n' '$SPLASH_ID' >> '$KSPLASHRC'"
        fi
        echo "==> '$SPLASH_ID' fijado como pantalla de bienvenida por defecto."
    else
        echo "==> Aviso: no se encontró contents/splash/Splash.qml en el paquete descargado; se omite la instalación del splash."
    fi
else
    echo "==> Aviso: no se pudo descargar 'Arch Simple Blue KDE 6' automáticamente. Podés instalarlo manualmente después desde KDE Store (id 2136517)."
fi
rm -rf "$SPLASH_TMP"


# ==========================================
# 6. CONFIGURACIÓN DE SYSTEM SERVICES, SDDM Y GRUB
# ==========================================
# Se deja el tema por defecto que trae SDDM (breeze), sin aplicar ningún tema
# personalizado ni escribir /etc/sddm.conf.d/theme.conf.user.
echo "==> SDDM se deja con su tema por defecto (sin personalizar)."

echo "==> Habilitando SDDM como Display Manager..."
# Deshabilitar otros DMs si están activos para evitar conflictos
for dm in entrance gdm lightdm; do
    if systemctl is-enabled "$dm" &>/dev/null; then
        echo "==> Deshabilitando $dm..."
        sudo systemctl disable "$dm"
    fi
done

sudo systemctl enable sddm

# ==========================================
# 6.1 DESACTIVAR KDE WALLET POR DEFECTO
# ==========================================
echo "==> Desactivando KDE Wallet por defecto para $REAL_USER..."
KWALLET_CONFIG="$USER_HOME/.config/kwalletrc"

sudo -u "$REAL_USER" mkdir -p "$USER_HOME/.config"

if [ -f "$KWALLET_CONFIG" ]; then
    if grep -q "^\[Wallet\]" "$KWALLET_CONFIG"; then
        sudo -u "$REAL_USER" sed -i '/^\[Wallet\]/,/^\[/{s/^Enabled=.*/Enabled=false/}' "$KWALLET_CONFIG"
        if ! grep -A5 "^\[Wallet\]" "$KWALLET_CONFIG" | grep -q "^Enabled="; then
            sudo -u "$REAL_USER" sed -i '/^\[Wallet\]/a Enabled=false' "$KWALLET_CONFIG"
        fi
    else
        sudo -u "$REAL_USER" bash -c "printf '\n[Wallet]\nEnabled=false\n' >> '$KWALLET_CONFIG'"
    fi
else
    sudo -u "$REAL_USER" bash -c "printf '[Wallet]\nEnabled=false\n' > '$KWALLET_CONFIG'"
fi


# ==========================================
# 7. LIMPIEZA Y REINICIO
# ==========================================
rm -rf "$USER_HOME/LinuxScripts"

echo "======================================================"
echo " Instalación y configuración completadas con éxito."
echo " Display manager configurado: SDDM"
echo " KDE Wallet: desactivado por defecto"
echo " Tema Global: Breeze Dark"
echo " Icon theme: Vortex-Dark-Icons con ícono de lanzador Arch Linux"
echo " Konsole: transparencia por defecto (Opacity=0.85)"
echo " Fondo de pantalla: Nexus"
echo " Splash de Plasma: Arch Simple Blue KDE 6"
echo "  
 SSSS   III   N   N  EEEEE  RRRR    GGG    III    AAA
S        I    NN  N  E      R   R  G   G    I    A   A
S        I    N N N  E      R   R  G        I    A   A
 SSS     I    N N N  EEEE   RRRR   G GGG    I    AAAAA
    S    I    N  NN  E      R R    G   G    I    A   A
    S    I    N   N  E      R  R   G   G    I    A   A
SSSS    III   N   N  EEEEE  R   R   GGG    III   A   A"
echo "======================================================"
echo "            COMUNIDAD    LINUXERA"
echo "======================================================"

read -t 15 -p "Reiniciar el sistema ahora? (s/N, auto-continúa en 15s): " respuesta || respuesta="s"
case "$respuesta" in
    [sS]|"")
        echo "==> Reiniciando..."
        sudo reboot
        ;;
    *)
        echo "==> Reinicio cancelado. Recordá reiniciar manualmente para aplicar los cambios."
        ;;
esac
