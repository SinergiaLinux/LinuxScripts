# Instalación de Arch Linux desde cero con archinstall + script

**Paso 1 — Arrancar el instalador de Arch**

Bootear desde el ISO oficial de Arch Linux y, dentro de la terminal, ejecutar:

archinstall

**Paso 2 — Configurar el perfil de archinstall**

Dentro del menú interactivo de archinstall, configurar en orden:

Selecionar tu idioma, en este caso Spanish 

En localidades selecciona idioma del teclado ej. si querés todo en español seria es y en idioma local es_UY.UTF-8 (selecionar UTF de tu pais), y vamos a regresar.

Espejos y repositorios — vamos hacia repositorios opcionales y seleccionamos Multilib y vamos a regresar.

Configuracion de disco — elegir el disco y el esquema de particionado (por defecto está bien para la mayoría de los casos; usar EXT4 o BTRFS según preferencia) y vamos a regresar.

Swap — Lo dejamos por defecto como esta

Gestor de arranque — selecionamos GRUB (el script después edita /etc/default/grub, así que es importante que sea GRUB y no systemd-boot) y vamos a regresar.

Nucleos — Kernel — dejar el kernel por defecto (linux) salvo que necesites uno específico (LTS, zen, etc).

Nombre del host — archilinux por defecto esta bien ( pero podriamos cambiarlo si lo consideran necesario).

Autentication — le asignamos la contraseña a root, creamos un usuario con su respectivo nombre, le damos una contraseña, confirmamos con si para darle permisos de sudo al usuario, confirmamos y salimos, y le damos regresar.

Perfil — Tipo y selecionamos Xorg.

Aplicaciones — En caso de tener bluetooth marcamos en si, en audio marcamos pipeware, en servicio de impresion en caso de tener impresora selecionamos que si, en caso de querer un cortafuegos ufw es una buena opcion y en fuentes adicionales marcamos todo, menos las fuentes chinas, koreanas y japonesas. Vamos a regresar.

Configuracion de red — usar NetworkManager - backend predeterminado (recomendado)

Pacman — lo dejamos por defecto

Paquetes adicionales — agregamos git (tambien se podria instalar una vez iniciado el sistema)

Zona horaria — configurar tu zona horaria.

Sincronizacion automatica de hora dejarlo por defecto como esta.

**Paso 3 — damos enter en Instalar.**

Revisar el resumen de configuración y confirmar la instalación. Esperar a que termine y reiniciar cuando lo indique, quitando el medio de instalación (USB/ISO).

**Paso 4 — Primer arranque**

Iniciar sesión con el usuario creado. Como el perfil elegido fue mínimo (solo Xorg), escribimos nuestro nombre de usuario damos enter y luego ingresamos la contraseña.

**Paso 5 — Ejecutar el script*

Instalar git con sudo pacman -S git en caso de no haberlo instalado con el archinstall.

Clonar HitGub con git clone https://github.com/SinergiaLinux/LinuxScripts


cd LinuxScripts

cd Arch

cd Daro

ls para listar las carpetas con los distintos escritorios, en este caso voy a optar por Gnome

cd Gnome

ls (para listar los scripts)

sh nombredelscrpt.sh por ej. sh gnome-full.sh

escribimos nuestra contraseña de usuario 

Luego solicita un par de veces mas la contraseña durante la instalacion.

Una vez finalizado el script, se reinicira automaticamente el sistema.






## Descripción



### Paquetes Instalados


