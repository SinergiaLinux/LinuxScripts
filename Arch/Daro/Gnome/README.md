# GNOME

GNOME es un entorno de escritorio (desktop environment) para sistemas Linux/Unix, es uno de los más usados con una filosofia de diseño , minimalista y simplificada , prioriza una interfaz limpia y sin distracciones sobre la personalización extensiva, esta basado en librerías GTK lo que define el aspecto y comportamiento de sus aplicaciones nativas., usa un paradigma de "Activities overview" (vista de actividades) en vez del típico escritorio con íconos y barra de tareas tradicional; navegación centrada en el teclado y gestos.


Creamos tres scripts post instalacion los cuales son **gnome-sinergia**, **gnome-full** y **gnome-monochrome**, los tres incorporan por defecto los repositorios de Nemesis, Chaotic y Multilib.

**Nemesis repo (Kiro)**

Fue creado por Erik Dubois, un desarrollador belga bastante conocido en la comunidad Arch por ser el creador original de ArcoLinux, una distribución educativa basada en Arch orientada a enseñar cómo funciona el sistema por dentro. La razon por la cual decidimos que el repositorio inicie por defecto es para que el script pueda instalar Archlinux Tweak Tool, una herramienta muy potente que nos permite configurar el sistema con un par de click, una verdadera navaja suiza.

**Chaotic-AUR**

Es un repositorio no oficial de paquetes precompilados para Arch Linux, que automatiza el proceso de compilación de paquetes del AUR.

La mayoría de los paquetes disponibles en Chaotic-AUR se compilan automáticamente a partir de su respectivo paquete fuente del AUR, y el resultado se distribuye como binario listo para instalar, tal como cualquier paquete oficial de los repos, esto nos permite acceder a aplicaciones que no estan en los repositorios oficiales y poder instalarlas desde el scripts.

Principales virtudes

Ahorro de tiempo masivo: evita compilar paquetes pesados localmente (kernels personalizados, navegadores, drivers), ya que vienen precompilados — su propio lema es "construyendo paquetes AUR para vos, para que no tengas que hacerlo tú mismo".

Firmado y verificado: según el wiki de Arch, soporta deltas de paquetes y firma tanto de paquetes como de la base de datos, lo que da una capa de integridad extra frente a compilar a ciegas desde el AUR.

Transparencia del proceso: su sitio web permite ver en vivo el estado y tiempo estimado de cada build, buscar y descargar logs de compilación, y consultar el historial completo de despliegues y estadísticas de los últimos años.

Mejora continua de seguridad: el equipo reporta activamente haber detectado y bloqueado inyecciones de contenido malicioso en paquetes del AUR antes de que lleguen a desplegarse, aunque también advierten a los usuarios que sigan auditando lo que instalan.

Paquetes especializados no disponibles oficialmente: por ejemplo, ofrece versiones de kernels con parches para dar soporte a drivers NVIDIA compatibles con todos los kernels del repositorio, algo que no siempre está cubierto por los paquetes oficiales de Arch.

**Multilib**

Es un repositorio oficial de Arch Linux (mantenido por el propio proyecto, no de terceros) que provee paquetes de 32 bits para poder ejecutarlos en un sistema de 64 bits.

Arch Linux es una distribución puramente x86_64 (64 bits) desde hace años. Todo lo que instalás por defecto, el kernel, las librerías del sistema, las apps son de 64 bits. El problema es que todavía existe software de 32 bits que necesita sus propias versiones de las librerías del sistema (glibc, libGL, etc.) para funcionar, y esas versiones de 32 bits no vienen incluidas en la instalación base y multilib provee justamente esas librerías compiladas en 32 bits, para que un sistema de 64 bits pueda ejecutar binarios de 32 bits sin problemas.

Casos típicos donde lo necesitás

Juegos y Steam/Proton: una enorme cantidad de juegos (sobre todo viejos, o vía Wine/Proton) siguen siendo binarios de 32 bits o dependen de librerías de 32 bits. Wine: para ejecutar aplicaciones y juegos de Windows, Wine necesita las contrapartes de 32 bits de muchas librerías del sistema, incluso corriendo programas de 64 bits.

Drivers gráficos (NVIDIA/AMD): los drivers propietarios de NVIDIA, por ejemplo, requieren el paquete lib32-nvidia-utils para que las apps de 32 bits puedan usar aceleración gráfica correctamente.

Software heredado (legacy): algunas herramientas viejas de empresas, emuladores, o binarios distribuidos solo en 32 bits.

**Yay**

Es una herramienta que te deja instalar programas en Arch Linux desde el AUR (una especie de "tienda comunitaria" de aplicaciones que la gente sube, pero que no vienen ya armadas, hay que compilarlas).

Como yay no viene instalado por defecto en Arch el script se encarga de "activarlo" por defecto.



## GNOME SINERGIA (gnome-sinergia.sh)

Es una versión funcional y liviana, pensada para quien quiere un Arch+GNOME operativo con acceso a Chaotic-AUR y AUR habilitado desde el primer arranque.

![Gnome-Sinergia](https://raw.githubusercontent.com/elcuchy/Sinergia/refs/heads/main/Sinergia/images/Gnome-Sinergia.png)

Este script instala y configura un entorno de escritorio GNOME completo en Arch Linux. 

Habilita el repositorio multilib.

Configura el repositorio nemesis_repo (Kiro): agrega el repo, importa y firma su clave PGP, instala kiro-keyring y kiro-mirrorlist, y actualiza pacman.conf para usar el mirrorlist real.

Configura Chaotic-AUR: importa y firma su clave PGP, instala el keyring y mirrorlist del repo, y lo agrega a pacman.conf.

Instala GNOME Shell junto con un conjunto amplio de aplicaciones y componentes del ecosistema GNOME, más herramientas generales del sistema.

Instala YAY (compilándolo desde AUR) y con él agrega stacer-bin más varias extensiones de GNOME Shell.

Configura GRUB: habilita os-prober.

Habilita GDM como display manager.

Limpieza y reinicio: borra la carpeta temporal y ofrece reiniciar (auto-continúa a los 15s).

**Aplicaciones/paquetes instalados**

<ins>Núcleo GNOME:</ins>

gnome-shell, gnome-tweaks, gdm, gnome-session, gnome-settings-daemon, gnome-control-center, gnome-shell-extensions, gnome-keyring, gnome-menus

<ins>Apps y utilidades de GNOME:</ins>

gnome-characters, gnome-backgrounds, gnome-calendar, gnome-clocks, gnome-connections, gnome-font-viewer, gnome-logs, gnome-maps, gnome-remote-desktop, gnome-color-manager, gnome-disk-utility, gnome-system-monitor, gnome-text-editor, gnome-user-docs, gnome-user-share, loupe, sushi, tecla, yelp, baobab, evince, nautilus

<ins>Terminal y gestión de archivos:</ins>

alacritty (terminal), rygel, tracker3-miners, xdg-desktop-portal, xdg-user-dirs-gtk, gvfs, gvfs-dnssd, gvfs-wsdd, gvfs-afc, gvfs-goa, gvfs-gphoto2, gvfs-mtp, gvfs-nfs, gvfs-smb, grilo-plugins, gnome-terminal-transparency, gnome-browser-connector

<ins>Sistema:</ins>

amd-ucode, intel-ucode, ntfs-3g, os-prober, pacman-contrib, archlinux-tweak-tool-gtk4, btop, nano

<ins>Multimedia:</ins>

vlc, vlc-plugins-all

<ins>Torrents:</ins>

fragments (cliente BitTorrent para GNOME)

<ins>Comunicación:</ins>

telegram-desktop

<ins>Compresión:</ins>

file-roller, unrar, p7zip

<ins>Navegador y ofimática:</ins>

firefox, firefox-i18n-es-ar, libreoffice-fresh-es, hunspell-es_uy

<ins>Extensiones GNOME Shell (repos oficiales/Chaotic-AUR):</ins>

gnome-shell-extension-arch-update, gnome-shell-extension-dash-to-dock

<ins>Fuentes:</ins>

ttf-firacode-nerd

<ins>Gestión de paquetes:</ins>

pamac-aur, yay (compilado desde AUR)

<ins>Utilidades (AUR vía yay):</ins>

stacer-bin,

<ins>Extensiones GNOME Shell adicionales (AUR vía yay):</ins>

gnome-shell-extension-dash2dock-lite, gnome-shell-extension-compiz-alike-magic-lamp-effect-git, gnome-shell-extension-compiz-windows-effect-git, gnome-shell-extension-arc-menu-git, gnome-shell-extension-astra-monitor, gnome-shell-extension-burn-my-windows, gnome-shell-extension-coverflow-alt-tab-git

<ins>Dependencias de compilación:</ins>

base-devel, git

 

## GNOME FULL (gnome-full.sh) 

Este es un script de post-instalación para Arch Linux bastante completo, pensado para dejar un entorno GNOME "amigable", muchísimas extensiones estéticas (efectos de ventana, dock, menú), suite ofimática y multimedia completa en español, y herramientas de mantenimiento del sistema.



![Gnome-Full](https://raw.githubusercontent.com/elcuchy/Sinergia/refs/heads/main/Sinergia/images/Gnome-Full.png)

Configura las descargas paralelas y ILoveCandy en pacman, mejorando la experiencia y velocidad de instalación.

Importa correctamente las llaves PGP de los repos de terceros (Kiro/nemesis_repo y Chaotic-AUR)

**Aplicaciones instaladas**


Escritorio GNOME (pacman)

gnome-shell, gnome-tweaks, gdm, gnome-session, gnome-control-center, gnome-settings-daemon
Nautilus (archivos), gnome-terminal-transparency, Alacritty, gnome-text-editor, gedit
Utilidades: Calculadora, Calendario, Relojes, Mapas, Caracteres, Registros, Monitor del sistema, Discos, Visor de fuentes, Baobab, Conexiones, Boxes, Yelp, Snapshot, Decibels, Tecla
Visores: Loupe (imágenes), Evince (PDF), Sushi (vista previa)
Extras GNOME: gnome-browser-connector, gnome-shell-extensions, gnome-backgrounds, gnome-color-manager, gnome-keyring, gnome-remote-desktop, gnome-user-docs, gnome-user-share, dconf-editor, tracker3-miners, grilo-plugins, rygel

Multimedia y productividad

VLC (con todos los plugins), mpv
OBS Studio, Audacity, Ardour, Kdenlive
Firefox (con idioma es-AR), LibreOffice Fresh (es), hunspell-es_uy
Telegram Desktop, Fragments (torrents)
RustDesk (escritorio remoto)

Sistema y herramientas

GParted, Ventoy, btop, fastfetch, hardinfo2, nano
File Roller, unrar, p7zip, ntfs-3g, os-prober
pamac-aur, archlinux-tweak-tool-gtk4, pacman-contrib
amd-ucode e intel-ucode, xorg-xrandr
base-devel, git, jq, unzip, curl
Soporte de archivos: gvfs (con afc, goa, gphoto2, mtp, nfs, smb, dnssd, wsdd), xdg-desktop-portal, xdg-user-dirs-gtk

Temas, iconos y fuentes

Papirus, Mint-L, Mint-X, Mint-Y, Faenza (mate-icon-theme-faenza)
ttf-firacode-nerd

Extensiones de GNOME desde pacman

Dash to Dock, Arch Update

AUR (vía yay)

yay (se compila primero)
Stacer, Sinergia DD Burner, IPTVnator, Yaru Colors Icon Theme (incluye Yaru-Deepblue), fetch-git, Gapless

Extensiones desde extensions.gnome.org

Magic Lamp Effect, Compiz Windows Effect, ArcMenu, Astra Monitor, Burn My Windows, Coverflow Alt-Tab, Dash2Dock Lite, Desktop Cube

Aplicaciones instaladas desde otros repositorios: hardinfo2, pamac-aur, rustdesk-bin y archlinux-tweak-tool-gtk4 no están en los repos oficiales de Arch, así que dependen de Chaotic-AUR o de Kiro para instalarse.

Atajos de teclado para lanzadores de aplicaciones: 

Menu de gnome o lanzador de aplicaciones con la telca super o tambien conocida como la tecla del "tio bill"

Lanzador de aplicaciones Arc Menu con la combinacion de teclas Ctrl+Espacio





## GNOME MONOCROMATICO (gnome-monochrome.sh) 

Este script es prácticamente idéntico al anterior, misma estructura, mismos repositorios, mismos paquetes de pacman y AUR, mismas extensiones de GNOME. Las únicas diferencias son puramente estéticas.

![Gnome-Mono](https://raw.githubusercontent.com/elcuchy/Sinergia/refs/heads/main/Sinergia/images/gnome-monocromatico.png)
![Gnome-Mono2](https://github.com/elcuchy/Sinergia/blob/main/Sinergia/images/gnome-monocromatico2.png?raw=true)

**Cualidades de los temas monocromáticos**

Menor fatiga visual: al reducir el contraste cromático, resultan más cómodos para sesiones largas frente a la pantalla.

Aspecto profesional/minimalista: transmiten una estética "seria", muy usada en entornos de desarrollo o trabajo donde se prioriza el foco sobre la decoración.

Coherencia visual: al no depender de un color llamativo, se integran mejor con casi cualquier wallpaper o extensión visual (como los efectos de Burn My Windows o Compiz), evitando choques de color.

Mayor legibilidad de iconos: las variantes en escala de grises suelen distinguir mejor la jerarquía visual (qué está activo, qué no) porque no compiten con colores saturados.

Envejecen mejor: un tema de color vivo puede sentirse "pasado de moda" con el tiempo; el gris/monocromo tiende a mantenerse vigente más tiempo.

Menor distracción: ideal para quienes usan mucho la terminal o software técnico (btop, hardinfo2, etc.), donde el color debería reservarse para resaltar información relevante, no para el propio sistema operativo.

Aplicaciones instaladas 

Escritorio GNOME (pacman)

gnome-shell, gnome-tweaks, gdm, gnome-session, gnome-control-center, gnome-settings-daemon
Nautilus, gnome-terminal-transparency, Alacritty, gnome-text-editor, gedit
Utilidades: Calculadora, Calendario, Relojes, Mapas, Caracteres, Registros, Monitor del sistema, Discos, Visor de fuentes, Baobab, Conexiones, Boxes, Yelp, Snapshot, Decibels, Tecla
Visores: Loupe (imágenes), Evince (PDF), Sushi (vista previa)
Extras GNOME: gnome-browser-connector, gnome-shell-extensions, gnome-backgrounds, gnome-color-manager, gnome-keyring, gnome-remote-desktop, gnome-user-docs, gnome-user-share, dconf-editor, tracker3-miners, grilo-plugins, rygel

Multimedia y productividad

VLC (con todos los plugins), mpv
OBS Studio, Audacity, Ardour, Kdenlive
Firefox (es-AR), LibreOffice Fresh (es), hunspell-es_uy
Telegram Desktop, Fragments (torrents)
RustDesk

Sistema y herramientas

GParted, Ventoy, btop, fastfetch, hardinfo2, nano
File Roller, unrar, p7zip, ntfs-3g, os-prober
pamac-aur, archlinux-tweak-tool-gtk4, pacman-contrib
amd-ucode, intel-ucode, xorg-xrandr
base-devel, git, jq, unzip, curl
gvfs (afc, goa, gphoto2, mtp, nfs, smb, dnssd, wsdd), xdg-desktop-portal, xdg-user-dirs-gtk

Temas, iconos y fuentes

Papirus, Mint-L, Mint-X, Mint-Y, Faenza
ttf-firacode-nerd

Extensiones desde pacman

Dash to Dock, Arch Update

AUR (vía yay)

yay (se compila primero)
Stacer, Sinergia DD Burner, IPTVnator, Yaru Colors Icon Theme (incluye Yaru-Grey), fetch-git, Gapless

Extensiones desde extensions.gnome.org

Magic Lamp Effect, Compiz Windows Effect, ArcMenu, Astra Monitor, Burn My Windows, Coverflow Alt-Tab, Dash2Dock Lite, Desktop Cube (activadas desde el inicio)

Aplicaciones instaladas desde otros repositorios: hardinfo2, pamac-aur, rustdesk-bin y archlinux-tweak-tool-gtk4 no están en los repos oficiales, así que dependen de Chaotic-AUR o Kiro.

Atajos de teclado para lanzadores de aplicaciones: 

Menu de gnome o lanzador de aplicaciones con la telca super o tambien conocida como la tecla del "tio bill"

Lanzador de aplicaciones Arc Menu con la combinacion de teclas Ctrl+Espacio
