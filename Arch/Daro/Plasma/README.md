# PLASMA

Plasma es un entorno de escritorio (desktop environment) desarrollado por la comunidad KDE, uno de los más usados en Linux junto a GNOME.

Características principales

Muy personalizable: casi todos los elementos visuales (paneles, iconos, temas, efectos, widgets) se pueden modificar desde la interfaz gráfica, sin necesidad de terminal.

Liviano y rápido: en general consume menos recursos que GNOME, lo que lo hace popular tanto en equipos modestos como en equipos potentes donde se busca rendimiento.

Basado en Qt/KDE Frameworks: usa las librerías Qt en vez de GTK (que usa GNOME), lo que define el aspecto y comportamiento de sus aplicaciones nativas.

Creamos tres scripts post instalacion los cuales son **plasma-sinergia**, **plasma-full** y **plasma-monocrome**, los tres incorporan por defecto los repositorios de Nemesis, Chaotic y Multilib. 

**Nemesis repo (kiro)**: fue creado por Erik Dubois, un desarrollador belga bastante conocido en la comunidad Arch por ser el creador original de ArcoLinux, una distribución educativa basada en Arch orientada a enseñar cómo funciona el sistema por dentro. La razon por la cual decidimos que el repositorio inicie por defecto es para que el script pueda instalar Archlinux Tweak Tool, una herramienta muy potente que nos permite configurar el sistema con un par de click, una verdadera navaja suiza. 

**Chaotic-AUR**: es un repositorio no oficial de paquetes precompilados para Arch Linux, que automatiza el proceso de compilación de paquetes del AUR.

La mayoría de los paquetes disponibles en Chaotic-AUR se compilan automáticamente a partir de su respectivo paquete fuente del AUR, y el resultado se distribuye como binario listo para instalar, tal como cualquier paquete oficial de los repos, esto nos permite acceder a aplicaciones que no estan en los repositorios oficiales y poder instalarlas desde el scripts.

Principales virtudes

Ahorro de tiempo masivo: evita compilar paquetes pesados localmente (kernels personalizados, navegadores, drivers), ya que vienen precompilados — su propio lema es "construyendo paquetes AUR para vos, para que no tengas que hacerlo tú mismo". 

Firmado y verificado: según el wiki de Arch, soporta deltas de paquetes y firma tanto de paquetes como de la base de datos, lo que da una capa de integridad extra frente a compilar a ciegas desde el AUR. 

Transparencia del proceso: su sitio web permite ver en vivo el estado y tiempo estimado de cada build, buscar y descargar logs de compilación, y consultar el historial completo de despliegues y estadísticas de los últimos años. 

Mejora continua de seguridad: el equipo reporta activamente haber detectado y bloqueado inyecciones de contenido malicioso en paquetes del AUR antes de que lleguen a desplegarse, aunque también advierten a los usuarios que sigan auditando lo que instalan. 

Paquetes especializados no disponibles oficialmente: por ejemplo, ofrece versiones de kernels con parches para dar soporte a drivers NVIDIA compatibles con todos los kernels del repositorio, algo que no siempre está cubierto por los paquetes oficiales de Arch. 

**Multilib**: es un repositorio oficial de Arch Linux (mantenido por el propio proyecto, no de terceros) que provee paquetes de 32 bits para poder ejecutarlos en un sistema de 64 bits.

La razón principal

Arch Linux es una distribución puramente x86_64 (64 bits) desde hace años. Todo lo que instalás por defecto, el kernel, las librerías del sistema, las apps son de 64 bits. El problema es que todavía existe software de 32 bits que necesita sus propias versiones de las librerías del sistema (glibc, libGL, etc.) para funcionar, y esas versiones de 32 bits no vienen incluidas en la instalación base y multilib provee justamente esas librerías compiladas en 32 bits, para que un sistema de 64 bits pueda ejecutar binarios de 32 bits sin problemas.

Casos típicos donde lo necesitás

Juegos y Steam/Proton: una enorme cantidad de juegos (sobre todo viejos, o vía Wine/Proton) siguen siendo binarios de 32 bits o dependen de librerías de 32 bits.
Wine: para ejecutar aplicaciones y juegos de Windows, Wine necesita las contrapartes de 32 bits de muchas librerías del sistema, incluso corriendo programas de 64 bits.

Drivers gráficos (NVIDIA/AMD): los drivers propietarios de NVIDIA, por ejemplo, requieren el paquete lib32-nvidia-utils para que las apps de 32 bits puedan usar aceleración gráfica correctamente.

Software heredado (legacy): algunas herramientas viejas de empresas, emuladores, o binarios distribuidos solo en 32 bits.

**Yay**: viene preinstalado y "activado" por defecto.


## PLASMA SINERGIA (plasma-sinergia.sh)

![Plasma-Sinergia](https://raw.githubusercontent.com/elcuchy/Sinergia/refs/heads/main/Sinergia/images/Plasma-sinergia.png)

Incorpora los repositorios nemesis y Chaotic-aur

Nemesis_repo (Kiro): repositorio de bootstrap temporal que se usa únicamente para instalar kiro-keyring y kiro-mirrorlist. Una vez instalados esos paquetes, el script reemplaza la línea Server= original por Include = /etc/pacman.d/kiro-mirrorlist, es decir, usa el repo temporal solo como "puente" para obtener la lista de espejos oficial de Kiro.

Chaotic-aur: repositorio binario precompilado de paquetes AUR populares. Se importa su llave PGP, se instalan sus paquetes keyring y mirrorlist directamente vía URL (sin necesidad de agregarlo antes al pacman.conf), y recién después se agrega la sección [chaotic-aur]. Esto acelera muchísimo la instalación de paquetes AUR, ya que evita compilarlos localmente para los que ya están en Chaotic-AUR.

.

En resumen: es la versión funcional y liviana, pensada para quien quiere un Arch+Plasma operativo con acceso a Chaotic-AUR y AUR habilitado desde el primer arranque, sin el "maquillaje" visual de las otras dos variantes.



## PLASMA FULL (plasma-full.sh)

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



