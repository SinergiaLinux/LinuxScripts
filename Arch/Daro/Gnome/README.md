# GNOME

GNOME es un entorno de escritorio (desktop environment) para sistemas Linux/Unix, es uno de los más usados con una filosofia de diseño , minimalista y simplificada , prioriza una interfaz limpia y sin distracciones sobre la personalización extensiva, esta basado en librerías GTK lo que define el aspecto y comportamiento de sus aplicaciones nativas., usa un paradigma de "Activities overview" (vista de actividades) en vez del típico escritorio con íconos y barra de tareas tradicional; navegación centrada en el teclado y gestos.


Creamos tres scripts post instalacion los cuales son **gnome-sinergia**, **gnome-full** y **gnome-monochrome**, los tres incorporan por defecto los repositorios de Nemesis, Chaotic y Multilib.

Nemesis repo (Kiro)

Fue creado por Erik Dubois, un desarrollador belga bastante conocido en la comunidad Arch por ser el creador original de ArcoLinux, una distribución educativa basada en Arch orientada a enseñar cómo funciona el sistema por dentro. La razon por la cual decidimos que el repositorio inicie por defecto es para que el script pueda instalar Archlinux Tweak Tool, una herramienta muy potente que nos permite configurar el sistema con un par de click, una verdadera navaja suiza.

Chaotic-AUR

Es un repositorio no oficial de paquetes precompilados para Arch Linux, que automatiza el proceso de compilación de paquetes del AUR.

La mayoría de los paquetes disponibles en Chaotic-AUR se compilan automáticamente a partir de su respectivo paquete fuente del AUR, y el resultado se distribuye como binario listo para instalar, tal como cualquier paquete oficial de los repos, esto nos permite acceder a aplicaciones que no estan en los repositorios oficiales y poder instalarlas desde el scripts.

Principales virtudes

Ahorro de tiempo masivo: evita compilar paquetes pesados localmente (kernels personalizados, navegadores, drivers), ya que vienen precompilados — su propio lema es "construyendo paquetes AUR para vos, para que no tengas que hacerlo tú mismo".

Firmado y verificado: según el wiki de Arch, soporta deltas de paquetes y firma tanto de paquetes como de la base de datos, lo que da una capa de integridad extra frente a compilar a ciegas desde el AUR.

Transparencia del proceso: su sitio web permite ver en vivo el estado y tiempo estimado de cada build, buscar y descargar logs de compilación, y consultar el historial completo de despliegues y estadísticas de los últimos años.

Mejora continua de seguridad: el equipo reporta activamente haber detectado y bloqueado inyecciones de contenido malicioso en paquetes del AUR antes de que lleguen a desplegarse, aunque también advierten a los usuarios que sigan auditando lo que instalan.

Paquetes especializados no disponibles oficialmente: por ejemplo, ofrece versiones de kernels con parches para dar soporte a drivers NVIDIA compatibles con todos los kernels del repositorio, algo que no siempre está cubierto por los paquetes oficiales de Arch.

Multilib

Es un repositorio oficial de Arch Linux (mantenido por el propio proyecto, no de terceros) que provee paquetes de 32 bits para poder ejecutarlos en un sistema de 64 bits.

Arch Linux es una distribución puramente x86_64 (64 bits) desde hace años. Todo lo que instalás por defecto, el kernel, las librerías del sistema, las apps son de 64 bits. El problema es que todavía existe software de 32 bits que necesita sus propias versiones de las librerías del sistema (glibc, libGL, etc.) para funcionar, y esas versiones de 32 bits no vienen incluidas en la instalación base y multilib provee justamente esas librerías compiladas en 32 bits, para que un sistema de 64 bits pueda ejecutar binarios de 32 bits sin problemas.

Casos típicos donde lo necesitás

Juegos y Steam/Proton: una enorme cantidad de juegos (sobre todo viejos, o vía Wine/Proton) siguen siendo binarios de 32 bits o dependen de librerías de 32 bits. Wine: para ejecutar aplicaciones y juegos de Windows, Wine necesita las contrapartes de 32 bits de muchas librerías del sistema, incluso corriendo programas de 64 bits.

Drivers gráficos (NVIDIA/AMD): los drivers propietarios de NVIDIA, por ejemplo, requieren el paquete lib32-nvidia-utils para que las apps de 32 bits puedan usar aceleración gráfica correctamente.

Software heredado (legacy): algunas herramientas viejas de empresas, emuladores, o binarios distribuidos solo en 32 bits.

Yay

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

Aplicaciones/paquetes instalados

Núcleo GNOME:

gnome-shell, gnome-tweaks, gdm, gnome-session, gnome-settings-daemon, gnome-control-center, gnome-shell-extensions, gnome-keyring, gnome-menus

Apps y utilidades de GNOME:

gnome-characters, gnome-backgrounds, gnome-calendar, gnome-clocks, gnome-connections, gnome-font-viewer, gnome-logs, gnome-maps, gnome-remote-desktop, gnome-color-manager, gnome-disk-utility, gnome-system-monitor, gnome-text-editor, gnome-user-docs, gnome-user-share, loupe, sushi, tecla, yelp, baobab, evince, nautilus

Terminal y gestión de archivos:

alacritty (terminal), rygel, tracker3-miners, xdg-desktop-portal, xdg-user-dirs-gtk, gvfs, gvfs-dnssd, gvfs-wsdd, gvfs-afc, gvfs-goa, gvfs-gphoto2, gvfs-mtp, gvfs-nfs, gvfs-smb, grilo-plugins, gnome-terminal-transparency, gnome-browser-connector

Sistema:

amd-ucode, intel-ucode, ntfs-3g, os-prober, pacman-contrib, archlinux-tweak-tool-gtk4, btop, nano

Multimedia:

vlc, vlc-plugins-all

Torrents:

fragments (cliente BitTorrent para GNOME)

Comunicación:

telegram-desktop

Compresión:

file-roller, unrar, p7zip

Navegador y ofimática:

firefox, firefox-i18n-es-ar, libreoffice-fresh-es, hunspell-es_uy

Extensiones GNOME Shell (repos oficiales/Chaotic-AUR):

gnome-shell-extension-arch-update, gnome-shell-extension-dash-to-dock

Fuentes:

ttf-firacode-nerd

Gestión de paquetes:

pamac-aur, yay (compilado desde AUR)

Utilidades (AUR vía yay):

stacer-bin,

Extensiones GNOME Shell adicionales (AUR vía yay):

gnome-shell-extension-dash2dock-lite, gnome-shell-extension-compiz-alike-magic-lamp-effect-git, gnome-shell-extension-compiz-windows-effect-git, gnome-shell-extension-arc-menu-git, gnome-shell-extension-astra-monitor, gnome-shell-extension-burn-my-windows, gnome-shell-extension-coverflow-alt-tab-git

Dependencias de compilación:

base-devel, git

 

## GNOME FULL (gnome-full.sh) 

Este es un script de post-instalación para Arch Linux bastante completo, pensado para dejar un entorno GNOME "amigable", muchísimas extensiones estéticas (efectos de ventana, dock, menú), suite ofimática y multimedia completa en español, y herramientas de mantenimiento del sistema.



![Gnome-Full](https://raw.githubusercontent.com/elcuchy/Sinergia/refs/heads/main/Sinergia/images/Gnome-Full.png)

Configura las descargas paralelas y ILoveCandy en pacman, mejorando la experiencia y velocidad de instalación.

Importa correctamente las llaves PGP de los repos de terceros (Kiro/nemesis_repo y Chaotic-AUR)

**Aplicaciones instaladas (pacman)**

Entorno de escritorio y base GNOME: gnome-shell, gdm, nautilus, gnome-control-center, gnome-tweaks, gnome-terminal, gnome-text-editor, gnome-system-monitor, gnome-disk-utility, gnome-calculator, gnome-calendar, gnome-clocks, gnome-maps, gnome-characters, gnome-logs, gnome-remote-desktop, gnome-connections, entre otros componentes estándar de GNOME.

Utilidades del sistema: baobab (analizador de disco), gparted, dconf-editor, hardinfo2, fastfetch, btop, pacman-contrib, archlinux-tweak-tool-gtk4, ntfs-3g, os-prober.

Multimedia y creatividad: vlc + plugins, mpv, obs-studio (grabación/streaming), audacity (audio), ardour (producción de audio), kdenlive (edición de video), decibels, snapshot (cámara).

Productividad y oficina: libreoffice-fresh-es (con idioma español), hunspell-es_uy (corrector en español uruguayo), evince (lector PDF), file-roller/unrar/p7zip (compresión).

Navegación y comunicación: firefox + idioma español, telegram-desktop, rustdesk-bin (acceso remoto), gnome-browser-connector.

Temas visuales: papirus-icon-theme, mint-l/x/y-icons, mate-icon-theme-faenza (variedad de iconos para personalizar).

Grabadora/quemado de discos: ventoy (USB booteables). 

Gestor de paquetes gráfico: pamac-aur.

Tipografía: ttf-firacode-nerd (fuente para terminal con íconos).

Firmware/microcódigo: amd-ucode, intel-ucode (soporte para ambas arquitecturas de CPU).

**Aplicaciones instaladas vía AUR (con yay)**

stacer-bin – monitor/optimizador del sistema con interfaz gráfica.

gnome-shell-extension-dash2dock-lite – dock alternativo liviano.

gnome-shell-extension-compiz-alike-magic-lamp-effect-git – efecto "lámpara mágica" al minimizar ventanas (estilo Compiz).

gnome-shell-extension-compiz-windows-effect-git – efectos de ventana estilo Compiz.

gnome-shell-extension-arc-menu-git – menú de aplicaciones estilo Windows/clásico.

gnome-shell-extension-astra-monitor – monitor de recursos del sistema en la barra superior.

gnome-shell-extension-burn-my-windows – efectos visuales al cerrar ventanas (fuego, matrix, hexágono, etc.).

gnome-shell-extension-coverflow-alt-tab-git – alternador de ventanas estilo "coverflow" (como iTunes viejo).

sinergia-dd-burner – (grabador de discos).

aimp – reproductor de música.

iptvnator-bin – reproductor de IPTV.

yaru-colors-icon-theme – variantes de colores del tema de iconos Yaru (Ubuntu).

fetch-git – herramienta tipo neofetch.

gapless – reproductor de música simple.






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
