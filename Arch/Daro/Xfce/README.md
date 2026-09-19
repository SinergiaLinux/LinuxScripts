# XFCE 

Es un entorno de escritorio conocido por ser ligero, rápido y muy configurable. Está pensado para consumir pocos recursos de memoria y procesador, por lo que funciona muy bien en equipos antiguos o modestos, aunque también es una buena opción en máquinas potentes si se prefiere un entorno sencillo y estabile, con flexibilidad para personalizar la apariencia.
Su diseño es modular: incluye un gestor de ventanas (Xfwm), un panel personalizable, un gestor de archivos (Thunar), un gestor de configuración y otras herramientas que se pueden usar por separado. Sigue una filosofía tradicional de escritorio, con menús, paneles y ventanas, sin efectos pesados ni cambios bruscos de interfaz.

Creamos tres scripts post instalacion los cuales son **xfce-sinergia**, **xfce-full** y **xfce-monochrome**, los tres incorporan por defecto los repositorios de Nemesis, Chaotic y Multilib.

**Nemesis repo (Kiro)**

Fue creado por Erik Dubois, un desarrollador belga bastante conocido en la comunidad Arch por ser el creador original de ArcoLinux, una distribución educativa basada en Arch orientada a enseñar cómo funciona el sistema por dentro. La razon por la cual decidimos que el repositorio inicie por defecto es para que el script pueda instalar Archlinux Tweak Tool, una herramienta muy potente que nos permite configurar el sistema con un par de click, una verdadera navaja suiza.

**Chaotic-AUR**

Es un repositorio no oficial de paquetes precompilados para Arch Linux, que automatiza el proceso de compilación de paquetes del AUR.

La mayoría de los paquetes disponibles en Chaotic-AUR se compilan automáticamente a partir de su respectivo paquete fuente del AUR, y el resultado se distribuye como binario listo para instalar, tal como cualquier paquete oficial de los repos, esto nos permite acceder a aplicaciones que no estan en los repositorios oficiales y poder instalarlas desde el scripts.

<ins>Principales virtudes</ins>

Ahorro de tiempo masivo: evita compilar paquetes pesados localmente (kernels personalizados, navegadores, drivers), ya que vienen precompilados — su propio lema es "construyendo paquetes AUR para vos, para que no tengas que hacerlo tú mismo".

Firmado y verificado: según el wiki de Arch, soporta deltas de paquetes y firma tanto de paquetes como de la base de datos, lo que da una capa de integridad extra frente a compilar a ciegas desde el AUR.

Transparencia del proceso: su sitio web permite ver en vivo el estado y tiempo estimado de cada build, buscar y descargar logs de compilación, y consultar el historial completo de despliegues y estadísticas de los últimos años.

Mejora continua de seguridad: el equipo reporta activamente haber detectado y bloqueado inyecciones de contenido malicioso en paquetes del AUR antes de que lleguen a desplegarse, aunque también advierten a los usuarios que sigan auditando lo que instalan.

Paquetes especializados no disponibles oficialmente: por ejemplo, ofrece versiones de kernels con parches para dar soporte a drivers NVIDIA compatibles con todos los kernels del repositorio, algo que no siempre está cubierto por los paquetes oficiales de Arch.

**Multilib**

Es un repositorio oficial de Arch Linux (mantenido por el propio proyecto, no de terceros) que provee paquetes de 32 bits para poder ejecutarlos en un sistema de 64 bits.

Arch Linux es una distribución puramente x86_64 (64 bits) desde hace años. Todo lo que instalás por defecto, el kernel, las librerías del sistema, las apps son de 64 bits. El problema es que todavía existe software de 32 bits que necesita sus propias versiones de las librerías del sistema (glibc, libGL, etc.) para funcionar, y esas versiones de 32 bits no vienen incluidas en la instalación base y multilib provee justamente esas librerías compiladas en 32 bits, para que un sistema de 64 bits pueda ejecutar binarios de 32 bits sin problemas.

<ins>Casos típicos donde lo necesitás</ins>

Juegos y Steam/Proton: una enorme cantidad de juegos (sobre todo viejos, o vía Wine/Proton) siguen siendo binarios de 32 bits o dependen de librerías de 32 bits. Wine: para ejecutar aplicaciones y juegos de Windows, Wine necesita las contrapartes de 32 bits de muchas librerías del sistema, incluso corriendo programas de 64 bits.

Drivers gráficos (NVIDIA/AMD): los drivers propietarios de NVIDIA, por ejemplo, requieren el paquete lib32-nvidia-utils para que las apps de 32 bits puedan usar aceleración gráfica correctamente.

Software heredado (legacy): algunas herramientas viejas de empresas, emuladores, o binarios distribuidos solo en 32 bits.

**Yay**

Es una herramienta que te deja instalar programas en Arch Linux desde el AUR (una especie de "tienda comunitaria" de aplicaciones que la gente sube, pero que no vienen ya armadas, hay que compilarlas).

Como yay no viene instalado por defecto en Arch el script se encarga de "activarlo" por defecto.

## XFCE SINERGIA (xfce-sinergia.sh)

Es una versión basica, pensada para quien quiere un Arch+Xfce operativo con las aplicaciones necesarias para el uso diario con acceso a Chaotic-AUR y AUR habilitado desde el primer arranque.

Es un script de post-instalación para Arch Linux que deja un escritorio XFCE listo para usar. 

<ins>Hace lo siguiente:</ins>

Pacman: hace un respaldo de pacman.conf, activa ILoveCandy y las descargas paralelas, y habilita el repositorio multilib.

Repositorios extra: agrega nemesis_repo (Kiro), con su clave PGP, keyring y mirrorlist, y chaotic-aur, con su clave, keyring y mirrorlist.

AUR: compila e instala yay y luego stacer-bin.

GRUB: habilita os-prober para detectar otros sistemas operativos y regenera la configuración.

Cierre: habilita LightDM, borra ~/LinuxScripts.

**Aplicaciones y paquetes que instala el script**

<ins>Escritorio (XFCE)</ins>

xfce4, xfce4-goodies, xfce4-panel-profiles
Plugins de panel: xfce4-whiskermenu-plugin, xfce4-docklike-plugin, xfce4-windowck-plugin, xfce4-places-plugin
plank (dock) y ulauncher (lanzador)

<ins>Sesión y base del sistema</ins>

xorg-server, xorg-apps, dbus, python-gobject
lightdm y lightdm-gtk-greeter
amd-ucode, intel-ucode, os-prober

<ins>Audio y red</ins>

pipewire-pulse, wireplumber, pavucontrol
network-manager-applet

<ins>Internet</ins>

firefox (con firefox-i18n-es-ar), chromium, telegram-desktop

<ins>Oficina y documentos</ins>

libreoffice-fresh-es, hunspell-es_uy, atril (visor de PDF)

<ins>Multimedia</ins>

vlc, vlc-plugins-all, mpv, audacious

<ins>Archivos y compresión</ins>

xarchiver, unrar, p7zip, ntfs-3g

<ins>Terminal y shell</ins>

zsh, zsh-completions, terminology, nano, fastfetch, btop

<ins>Herramientas de sistema</ins>

gparted, hardinfo2, archlinux-tweak-tool-gtk4, shelly

<ins>Desarrollo y AUR</ins>

base-devel, git, yay
stacer-bin (desde el AUR, para limpieza y monitoreo)

<ins>Repositorios</ins>

kiro-keyring y kiro-mirrorlist
chaotic-keyring y chaotic-mirrorlist

## XFCE FULL (xfce-full.sh)

Es una versión ampliada del script anterior: además de instalar XFCE, ahora también lo personaliza. 

Hace lo siguiente:

Pacman y repos: respalda pacman.conf, activa ILoveCandy y descargas paralelas, y habilita multilib, nemesis_repo (Kiro) y chaotic-aur, con sus claves y mirrorlists.

Paquetes: instala Xorg, XFCE4 con goodies y plugins de panel, LightDM, PipeWire, y aplicaciones como Firefox, Chromium, LibreOffice, VLC, Telegram, OBS, Audacity, Ardour, Kdenlive, Ventoy, Transmission, GNOME Boxes y RustDesk. También instala varios temas de íconos y GTK.

AUR: compila yay como usuario normal e instala stacer-bin, aimp, iptvnator-bin y otros paquetes.

Apariencia: aplica el tema Graphite-Dark, los íconos Yaru-Teal, transparencia en la terminal y el perfil de panel openSUSE Leap 15.x con el ícono de Arch en el menú. Todo se copia también a /etc/skel, para que lo hereden los usuarios nuevos.

Fondo de pantalla: lo descarga y deja una tarea de un solo uso que lo aplica en el primer login, según el monitor detectado.

Conky Arrakis: incluye el tema embebido en base64, lo instala con sus fuentes y lo arranca en cada login. Una tarea de un solo uso ajusta la interfaz de red en el primer login.

Cierre: habilita LightDM, activa os-prober en GRUB, muestra el banner de "Sinergia / Comunidad Linuxera" y ofrece reiniciar.

Aplicaciones y paquetes que instala el script

Escritorio (XFCE)

xfce4, xfce4-goodies, xfce4-panel-profiles, xfce4-taskmanager, xfce4-screenshooter
Plugins de panel: xfce4-whiskermenu-plugin, xfce4-docklike-plugin, xfce4-windowck-plugin, xfce4-places-plugin
plank (dock), ulauncher (lanzador), conky (monitor en el escritorio)

Sesión y base del sistema

xorg-server, xorg-apps, dbus, python-gobject
lightdm, lightdm-gtk-greeter
amd-ucode, intel-ucode, os-prober
jq, playerctl, wireless_tools
base-devel, git, curl y unzip (si faltan)

Audio y red

pipewire-pulse, wireplumber, pavucontrol
network-manager-applet

Internet y comunicación

firefox (con firefox-i18n-es-ar), chromium, telegram-desktop
transmission-gtk, rustdesk-bin (escritorio remoto)

Oficina y documentos

libreoffice-fresh-es, hunspell-es_uy, atril (visor de PDF), mousepad (editor de texto)

Multimedia y creación

Reproductores: vlc, vlc-plugins-all, mpv, audacious
Producción: obs-studio, audacity, ardour, kdenlive
Servidor multimedia: rygel, tracker3-miners

Archivos y compresión

xarchiver, unrar, p7zip, ntfs-3g
Soporte de dispositivos y red: gvfs, gvfs-afc, gvfs-gphoto2, gvfs-mtp, gvfs-nfs, gvfs-smb, gvfs-dnssd, gvfs-wsdd

Terminal y shell

zsh, zsh-completions, terminology, nano, fastfetch, btop

Herramientas de sistema

gparted, hardinfo2, archlinux-tweak-tool-gtk4, shelly, ventoy
gnome-boxes (máquinas virtuales)

Temas e íconos

Íconos: papirus-icon-theme, mint-l-icons, mint-x-icons, mint-y-icons, mate-icon-theme-faenza
GTK: arc-gtk-theme, amber-theme-git, colloid-gtk-theme-git, graphite-gtk-theme-black-normal-git

AUR (con yay)

stacer-bin (limpieza y monitoreo)
sinergia-dd-burner
aimp (reproductor de audio)
iptvnator-bin (reproductor IPTV)
yaru-colors-icon-theme (íconos Yaru-Teal)
fetch-git

Repositorios

kiro-keyring, kiro-mirrorlist
chaotic-keyring, chaotic-mirrorlist


## XFCE MONOCROMATICO (xfce-monochrome.sh)
