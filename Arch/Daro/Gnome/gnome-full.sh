
#!/bin/bash

# ==========================================
# 1. CONFIGURACIÓN DE RESPALDO Y PACMAN
# ==========================================
if [ ! -f /etc/pacman.conf.bak_repos ]; then
    echo "==> Creando respaldo de /etc/pacman.conf..."
    sudo cp /etc/pacman.conf /etc/pacman.conf.bak_repos
fi

# Agregar ILoveCandy y habilitar ParallelDownloads si no existen (CORREGIDO)
echo "==> Activando ILoveCandy y descargas paralelas en pacman.conf..."
if ! grep -q "^ILoveCandy" /etc/pacman.conf; then
    # Inserta ILoveCandy justo debajo de la cabecera [options]
    sudo sed -i '/^\[options\]/a ILoveCandy' /etc/pacman.conf
fi

if grep -q "^#ParallelDownloads" /etc/pacman.conf; then
    sudo sed -i 's/^#ParallelDownloads/ParallelDownloads/g' /etc/pacman.conf
elif ! grep -q "^ParallelDownloads" /etc/pacman.conf; then
    sudo sed -i '/^\[options\]/a ParallelDownloads = 5' /etc/pacman.conf
fi


# ==========================================
# 2. CONFIGURACIÓN DEL REPOSITORIO NEMESIS_REPO (KIRO)
# ==========================================
echo "==> Configurando el repositorio nemesis_repo..."

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
sudo pacman-key --recv-keys 149ABD0C3A0563EE --keyserver keys.openpgp.org

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
sudo pacman-key --recv-key 3056513887B78AEB --keyserver hkps://keyserver.ubuntu.com:443
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
# 4. INSTALACIÓN DE PAQUETES DE PACMAN
# ==========================================
echo "==> Instalando entorno GNOME y aplicaciones..."
sudo pacman -S gnome-shell gnome-tweaks --noconfirm

sudo pacman -S gdm gnome-characters gnome-backgrounds gnome-calculator gnome-calendar gnome-clocks gnome-connections gnome-font-viewer gnome-logs gnome-maps gnome-remote-desktop gnome-color-manager gnome-control-center gnome-disk-utility gnome-keyring gnome-menus gnome-session gnome-settings-daemon gnome-shell-extensions gnome-system-monitor gnome-text-editor gnome-user-docs gnome-user-share gvfs-dnssd gvfs-wsdd loupe alacritty rygel sushi tecla tracker3-miners xdg-desktop-portal xdg-user-dirs-gtk yelp baobab evince grilo-plugins gvfs gvfs-afc gvfs-goa gvfs-gphoto2 gvfs-mtp gvfs-nfs gvfs-smb nautilus gnome-terminal-transparency pacman-contrib gnome-browser-connector amd-ucode intel-ucode vlc vlc-plugins-all fragments file-roller unrar p7zip firefox firefox-i18n-es-ar libreoffice-fresh-es hunspell-es_uy telegram-desktop fastfetch archlinux-tweak-tool-gtk4 gnome-shell-extension-arch-update gnome-shell-extension-dash-to-dock pamac-aur ttf-firacode-nerd gedit hardinfo2 gnome-boxes decibels snapshot gnome-font-viewer mpv obs-studio audacity ardour gparted kdenlive ventoy btop papirus-icon-theme nano dconf-editor mint-l-icons mint-x-icons mint-y-icons mate-icon-theme-faenza rustdesk-bin xorg-xrandr --noconfirm

sudo pacman -S ntfs-3g os-prober --noconfirm


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
yay -S stacer-bin gnome-shell-extension-dash2dock-lite gnome-shell-extension-compiz-alike-magic-lamp-effect-git gnome-shell-extension-compiz-windows-effect-git gnome-shell-extension-arc-menu-git gnome-shell-extension-astra-monitor gnome-shell-extension-burn-my-windows gnome-shell-extension-coverflow-alt-tab-git sinergia-dd-burner aimp iptvnator-bin yaru-colors-icon-theme fetch-git gapless --noconfirm


# ==========================================
# 6. PERSONALIZACIÓN DE GNOME Y CONFIGURACIONES
# ==========================================
echo "==> Aplicando personalización de GNOME..."

# 6.1 Descargar y aplicar fondo de escritorio segun la relación de aspecto detectada
WALLPAPER_URL_169="https://raw.githubusercontent.com/f4dzN/archlinux-wallpapers/main/wallpapers/37.png"
WALLPAPER_URL_219="https://raw.githubusercontent.com/UncleSpellbinder/Arch-Linux-HD-Wallpaper/main/ARCH_6__2560x1040.png"

echo "==> Detectando resolución de pantalla..."
SCREEN_RES=$(xrandr --current 2>/dev/null | grep '\*' | awk '{print $1}' | head -n1)
SCREEN_WIDTH=$(echo "$SCREEN_RES" | cut -dx -f1)
SCREEN_HEIGHT=$(echo "$SCREEN_RES" | cut -dx -f2)

if [ -n "$SCREEN_WIDTH" ] && [ -n "$SCREEN_HEIGHT" ] && [ "$SCREEN_HEIGHT" -gt 0 ] 2>/dev/null; then
    ASPECT_X100=$(( SCREEN_WIDTH * 100 / SCREEN_HEIGHT ))
else
    ASPECT_X100=177
fi

if [ "$ASPECT_X100" -ge 200 ]; then
    echo "==> Pantalla ultrapanorámica detectada (${SCREEN_RES:-desconocida}), usando fondo 21:9..."
    WALLPAPER_URL="$WALLPAPER_URL_219"
    WALLPAPER_PATH="/usr/share/backgrounds/gnome-sinergia-wallpaper-21x9.png"
else
    echo "==> Usando fondo 16:9 (resolución detectada: ${SCREEN_RES:-desconocida})..."
    WALLPAPER_URL="$WALLPAPER_URL_169"
    WALLPAPER_PATH="/usr/share/backgrounds/gnome-sinergia-wallpaper-16x9.png"
fi

echo "==> Descargando fondo de escritorio..."
sudo curl -L -o "$WALLPAPER_PATH" "$WALLPAPER_URL"
gsettings set org.gnome.desktop.background picture-uri "file://$WALLPAPER_PATH"
gsettings set org.gnome.desktop.background picture-uri-dark "file://$WALLPAPER_PATH"
gsettings set org.gnome.desktop.background picture-options 'zoom'

# 6.2 Activar Modo Oscuro
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'

# 6.3 Aplicar tema de íconos Yaru-Deepblue
gsettings set org.gnome.desktop.interface icon-theme 'Yaru-Deepblue'

# 6.4 Mostrar botones de Minimizar, Maximizar y Cerrar en las ventanas
gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,maximize,close'

# 6.5 Activar transparencia por defecto en GNOME Terminal
PROFILE_ID=$(gsettings get org.gnome.Terminal.ProfilesList default | tr -d "'")
if [ -n "$PROFILE_ID" ]; then
    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE_ID/ use-theme-transparent-background false
    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE_ID/ use-transparent-background true
    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE_ID/ background-transparency-percent 15
fi

# 6.6 Habilitar extensiones de GNOME por defecto
EXTENSIONS=(
    "compiz-alike-magic-lamp-effect@hermes83.github.com"
    "compiz-windows-effect@hermes83.github.com"
    "arcmenu@arcmenu.com"
    "monitor@astraext.github.io"
    "burn-my-windows@schneegans.github.com"
    "CoverflowAltTab@palatis.blogspot.com"
    "arch-update@RaphaelRochet"
    "dash-to-dock@micxgx.gmail.com"
)

# Convertir la lista a formato array de dconf/gsettings
EXT_LIST=$(printf "'%s', " "${EXTENSIONS[@]}")
EXT_LIST="[${EXT_LIST%, }]"

gsettings set org.gnome.shell enabled-extensions "$EXT_LIST"



# ArcMenu: Atajo Ctrl+Espacio e icono de Arch en celeste
gsettings set org.gnome.shell.extensions.arcmenu arcmenu-hotkey "['<Control>space']"
gsettings set org.gnome.shell.extensions.arcmenu arcmenu-hotkey-overlay-key-enabled false
gsettings set org.gnome.shell.extensions.arcmenu menu-button-icon 'resource:///org/gnome/shell/extensions/arcmenu/icons/scalable/actions/distro-arch-symbolic.svg'
gsettings set org.gnome.shell.extensions.arcmenu override-menu-button-color true
gsettings set org.gnome.shell.extensions.arcmenu menu-button-color 'rgb(0,186,255)'

# Dash to Dock: Tamaño de íconos a 28px y opacidad dinámica
gsettings set org.gnome.shell.extensions.dash-to-dock icon-size-fixed true
gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 28
gsettings set org.gnome.shell.extensions.dash-to-dock transparency-mode 'DYNAMIC'

# Burn My Windows: perfil con efectos Fuego, Hexágono y Matrix activos
BMW_PROFILE_DIR="$HOME/.config/burn-my-windows/profiles"
BMW_PROFILE_FILE="$BMW_PROFILE_DIR/default.conf"
mkdir -p "$BMW_PROFILE_DIR"
cat << EOF > "$BMW_PROFILE_FILE"
[burn-my-windows-profile]
fire-enable-effect=true
hexagon-enable-effect=true
matrix-enable-effect=true
EOF
gsettings set org.gnome.shell.extensions.burn-my-windows active-profile "$BMW_PROFILE_FILE"

# Guardar ajustes por defecto en dconf del sistema (Garantiza que persistan)
sudo mkdir -p /etc/dconf/db/local.d/
sudo bash -c "cat << EOF > /etc/dconf/db/local.d/00-custom-gnome
[org/gnome/shell]
enabled-extensions=$EXT_LIST

[org/gnome/desktop/background]
picture-uri=\"file://$WALLPAPER_PATH\"
picture-uri-dark=\"file://$WALLPAPER_PATH\"
picture-options=\"zoom\"

[org/gnome/desktop/interface]
color-scheme=\"prefer-dark\"
accent-color=\"green\"
icon-theme=\"Yaru-Deepblue\"

[org/gnome/desktop/wm/preferences]
button-layout=\"appmenu:minimize,maximize,close\"

[org/gnome/shell/extensions/arcmenu]
arcmenu-hotkey=[\"<Control>space\"]
arcmenu-hotkey-overlay-key-enabled=false
menu-button-icon=\"resource:///org/gnome/shell/extensions/arcmenu/icons/scalable/actions/distro-arch-symbolic.svg\"
override-menu-button-color=true
menu-button-color=\"rgb(0,186,255)\"

[org/gnome/shell/extensions/dash-to-dock]
dash-max-icon-size=28
icon-size-fixed=true
transparency-mode=\"DYNAMIC\"

[org/gnome/shell/extensions/burn-my-windows]
active-profile=\"$BMW_PROFILE_FILE\"
EOF"

sudo dconf update

# ==========================================
# 7. CONFIGURACIÓN DEL SISTEMA Y GRUB
# ==========================================
echo "==> Habilitando os-prober en GRUB..."
sudo sed -i.bak "63s/.*/GRUB_DISABLE_OS_PROBER=\"false\"/" /etc/default/grub

echo "==> Habilitando servicio GDM..."
sudo systemctl enable gdm.service

echo "==> Actualizando GRUB..."
sudo grub-mkconfig -o /boot/grub/grub.cfg


# ==========================================
# 8. LIMPIEZA Y REINICIO
# ==========================================
USER_HOME="$HOME"

echo "==> Limpiando carpeta del script..."
rm -rf "$USER_HOME/LinuxScripts"

echo "======================================================"
echo " Instalación y configuración completadas con éxito."
echo " Display manager configurado: GDM"
echo " Entorno de escritorio: GNOME Shell"
echo " Extensiones: Dash to Dock, Arc Menu, Burn My Windows,"
echo "              Compiz Magic Lamp, Coverflow Alt-Tab,"
echo "              Astra Monitor"
echo " Terminal: Gnome Terminal"
echo " Gestor de archivos: Nautilus"
echo " Repositorios activos: kiro (nemesis_repo) + chaotic-aur"
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
