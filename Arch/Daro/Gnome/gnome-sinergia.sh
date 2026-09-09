#!/bin/bash

# ==========================================
# 1. CONFIGURACIÓN DE RESPALDO
# ==========================================
if [ ! -f /etc/pacman.conf.bak_repos ]; then
    echo "==> Creando respaldo de /etc/pacman.conf..."
    sudo cp /etc/pacman.conf /etc/pacman.conf.bak_repos
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

# 3.1 Recibir y firmar clave primaria de Chaotic-AUR
sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com || \
sudo pacman-key --recv-key 3056513887B78AEB --keyserver hkps://keyserver.ubuntu.com:443
sudo pacman-key --lsign-key 3056513887B78AEB

# 3.2 Instalar los paquetes del llavero y lista de espejos de Chaotic-AUR
sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' --noconfirm
sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst' --noconfirm

# 3.3 Añadir la sección de Chaotic-AUR a pacman.conf si no existe
if ! grep -q "\[chaotic-aur\]" /etc/pacman.conf; then
    echo "==> Agregando [chaotic-aur] a pacman.conf..."
    sudo bash -c 'cat << EOF >> /etc/pacman.conf

[chaotic-aur]
Include = /etc/pacman.d/chaotic-mirrorlist
EOF'
fi

# 3.4 Sincronizar todos los repositorios agregados
echo "==> Actualizando la base de datos de repositorios..."
sudo pacman -Sy


# ==========================================
# 4. INSTALACIÓN DE PAQUETES DE PACMAN
# ==========================================
echo "==> Instalando entorno GNOME y aplicaciones..."
sudo pacman -S gnome-shell gnome-tweaks --noconfirm

sudo pacman -S gdm gnome-characters gnome-backgrounds gnome-calendar gnome-clocks gnome-connections gnome-font-viewer gnome-logs gnome-maps gnome-remote-desktop gnome-color-manager gnome-control-center gnome-disk-utility gnome-keyring gnome-menus gnome-session gnome-settings-daemon gnome-shell-extensions gnome-system-monitor gnome-text-editor gnome-user-docs gnome-user-share gvfs-dnssd gvfs-wsdd loupe alacritty rygel sushi tecla tracker3-miners xdg-desktop-portal xdg-user-dirs-gtk yelp baobab evince grilo-plugins gvfs gvfs-afc gvfs-goa gvfs-gphoto2 gvfs-mtp gvfs-nfs gvfs-smb nautilus gnome-terminal-transparency pacman-contrib gnome-browser-connector amd-ucode intel-ucode vlc vlc-plugins-all qbittorrent ark unrar p7zip firefox firefox-i18n-es-ar libreoffice-fresh-es hunspell-es_uy telegram-desktop fastfetch archlinux-tweak-tool-gtk4 gnome-shell-extension-arch-update gnome-shell-extension-dash-to-dock pamac-aur ttf-firacode-nerd btop  nano --noconfirm

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
yay -S stacer-bin gnome-shell-extension-dash2dock-lite gnome-shell-extension-compiz-alike-magic-lamp-effect-git gnome-shell-extension-compiz-windows-effect-git gnome-shell-extension-arc-menu-git gnome-shell-extension-astra-monitor gnome-shell-extension-burn-my-windows gnome-shell-extension-coverflow-alt-tab-git --noconfirm


# ==========================================
# 6. CONFIGURACIÓN DEL SISTEMA Y GRUB
# ==========================================
echo "==> Habilitando os-prober en GRUB..."
sudo sed -i.bak "63s/.*/GRUB_DISABLE_OS_PROBER=\"false\"/" /etc/default/grub

echo "==> Habilitando servicio GDM..."
sudo systemctl enable gdm.service

echo "==> Actualizando GRUB..."
sudo grub-mkconfig -o /boot/grub/grub.cfg


# ==========================================
# 7. LIMPIEZA Y REINICIO
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
echo " Terminal: Alacritty"
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
