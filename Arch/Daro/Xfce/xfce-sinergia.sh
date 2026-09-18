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


# Exit on error (si un comando falla, el script se detiene por seguridad)
set -e


# 4. Instalar xfce y el resto de los paquetes
sudo pacman -S --noconfirm \
  xorg-server \
  xorg-apps \
  xfce4 \
  xfce4-goodies \
  xfce4-panel-profiles \
  xfce4-whiskermenu-plugin \
  xfce4-docklike-plugin \
  xfce4-windowck-plugin \
  xfce4-places-plugin \
  plank \
  python-gobject \
  dbus \
  lightdm \
  lightdm-gtk-greeter \
  pipewire-pulse \
  wireplumber \
  pavucontrol \
  network-manager-applet \
  amd-ucode \
  intel-ucode \
  atril \
  vlc \
  xarchiver \
  unrar \
  p7zip \
  chromium \
  firefox \
  firefox-i18n-es-ar \
  libreoffice-fresh-es \
  hunspell-es_uy \
  telegram-desktop \
  zsh \
  zsh-completions \
  fastfetch \
  ntfs-3g \
  archlinux-tweak-tool-gtk4 \
  terminology \
  vlc-plugins-all \
  hardinfo2 \
  mpv \
  btop \
  gparted \
  nano \
  ulauncher \
  audacious \
  shelly \
  os-prober

# ==========================================
# . INSTALACIÓN DE YAY Y PAQUETES AUR
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
yay -S stacer-bin --noconfirm

# 5. Configurar GRUB para detectar otros sistemas operativos
sudo sed -i.bak 's/#\?\(GRUB_DISABLE_OS_PROBER=\).*/\1false/' /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg

# 6. Habilitar el gestor de inicio
sudo systemctl enable lightdm

# ==========================================
# 7. LIMPIEZA Y RESUMEN FINAL
# ==========================================
rm -rf "$HOME/LinuxScripts"

echo "======================================================"
echo " Instalación y configuración completadas con éxito."
echo " Display manager configurado: LightDM (GTK Greeter)"
echo " Entorno de escritorio: XFCE 4 + xfce4-goodies"
echo " Repositorios habilitados: multilib, chaotic-aur"
echo " Gestor de paquetes AUR: yay"
echo " GRUB: os-prober habilitado (detección de otros SO)"
echo " Respaldo de pacman.conf: /etc/pacman.conf.bak_repos"
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
