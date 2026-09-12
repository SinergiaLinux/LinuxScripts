# PLASMA

Plasma es un entorno de escritorio (desktop environment) desarrollado por la comunidad KDE, uno de los más usados en Linux junto a GNOME.

Características principales

Muy personalizable: casi todos los elementos visuales (paneles, iconos, temas, efectos, widgets) se pueden modificar desde la interfaz gráfica, sin necesidad de terminal.

Liviano y rápido: en general consume menos recursos que GNOME, lo que lo hace popular tanto en equipos modestos como en equipos potentes donde se busca rendimiento.

Basado en Qt/KDE Frameworks: usa las librerías Qt en vez de GTK (que usa GNOME), lo que define el aspecto y comportamiento de sus aplicaciones nativas.

Creamos tres scripts post instalacion los cuales son **plasma-sinergia**, **plasma-full** y **plasma-monochrome**, los tres incorporan por defecto los repositorios de Nemesis, Chaotic y Multilib. 

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

Juegos y Steam/Proton: una enorme cantidad de juegos (sobre todo viejos, o vía Wine/Proton) siguen siendo binarios de 32 bits o dependen de librerías de 32 bits.
Wine: para ejecutar aplicaciones y juegos de Windows, Wine necesita las contrapartes de 32 bits de muchas librerías del sistema, incluso corriendo programas de 64 bits.

Drivers gráficos (NVIDIA/AMD): los drivers propietarios de NVIDIA, por ejemplo, requieren el paquete lib32-nvidia-utils para que las apps de 32 bits puedan usar aceleración gráfica correctamente.

Software heredado (legacy): algunas herramientas viejas de empresas, emuladores, o binarios distribuidos solo en 32 bits.

**Yay**

Es una herramienta que te deja instalar programas en Arch Linux desde el AUR (una especie de "tienda comunitaria" de aplicaciones que la gente sube, pero que no vienen ya armadas, hay que compilarlas).

Como yay no viene instalado por defecto en Arch el script se encarga de "activarlo" por defecto.


## PLASMA SINERGIA (plasma-sinergia.sh)

![Plasma-Sinergia](https://raw.githubusercontent.com/elcuchy/Sinergia/refs/heads/main/Sinergia/images/Plasma-sinergia.png)


Es una versión funcional y liviana, pensada para quien quiere un Arch+Plasma operativo con acceso a Chaotic-AUR y AUR habilitado desde el primer arranque.

Es un script de post-instalación que automatiza la configuración de un sistema con entorno KDE Plasma. 

Configura pacman: activa ILoveCandy, descargas paralelas y el repositorio multilib.

Agrega repositorios de terceros: nemesis_repo (para el keyring/mirrorlist de "Kiro") y Chaotic-AUR, importando y firmando sus claves PGP.

Instala paquetes desde los repos oficiales y Chaotic-AUR (Plasma, apps, utilidades).

Instala YAY (compilándolo desde AUR) y con él agrega stacer-bin.

Configura servicios: habilita sddm como display manager (deshabilitando otros como gdm/lightdm/entrance) y activa os-prober en GRUB para detectar otros sistemas operativos.

Limpieza y reinicio: borra carpeta temporal y ofrece reiniciar (con auto-continuar a los 15s).


**Aplicaciones/paquetes instalados**

Entorno de escritorio y sesión:

plasma, sddm, sddm-kcm, powerdevil, kwalletmanager

Utilidades del sistema:

amd-ucode, intel-ucode, ntfs-3g, archlinux-tweak-tool-gtk4, hardinfo2, btop, gparted, plasma-systemmonitor, os-prober, fastfetch

Aplicaciones de KDE / productividad:

okular (visor PDF), konsole (terminal), dolphin (gestor de archivos), kcalc (calculadora), kate (editor de texto), koko (visor de imágenes), ark (compresor)

Multimedia:

vlc, vlc-plugins-all, mpv

Compresión/archivos:

unrar, unarchiver, p7zip

Navegador y ofimática:

firefox, firefox-i18n-es-ar, libreoffice-fresh-es, hunspell-es_uy (corrector ortográfico español-Uruguay)

Comunicación:

telegram-desktop

Gestión de paquetes:

shelly, yay (compilado desde AUR)

Desde AUR (vía yay):

stacer-bin (monitor/optimizador del sistema)

Dependencias de compilación:

base-devel, git


## PLASMA FULL (plasma-full.sh)

![Plasma-Full](https://raw.githubusercontent.com/elcuchy/Sinergia/refs/heads/main/Sinergia/images/Pasma-Full.png)

Esta es una versión mucho más elaborada del script anterior: además de instalar Plasma y paquetes, aplica un theming completo y automatizado al sistema (tema global, iconos, splash, wallpaper, transparencia en Konsole) descargando recursos directamente desde KDE Store vía su API OCS. 


Utilidades iniciales: define funciones para descargar contenido de KDE Store por ID (fetch_kde_store_file) y para descomprimir archivos en varios formatos (extract_archive).

Configura pacman: ILoveCandy, descargas paralelas, multilib.

Agrega repositorios: nemesis_repo (bootstrap para Kiro), luego Chaotic-AUR con sus claves PGP.

Instala paquetes oficiales/Chaotic-AUR: Plasma completo más un set bastante más grande que el script anterior (multimedia, producción audiovisual, temas de iconos, virtualización, etc.).

Desinstala discover (el centro de software de KDE) si está presente.

Instala YAY y paquetes AUR adicionales (stacer, IPTV, tema de iconos, fetch).
Aplica Breeze Dark como tema global por defecto.

Instala y aplica el tema de iconos "Vortex-Dark-Icons" desde KDE Store, y genera un tema compuesto que hereda de este pero reemplaza el ícono del lanzador de aplicaciones por el logo de Arch Linux.

Configura Konsole con un perfil transparente por defecto (Opacity=0.85) y activa el efecto Blur de KWin.

Fija el wallpaper "Nexus" como fondo por defecto (tanto a nivel sistema como en la config del usuario).

Instala y aplica el splash de arranque "Arch Simple Blue KDE 6" desde KDE Store.

Configura SDDM como display manager (dejando su tema por defecto, sin personalizar).

KDE Wallet desactivado por defecto, para evitar el prompt de contraseña al iniciar aplicaciones.

Limpieza y reinicio: borra carpeta temporal y ofrece reiniciar (con auto-continuar a los 15s).


**Aplicaciones/paquetes instalados**

Entorno de escritorio y sesión:

plasma, sddm, sddm-kcm, powerdevil, kwalletmanager, yakuake

Utilidades del sistema:

amd-ucode, intel-ucode, ntfs-3g, archlinux-tweak-tool-gtk4, hardinfo2, btop, gparted, plasma-systemmonitor, os-prober, shelly, ventoy, gnome-boxes, rustdesk-bin

Aplicaciones de KDE / productividad:

okular, konsole, dolphin, kcalc, kate, koko, ark

Multimedia (reproducción):

vlc, vlc-plugins-all, mpv

Producción audiovisual:

obs-studio, audacity, ardour, kdenlive

Compresión/archivos:

unrar, unarchiver, unzip, p7zip

Navegador y ofimática:

firefox, firefox-i18n-es-ar, libreoffice-fresh-es, hunspell-es_uy

Comunicación:

telegram-desktop, qbittorrent

Personalización visual:

kvantum, kvantum-qt5, papirus-icon-theme, mint-l-icons, mint-x-icons, mint-y-icons, mate-icon-theme-faenza

Gestión de paquetes:

shelly, yay (compilado desde AUR)

Desde AUR (vía yay):

stacer-bin, sinergia-dd-burner, iptvnator-bin, yamis-icon-theme-git, fetch-git

Descargados directamente desde KDE Store (fuera de pacman/AUR):

Vortex-Dark-Icons (tema de iconos)
Arch Simple Blue KDE 6 (splash de Plasma)

Desinstalado:

discover

Dependencias de compilación:

base-devel, git



## PLASMA MONOCROMATICO (plasma-monochrome.sh)

![Plasma-MonoChrome](https://raw.githubusercontent.com/elcuchy/Sinergia/refs/heads/main/Sinergia/images/Plasma-Monochrome.png)

Este script es prácticamente idéntico al anterior, misma estructura, mismos repositorios, mismos paquetes de pacman y AUR, mismas extensiones de plasma con una estética oscura y monocromática como eje central de la personalización. 

Tema global: Breeze Dark, aplicado automáticamente como Look and Feel por defecto.

Iconos: Vortex-Dark-Icons, descargados dinámicamente desde KDE Store — un set de íconos en tonos oscuros/grisáceos, coherente con el resto del sistema.

Konsole con transparencia (Opacity=0.85) sobre un esquema de color basado en Breeze, reforzando la paleta oscura con el efecto Blur de KWin.

Wallpaper "Nexus" y splash "Arch Simple Blue KDE 6", ambos con tonos sobrios que acompañan el conjunto oscuro.

Incluso el ícono del lanzador de aplicaciones se reemplaza por el logo de Arch, integrado al tema de iconos oscuro en vez de quedar como un ícono de color distinto que rompa la paleta.

En conjunto, todo el sistema, terminal, iconos, tema global, splash y wallpaper, se mantiene dentro de una gama de grises/oscuros consistente, evitando acentos de color que compitan entre sí. 
Es la variante más cuidada en términos de cohesión visual monocromática, a diferencia de setups que mezclan temas claros, íconos de colores variados y acentos llamativos.



