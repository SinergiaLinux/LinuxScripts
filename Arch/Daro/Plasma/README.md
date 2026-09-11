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


Este script instala KDE Plasma sobre Arch Linux con una estética oscura y monocromática como eje central de la personalización 

Tema global: Breeze Dark, aplicado automáticamente como Look and Feel por defecto.
Iconos: Vortex-Dark-Icons, descargados dinámicamente desde KDE Store — un set de íconos en tonos oscuros/grisáceos, coherente con el resto del sistema.
Konsole con transparencia (Opacity=0.85) sobre un esquema de color basado en Breeze, reforzando la paleta oscura con el efecto Blur de KWin.
Wallpaper "Nexus" y splash "Arch Simple Blue KDE 6", ambos con tonos sobrios que acompañan el conjunto oscuro.
Incluso el ícono del lanzador de aplicaciones se reemplaza por el logo de Arch, integrado al tema de iconos oscuro en vez de quedar como un ícono de color distinto que rompa la paleta.

En conjunto, todo el sistema —terminal, iconos, tema global, splash y wallpaper— se mantiene dentro de una gama de grises/oscuros consistente, evitando acentos de color que compitan entre sí. Es la variante más cuidada en términos de cohesión visual monocromática, a diferencia de setups que mezclan temas claros, íconos de colores variados y acentos llamativos sin relación entre sí.



