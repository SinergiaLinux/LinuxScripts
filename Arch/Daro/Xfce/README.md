# XFCE 

Es un entorno de escritorio conocido por ser ligero, rápido y muy configurable. Está pensado para consumir pocos recursos de memoria y procesador, por lo que funciona muy bien en equipos antiguos o modestos, aunque también es una buena opción en máquinas potentes si se prefiere un entorno sencillo y estabile, con flexibilidad para personalizar la apariencia.
Su diseño es modular: incluye un gestor de ventanas (Xfwm), un panel personalizable, un gestor de archivos (Thunar), un gestor de configuración y otras herramientas que se pueden usar por separado. Sigue una filosofía tradicional de escritorio, con menús, paneles y ventanas, sin efectos pesados ni cambios bruscos de interfaz.

Creamos tres scripts post instalacion los cuales son **xfce-sinergia**, **xfce-full** y **xfce-monochrome**, los tres incorporan por defecto los repositorios de Nemesis, Chaotic y Multilib.

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
