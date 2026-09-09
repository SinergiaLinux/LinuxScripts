
#!/bin/bash

# Exit on error, on unset variables, and propagate errors through pipes
set -euo pipefail

# Aviso de en qué línea falló el script, si falla
trap 'echo "==> ERROR: el script falló en la línea $LINENO (comando: $BASH_COMMAND)" >&2' ERR

# Identificar usuario real (en caso de ejecutar con sudo)
REAL_USER=${SUDO_USER:-$USER}
USER_HOME=$(eval echo "~$REAL_USER")

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
# 5.2 ICONOS YAMIS POR DEFECTO + ÍCONO DE LANZADOR ARCH LINUX
# ==========================================
echo "==> Configurando iconos YAMIS por defecto..."
YAMIS_DIR=$(find /usr/share/icons "$USER_HOME/.local/share/icons" -maxdepth 1 -type d \( -iname "*yamis*" -o -iname "*yet*monochrome*" -o -iname "*another-monochrome*" \) 2>/dev/null | head -n1 || true)
echo "==> Carpeta de iconos YAMIS detectada: ${YAMIS_DIR:-(ninguna)}"

ICON_THEME_ID="YAMIS"
if [ -n "$YAMIS_DIR" ]; then
    ICON_THEME_ID=$(basename "$YAMIS_DIR")
else
    echo "==> Aviso: no se encontró la carpeta de YAMIS instalada, se usará el nombre 'YAMIS' de todos modos por si el paquete la crea más tarde."
fi

# Buscar el archivo archlinux-logo que ya está presente en el sistema
echo "==> Buscando el archivo archlinux-logo ya presente en el sistema..."
ARCH_LOGO_FILE="/usr/share/icons/yet-another-monochrome-icon-set/apps/scalable/archlinux.svg"
if [ ! -f "$ARCH_LOGO_FILE" ]; then
    echo "==> Aviso: no se encontró el archlinux.svg de YAMIS en la ruta esperada, se amplía la búsqueda..."
    ARCH_LOGO_FILE=$(find /usr/share "$USER_HOME" -iname "archlinux-logo*" -type f \( -iname "*.svg" -o -iname "*.png" -o -iname "*.svgz" \) 2>/dev/null | head -n1 || true)
    if [ -z "$ARCH_LOGO_FILE" ]; then
        ARCH_LOGO_FILE=$(find /usr/share/icons "$USER_HOME/.local/share/icons" -iname "archlinux.svg" -type f 2>/dev/null | head -n1 || true)
    fi
fi
echo "==> Archivo archlinux-logo detectado: ${ARCH_LOGO_FILE:-(ninguno)}"

if [ -n "$ARCH_LOGO_FILE" ]; then
    ARCH_LOGO_EXT="${ARCH_LOGO_FILE##*.}"

    # Método 1: tema de iconos compuesto que hereda de YAMIS y pisa el ícono
    # del lanzador (por si Kickoff lo resuelve dinámicamente vía icon-theme)
    LAUNCHER_THEME_DIR="$USER_HOME/.local/share/icons/YAMIS-ArchLauncher"
    sudo -u "$REAL_USER" mkdir -p "$LAUNCHER_THEME_DIR/scalable/apps" "$LAUNCHER_THEME_DIR/scalable/places"
    for name in start-here-kde-plasma start-here-kde start-here; do
        sudo -u "$REAL_USER" cp "$ARCH_LOGO_FILE" "$LAUNCHER_THEME_DIR/scalable/apps/$name.$ARCH_LOGO_EXT"
        sudo -u "$REAL_USER" cp "$ARCH_LOGO_FILE" "$LAUNCHER_THEME_DIR/scalable/places/$name.$ARCH_LOGO_EXT"
    done
    sudo -u "$REAL_USER" bash -c "cat > '$LAUNCHER_THEME_DIR/index.theme'" << EOF
[Icon Theme]
Name=YAMIS with Arch Launcher
Comment=YAMIS icon set with the Arch Linux launcher icon
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
    echo "==> Tema de iconos compuesto YAMIS-ArchLauncher creado (hereda de $ICON_THEME_ID)."
    ICON_THEME_ID="YAMIS-ArchLauncher"

    # Método 2 (el que realmente decide el ícono por defecto de Kickoff):
    # editar el script de layout que Plasma ejecuta en el primer inicio de sesión
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
    echo "==> Aviso: no se encontró ningún archivo archlinux-logo en el sistema, se usará YAMIS sin ícono de lanzador personalizado."
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
# 5.4 CONFIGURAR WALLPAPER POR DEFECTO EN PLASMA (Cold Ripple)
# ==========================================
echo "==> Configurando wallpaper por defecto (Cold Ripple de Risto Saukonpää)..."

WALLPAPER_NAME="ColdRipple"
WALLPAPER_FILE="/usr/share/wallpapers/ColdRipple/contents/images/1920x1080.png"

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
if [ -d "$RUNTIME_DIR" ] && command -v plasma-apply-wallpaperimage &>/dev/null; then
    sudo -u "$REAL_USER" XDG_RUNTIME_DIR="$RUNTIME_DIR" DBUS_SESSION_BUS_ADDRESS="unix:path=$RUNTIME_DIR/bus" \
        plasma-apply-wallpaperimage "$WALLPAPER_FILE" 2>/dev/null || true
fi

echo "==> Fondo 'Cold Ripple' de Risto Saukonpää configurado por defecto."

# ==========================================
# 6. CONFIGURACIÓN DE SYSTEM SERVICES, SDDM Y GRUB
# ==========================================
echo "==> Instalando y configurando el tema Monochrome para SDDM (Plasma 6)..."

SDDM_TMP=$(mktemp -d)
if git clone --depth 1 https://github.com/pwyde/monochrome-kde.git "$SDDM_TMP/monochrome-kde"; then
    # La ruta real del tema dentro del repositorio es sddm/themes/monochrome
    if [ -d "$SDDM_TMP/monochrome-kde/sddm/themes/monochrome" ]; then
        sudo mkdir -p /usr/share/sddm/themes/monochrome
        sudo cp -r "$SDDM_TMP/monochrome-kde/sddm/themes/monochrome/"* /usr/share/sddm/themes/monochrome/
        echo "==> Archivos de tema SDDM Monochrome instalados en /usr/share/sddm/themes/monochrome."
    else
        echo "==> Aviso: No se encontró la carpeta sddm/themes/monochrome dentro del repositorio."
    fi
else
    echo "==> Aviso: No se pudo clonar el repositorio monochrome-kde."
fi
rm -rf "$SDDM_TMP"

# Establecer Monochrome como el tema activo en la configuración de SDDM
echo "==> Configurando /etc/sddm.conf.d/theme.conf.user..."
sudo mkdir -p /etc/sddm.conf.d
sudo bash -c 'cat > /etc/sddm.conf.d/theme.conf.user' << EOF
[Theme]
Current=monochrome
EOF

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
echo " Icon theme: YAMIS con ícono de lanzador Arch Linux en blanco"
echo " Konsole: transparencia por defecto (Opacity=0.85)"
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
