
##GNOME SINERGIA (gnome-sinergia.sh)

![Gnome-Sinergia](https://raw.githubusercontent.com/elcuchy/Sinergia/refs/heads/main/Sinergia/images/Gnome-Sinergia.png)

Incorpora los repositorios nemesis y Chaotic-aur

Nemesis_repo (Kiro): repositorio de bootstrap temporal que se usa únicamente para instalar kiro-keyring y kiro-mirrorlist. Una vez instalados esos paquetes, el script reemplaza la línea Server= original por Include = /etc/pacman.d/kiro-mirrorlist, es decir, usa el repo temporal solo como "puente" para obtener la lista de espejos oficial de Kiro.

Chaotic-aur: repositorio binario precompilado de paquetes AUR populares. Se importa su llave PGP, se instalan sus paquetes keyring y mirrorlist directamente vía URL (sin necesidad de agregarlo antes al pacman.conf), y recién después se agrega la sección [chaotic-aur]. Esto acelera muchísimo la instalación de paquetes AUR, ya que evita compilarlos localmente para los que ya están en Chaotic-AUR.

Yay viene preinstalado y "activado" por defecto.

En resumen: es la versión funcional y liviana, pensada para quien quiere un Arch+GNOME operativo con acceso a Chaotic-AUR y AUR habilitado desde el primer arranque, sin el "maquillaje" visual de las otras dos variantes.








##GNOME FULL (gnome-full.sh) 

Este es un script de post-instalación para Arch Linux bastante completo, pensado para dejar un entorno GNOME "amigable", muchísimas extensiones estéticas (efectos de ventana, dock, menú), suite ofimática y multimedia completa en español, y herramientas de mantenimiento del sistema.



![Gnome-Full](https://raw.githubusercontent.com/elcuchy/Sinergia/refs/heads/main/Sinergia/images/Gnome-Full.png)

Configura las descargas paralelas y ILoveCandy en pacman, mejorando la experiencia y velocidad de instalación.

Importa correctamente las llaves PGP de los repos de terceros (Kiro/nemesis_repo y Chaotic-AUR)

Aplicaciones instaladas (pacman)

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

Aplicaciones instaladas vía AUR (con yay)
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











##GNOME MONOCROMATICO (gnome-monochrome.sh) 

Este script es prácticamente idéntico al anterior, misma estructura, mismos repositorios, mismos paquetes de pacman y AUR, mismas extensiones de GNOME. Las únicas diferencias son puramente estéticas.

![Gnome-Mono](https://raw.githubusercontent.com/elcuchy/Sinergia/refs/heads/main/Sinergia/images/gnome-monocromatico.png)
![Gnome-Mono2](https://github.com/elcuchy/Sinergia/blob/main/Sinergia/images/gnome-monocromatico2.png?raw=true)

Cualidades de los temas monocromáticos 
Menor fatiga visual: al reducir el contraste cromático, resultan más cómodos para sesiones largas frente a la pantalla.
Aspecto profesional/minimalista: transmiten una estética "seria", muy usada en entornos de desarrollo o trabajo donde se prioriza el foco sobre la decoración.
Coherencia visual: al no depender de un color llamativo, se integran mejor con casi cualquier wallpaper o extensión visual (como los efectos de Burn My Windows o Compiz), evitando choques de color.
Mayor legibilidad de iconos: las variantes en escala de grises suelen distinguir mejor la jerarquía visual (qué está activo, qué no) porque no compiten con colores saturados.
Envejecen mejor: un tema de color vivo puede sentirse "pasado de moda" con el tiempo; el gris/monocromo tiende a mantenerse vigente más tiempo.
Menor distracción: ideal para quienes usan mucho la terminal o software técnico (btop, hardinfo2, etc.), donde el color debería reservarse para resaltar información relevante, no para el propio sistema operativo.
