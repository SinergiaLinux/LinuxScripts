**PLASMA SINERGIA** (plasma-sinergia.sh)

![Plasma-Sinergia](https://raw.githubusercontent.com/elcuchy/Sinergia/refs/heads/main/Sinergia/images/Plasma-sinergia.png)

Incorpora los repositorios nemesis y Chaotic-aur

Nemesis_repo (Kiro): repositorio de bootstrap temporal que se usa únicamente para instalar kiro-keyring y kiro-mirrorlist. Una vez instalados esos paquetes, el script reemplaza la línea Server= original por Include = /etc/pacman.d/kiro-mirrorlist, es decir, usa el repo temporal solo como "puente" para obtener la lista de espejos oficial de Kiro.

Chaotic-aur: repositorio binario precompilado de paquetes AUR populares. Se importa su llave PGP, se instalan sus paquetes keyring y mirrorlist directamente vía URL (sin necesidad de agregarlo antes al pacman.conf), y recién después se agrega la sección [chaotic-aur]. Esto acelera muchísimo la instalación de paquetes AUR, ya que evita compilarlos localmente para los que ya están en Chaotic-AUR.

Yay viene preinstalado y "activado" por defecto.

En resumen: es la versión funcional y liviana, pensada para quien quiere un Arch+Plasma operativo con acceso a Chaotic-AUR y AUR habilitado desde el primer arranque, sin el "maquillaje" visual de las otras dos variantes.



**PLASMA FULL** (plasma-full.sh)

![Plasma-Full](https://raw.githubusercontent.com/elcuchy/Sinergia/refs/heads/main/Sinergia/images/Pasma-Full.png)

**Qué hace el script**

Instala y configura un entorno KDE Plasma completo sobre Arch Linux.

**Repositorios configurados**

nemesis_repo (Kiro): repo temporal de bootstrap para obtener kiro-keyring y kiro-mirrorlist, que luego reemplaza la entrada original en pacman.conf.

chaotic-aur: repositorio de paquetes AUR precompilados, con importación de llave PGP y reintentos automáticos si el keyserver falla.

**Aplicaciones instaladas (pacman)**

Escritorio y base Plasma: plasma, sddm, sddm-kcm, konsole, dolphin, kate, kcalc, kwalletmanager, yakuake, plasma-systemmonitor, powerdevil, kvantum + kvantum-qt5.

Oficina: okular, libreoffice-fresh-es, hunspell-es_uy.

Multimedia: vlc + plugins, mpv, obs-studio, audacity, ardour, kdenlive, koko.

Sistema/utilidades: hardinfo2, btop, gparted, ventoy, ark, unrar, unarchiver, unzip, p7zip, archlinux-tweak-tool-gtk4, shelly, ntfs-3g, os-prober, amd-ucode, intel-ucode.

Red y comunicación: firefox + idioma español, telegram-desktop, qbittorrent, rustdesk-bin.

Temas de iconos base: papirus-icon-theme, mint-l/x/y-icons, mate-icon-theme-faenza.

Otros: fastfetch, nano, gnome-boxes.

Se desinstala: discover (centro de software por defecto de KDE).

**Paquetes AUR (yay)**

stacer-bin, sinergia-dd-burner, iptvnator-bin, yamis-icon-theme-git, fetch-git.

**Personalización automatizada**

Tema global Breeze Dark, aplicado vía plasma-apply-lookandfeel con respaldo manual sobre kdeglobals si el comando no existe.

Iconos Vortex-Dark-Icons, descargados dinámicamente desde KDE Store (consultando la API OCS para no depender de un link que pueda vencer).

Konsole transparente (Opacity=0.85), con su propio color scheme y perfil, más el efecto Blur de KWin activado para que se vea bien.

Wallpaper "Nexus" fijado tanto en los defaults del look-and-feel como en la configuración del usuario, con intento de refresco en caliente.

Splash de arranque personalizado ("Arch Simple Blue KDE 6"), descargado desde KDE Store e instalado como paquete look-and-feel (formato correcto para Plasma 6).

SDDM por defecto.

KDE Wallet desactivado por defecto, para evitar el prompt de contraseña al iniciar aplicaciones.




**PLASMA MONOCROMATICO** (plasma-monochrome.sh)

![Plasma-MonoChrome](https://raw.githubusercontent.com/elcuchy/Sinergia/refs/heads/main/Sinergia/images/Plasma-Monochrome.png)



Este script automatiza el proceso de instalación y configuración de GNOME y varios paquetes adicionales en un sistema Arch Linux. Agregra los repositorios Nemesis, Chaotic-aur y clona de forma automatica a yay, necesario para instalar paquetes de aur. Asi mismo Instala tanto aplicaciones de GNOME como otras herramientas útiles para el sistema, optimizando la configuración del mismo para un entorno de usuario cómodo y completo.
Paquetes Instalados

    GNOME: Shell, Tweaks, Control Center, Terminal, Nautilus, y más.
    Aplicaciones: VLC, Firefox, LibreOffice, Audacity, Telegram, y otras.
    Herramientas del Sistema: Stacer, Alacritty, ArchLinux Tweak Tool y más.
    Extensiones de GNOME: Dash to Dock, Magic Lamp, Arc Menu, entre otras.

Instrucciones de Uso

Clona el repositorio.
Ejecuta el script
¡Disfruta de tu entorno GNOME!

Contribuciones

¡Las contribuciones son bienvenidas! Si deseas mejorar el script!
