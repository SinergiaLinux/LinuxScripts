**PLASMA SINERGIA** (plasma-sinergia.sh)

![Plasma-Sinergia](https://raw.githubusercontent.com/elcuchy/Sinergia/refs/heads/main/Sinergia/images/Plasma-sinergia.png)

Incorpora los repositorios nemesis y Chaotic-aur

Nemesis_repo (Kiro): repositorio de bootstrap temporal que se usa únicamente para instalar kiro-keyring y kiro-mirrorlist. Una vez instalados esos paquetes, el script reemplaza la línea Server= original por Include = /etc/pacman.d/kiro-mirrorlist, es decir, usa el repo temporal solo como "puente" para obtener la lista de espejos oficial de Kiro.

Chaotic-aur: repositorio binario precompilado de paquetes AUR populares. Se importa su llave PGP, se instalan sus paquetes keyring y mirrorlist directamente vía URL (sin necesidad de agregarlo antes al pacman.conf), y recién después se agrega la sección [chaotic-aur]. Esto acelera muchísimo la instalación de paquetes AUR, ya que evita compilarlos localmente para los que ya están en Chaotic-AUR.

Yay viene preinstalado y "activado" por defecto.

n resumen: es la versión funcional y liviana, pensada para quien quiere un Arch+Plasma operativo con acceso a Chaotic-AUR y AUR habilitado desde el primer arranque, sin el "maquillaje" visual de las otras dos variantes.



**PLASMA FULL** (plasma-full.sh)

![Plasma-Full](https://raw.githubusercontent.com/elcuchy/Sinergia/refs/heads/main/Sinergia/images/Pasma-Full.png)


gnome-sinergia.sh Este script instala el entorno de escritorio GNOME junto con una serie de paquetes útiles y extensiones para mejorar la experiencia en Arch Linux. Además, configura algunos parámetros del sistema como la habilitación de gdm (el gestor de sesiones) y la configuración de GRUB.
Descripción

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
