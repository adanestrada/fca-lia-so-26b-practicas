# Práctica · Distribuidora del Valle en Docker · Guía para Windows 10 u 11

*Sistemas Operativos · Licenciatura en Informática Administrativa · UAEMEX · 90 minutos · Trabajo individual*

> Sigue esta guía si tu computadora usa **Windows 10 u 11**. ¿Usas Mac o Linux? Sigue [MACOS.md](MACOS.md).
> El panorama general, la hoja de respuestas y la forma de entrega están en el [README](README.md).

## Cómo leer esta guía

- Cada paso empieza con una explicación de **qué** vas a hacer y **para qué** le sirve a un administrador.
- En los bloques de código, cada comando tiene arriba un comentario (la línea que empieza con `#`). **Lee el comentario y ejecuta los comandos uno por uno.** Copia solo las líneas que no empiezan con `#`; si copias un comentario, no pasa nada.
- Arriba de cada bloque se indica **dónde** se ejecuta:
  - **PowerShell**: tu sistema operativo, el *anfitrión*. El prompt se ve como `PS C:\Users\...>`.
  - **Contenedor**: el servidor Linux de la empresa. El prompt se ve como `root@servidor-dv:/srv/empresa#`.
- La práctica es **idempotente**: puedes repetir cualquier paso sin romper nada. Si una carpeta ya existe, se usa; si un archivo ya existe, se reemplaza.
- Al final de cada sección hay una **actividad**: responde sus preguntas a mano en tu hoja (ver [Hoja de respuestas](README.md#9-hoja-de-respuestas)).

## Si cerraste la terminal (bloque de reanudación)

Las variables de entorno solo duran mientras la terminal está abierta. Si la cerraste o abriste una nueva, ejecuta este bloque **con tus datos** antes de continuar donde te quedaste:

**Dónde:** tu ventana de PowerShell (Windows)

```powershell
# Tus datos (cámbialos por los tuyos)
$env:ALUMNO_CUENTA = "1234567"

# Tu nombre completo, entre comillas
$env:ALUMNO_NOMBRE = "Nombre Apellido Apellido"

# Ruta real de tu Escritorio
$env:ESCRITORIO = [Environment]::GetFolderPath("Desktop")

# Carpeta del proyecto en el Escritorio
$env:PRACTICA = Join-Path $env:ESCRITORIO "SO_Practica_Distribuidora_del_Valle"

# Subcarpeta de evidencias
$env:EVIDENCIAS = Join-Path $env:PRACTICA "evidencias"

# Archivo de bitácora en el Escritorio
$env:BITACORA = Join-Path $env:ESCRITORIO "bitacora_SO_$($env:ALUMNO_CUENTA).log"

# Entra a la carpeta del proyecto
cd "$env:ESCRITORIO\SO_Practica_Distribuidora_del_Valle"

# Pregunta si el contenedor ya existe (guarda su id o nada)
$existe = docker ps -a --quiet --filter 'name=^distribuidora$'

# Solo si existe, enciéndelo
if ($existe) {
    docker start distribuidora
}
```

## Mapa de la práctica

```mermaid
flowchart LR
    S0["0 · Preparar<br/>5 min"] --> S1["1 · Identidad y carpeta<br/>10 min"]
    S1 --> S2["2 · Dockerfile e imagen<br/>10 min"]
    S2 --> S3["3 · Tres sistemas de archivos<br/>15 min"]
    S3 --> S4["4 · Navegar, crear, editar<br/>15 min"]
    S4 --> S5["5 · Control de accesos<br/>20 min"]
    S5 --> S6["6 · ¿Qué sobrevive?<br/>8 min"]
    S6 --> S7["7 · Empaquetar y entregar<br/>7 min"]
```

---

## Sección 0 · Antes de empezar (5 min)

Necesitas **Docker Desktop** instalado y abierto. Espera a que su ventana diga *Engine running*. Después abre la terminal:

Abre **Windows PowerShell**: presiona la tecla Windows, escribe `PowerShell` y presiona Enter. También sirve **Terminal** de Windows con una pestaña de PowerShell. **No uses Símbolo del sistema (CMD)**: los comandos de esta guía son de PowerShell.

Comprueba que tu terminal puede hablar con Docker:

**Dónde:** tu ventana de PowerShell (Windows)

```powershell
# Pregunta al motor de Docker su versión; si responde, Docker Desktop está listo
docker version --format '{{.Server.Version}}'
```

Si aparece un número de versión (por ejemplo `28.5.1`), todo está listo. Si aparece `error during connect` o `The system cannot find the file specified`, Docker Desktop no está encendido: ábrelo, espera y repite el comando.

> La sección 2 descarga Ubuntu e instala tres programas, así que necesitas **internet** al menos en ese paso.

---

## Sección 1 · Tu identidad, tu Escritorio y la carpeta del proyecto (10 min)

**Por qué:** en una organización, cada acción sobre un servidor debe poder rastrearse: **quién** la hizo, **en qué equipo** y **cuándo**. Por eso lo primero es registrar tu identidad en **variables de entorno**, es decir, datos con nombre que la terminal recuerda y que los programas pueden leer. Esas variables aparecerán en tu bitácora y, más adelante, dentro del servidor Linux.

### Paso 1.1 · Registrar tu identidad

Escribe **tu** número de cuenta y **tu** nombre en lugar de los ejemplos:

**Dónde:** tu ventana de PowerShell (Windows)

```powershell
# Guarda tu número de cuenta en una variable de entorno (cámbialo por el tuyo)
$env:ALUMNO_CUENTA = "1234567"

# Guarda tu nombre completo, entre comillas
$env:ALUMNO_NOMBRE = "Nombre Apellido Apellido"

# Muestra el número de cuenta para comprobarlo
$env:ALUMNO_CUENTA

# Muestra el nombre para comprobarlo
$env:ALUMNO_NOMBRE
```

### Paso 1.2 · Encontrar tu Escritorio sin escribir la ruta a mano

En Windows la carpeta del Escritorio puede estar en lugares distintos: `C:\Users\tu_usuario\Desktop`, o dentro de OneDrive (`...\OneDrive\Escritorio` o `...\OneDrive\Desktop`), y su nombre visible cambia con el idioma. En lugar de adivinar, **se la pedimos a Windows** con `[Environment]::GetFolderPath("Desktop")`, que devuelve la ruta correcta en Windows 10 u 11, en inglés o en español. Con `Join-Path` armamos las demás rutas sin preocuparnos por las diagonales.

**Dónde:** tu ventana de PowerShell (Windows)

```powershell
# Pide a Windows la ruta real de tu Escritorio
$env:ESCRITORIO = [Environment]::GetFolderPath("Desktop")

# Define la carpeta del proyecto dentro del Escritorio
$env:PRACTICA = Join-Path $env:ESCRITORIO "SO_Practica_Distribuidora_del_Valle"

# Define la subcarpeta donde quedarán las evidencias
$env:EVIDENCIAS = Join-Path $env:PRACTICA "evidencias"

# Define la bitácora: en el Escritorio y con tu número de cuenta en el nombre
$env:BITACORA = Join-Path $env:ESCRITORIO "bitacora_SO_$($env:ALUMNO_CUENTA).log"

# Muestra la ruta del Escritorio
$env:ESCRITORIO

# Muestra la ruta de la carpeta del proyecto
$env:PRACTICA

# Muestra la ruta de la bitácora
$env:BITACORA
```

### Paso 1.3 · Crear la carpeta del proyecto en el Escritorio

Con `New-Item -Force`, si la carpeta no existe se crea y si ya existe se usa sin marcar error. Eso hace al paso **idempotente**. La carpeta se llamará `SO_Practica_Distribuidora_del_Valle`, sin espacios ni acentos para evitar problemas en cualquier sistema.

**Dónde:** tu ventana de PowerShell (Windows)

```powershell
# Crea la carpeta del proyecto (si ya existe, no marca error)
New-Item -ItemType Directory -Path $env:PRACTICA -Force

# Crea la subcarpeta de evidencias del mismo modo
New-Item -ItemType Directory -Path $env:EVIDENCIAS -Force
```

### Paso 1.4 · Entrar a la carpeta del proyecto

Desde ahora trabajarás **dentro** de esta carpeta. `cd` cambia tu directorio de trabajo, el mismo concepto de la sesión 1, pero en tu propio sistema:

**Dónde:** tu ventana de PowerShell (Windows)

```powershell
# Entra a la carpeta del proyecto (cd es el atajo de Set-Location)
cd "$env:ESCRITORIO\SO_Practica_Distribuidora_del_Valle"

# Muestra la carpeta en la que estás ahora
Get-Location
```

### Paso 1.5 · Crear la bitácora en tu Escritorio

La **bitácora** es un archivo de texto corto con tu identidad, tu equipo y los datos clave de cada sección. Se crea en el Escritorio, **fuera** de la carpeta del proyecto, para que la encuentres fácilmente al enviarla. El nombre del equipo (*hostname*) identifica tu dispositivo.

**Dónde:** tu ventana de PowerShell (Windows)

```powershell
# Guarda el nombre de tu equipo: identifica tu dispositivo
$equipo = hostname

# Guarda la fecha y hora de inicio
$inicio = Get-Date -Format "yyyy-MM-dd HH:mm"

# Crea la bitácora con su encabezado (si ya existía, la reinicia)
Set-Content -Path $env:BITACORA -Value "=== Bitácora · Práctica Distribuidora del Valle ===" -Encoding UTF8

# Agrega tu nombre
Add-Content -Path $env:BITACORA -Value "Alumno: $env:ALUMNO_NOMBRE" -Encoding UTF8

# Agrega tu número de cuenta
Add-Content -Path $env:BITACORA -Value "Número de cuenta: $env:ALUMNO_CUENTA" -Encoding UTF8

# Agrega el identificador del dispositivo
Add-Content -Path $env:BITACORA -Value "Equipo (hostname): $equipo" -Encoding UTF8

# Agrega el sistema anfitrión
Add-Content -Path $env:BITACORA -Value "Sistema anfitrión: Windows" -Encoding UTF8

# Agrega la hora de inicio
Add-Content -Path $env:BITACORA -Value "Inicio: $inicio" -Encoding UTF8

# Agrega la ruta del proyecto
Add-Content -Path $env:BITACORA -Value "Carpeta del proyecto: $env:PRACTICA" -Encoding UTF8

# Muestra la bitácora completa
Get-Content -Path $env:BITACORA
```

Debes ver algo así:

```text
=== Bitácora · Práctica Distribuidora del Valle ===
Alumno: Ana López Martínez
Número de cuenta: 1234567
Equipo (hostname): LAPTOP-ANA01
Sistema anfitrión: Windows
Inicio: 2026-10-21 10:05
Carpeta del proyecto: C:\Users\ana\OneDrive\Escritorio\SO_Practica_Distribuidora_del_Valle
```

> Si repites este paso, la bitácora se reinicia desde cero, y es lo correcto. Si la repites ya avanzada la práctica, vuelve a ejecutar los pasos de bitácora de las secciones siguientes.

### Actividad 1 · Responde en tu hoja

1. ¿Qué ruta mostró tu Escritorio en el paso 1.2? ¿Por qué se la pedimos al sistema en lugar de escribirla a mano? ¿Qué problema evita?
2. Explica con tus palabras qué es un comando **idempotente** y escribe un comando de esta sección que lo sea.

---

## Sección 2 · Construir el servidor con un Dockerfile (10 min)

**Por qué:** configurar un servidor a mano es lento y difícil de repetir igual. Un **Dockerfile** es la *receta escrita* del servidor: qué sistema usa, qué usuarios y grupos tiene, qué archivos y qué permisos. Con esa receta, Docker construye una **imagen**, una plantilla de solo lectura, y a partir de la imagen enciende **contenedores**, que son servidores en funcionamiento.

Este Dockerfile reproduce la **Distribuidora del Valle tal como la encontraste en el ejercicio en parejas**, con sus tres errores de seguridad incluidos. En la sección 5 los vas a corregir.

```mermaid
flowchart LR
    D["Dockerfile<br/>la receta"] -->|"docker build"| I["Imagen<br/>distribuidora-del-valle<br/>plantilla de solo lectura"]
    I -->|"docker run"| C["Contenedor<br/>distribuidora<br/>servidor encendido"]
    C -->|"docker rm"| X["Se borra el contenedor<br/>la imagen sigue intacta"]
```

### Paso 2.1 · Escribir el Dockerfile

En PowerShell, todo lo que está entre `@'` y `'@` se guarda **tal cual** en una variable. Después, `Set-Content` lo escribe en el archivo `Dockerfile` (sin extensión) dentro de tu proyecto. Copia el bloque **completo**, desde `$dockerfile = @'` hasta `'@`, y pégalo de una sola vez. Lee los comentarios del Dockerfile: describen cada parte del servidor.

**Dónde:** tu ventana de PowerShell (Windows)

```powershell
# Guarda en una variable el texto completo del Dockerfile (desde @' hasta '@)
$dockerfile = @'
# Practica: Distribuidora del Valle - Sistemas Operativos - UAEMEX
# Servidor Linux con la configuracion INICIAL (incluye errores que debes corregir)
FROM ubuntu:24.04

# Herramientas: sudo (privilegios), tree (ver arbol de carpetas), nano (editor de texto)
RUN apt-get update && apt-get install -y --no-install-recommends sudo tree nano && rm -rf /var/lib/apt/lists/*

# Quita el usuario de ejemplo que trae Ubuntu (si no existe, no pasa nada)
RUN userdel -r ubuntu || true

# Grupos: los departamentos de la empresa
RUN groupadd contabilidad
RUN groupadd ventas
RUN groupadd practicantes

# Usuarios: -m crea su carpeta personal, -s le da terminal bash, -G lo agrega a su departamento
RUN useradd -m -s /bin/bash -G contabilidad ana
RUN useradd -m -s /bin/bash -G contabilidad marta
RUN useradd -m -s /bin/bash -G ventas sofia
RUN useradd -m -s /bin/bash -G ventas luis
RUN useradd -m -s /bin/bash -G practicantes jorge

# Administrador: pertenece al grupo sudo y no necesita contrasena (solo para esta practica)
RUN useradd -m -s /bin/bash -G sudo admin
RUN echo "admin ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/admin
RUN chmod 440 /etc/sudoers.d/admin
RUN touch /home/admin/.sudo_as_admin_successful

# Carpeta compartida de la empresa
RUN mkdir -p /srv/empresa/contabilidad /srv/empresa/ventas /srv/empresa/practicas
WORKDIR /srv/empresa

# Archivos de la empresa (contenido ficticio)
RUN echo "SSID: DistribuidoraValle  Clave: Valle#2026" > claves_wifi.txt
RUN printf "cliente,telefono\nFerreteria Lopez,722-555-0101\n" > clientes.csv
RUN echo "Manual de ventas: descuentos y devoluciones" > manual_ventas.pdf
RUN printf "empleado,sueldo\nana,28000\nmarta,19000\nsofia,31000\nluis,17000\njorge,6000\n" > nomina.xlsx
RUN printf "#!/bin/bash\necho Respaldando /srv/empresa\n" > respaldo.sh
RUN echo "Cierre contable de octubre" > contabilidad/cierre_octubre.txt

# Duenos y grupos de cada elemento
RUN chown luis:ventas clientes.csv
RUN chown ana:contabilidad nomina.xlsx contabilidad contabilidad/cierre_octubre.txt
RUN chown sofia:ventas manual_ventas.pdf ventas
RUN chown jorge:practicantes practicas

# Permisos INICIALES (tres de ellos son errores de seguridad)
RUN chmod 644 claves_wifi.txt
RUN chmod 666 clientes.csv
RUN chmod 750 contabilidad
RUN chmod 640 contabilidad/cierre_octubre.txt
RUN chmod 644 manual_ventas.pdf
RUN chmod 640 nomina.xlsx
RUN chmod 644 practicas
RUN chmod 755 respaldo.sh
RUN chmod 770 ventas

# Punto de montaje donde aparecera tu carpeta de evidencias
RUN mkdir -p /evidencias

CMD ["bash"]
'@

# Escribe el archivo Dockerfile en la carpeta del proyecto (si existía, lo reemplaza)
Set-Content -Path (Join-Path $env:PRACTICA "Dockerfile") -Value $dockerfile -Encoding ascii

# Muestra el contenido para revisarlo
Get-Content -Path (Join-Path $env:PRACTICA "Dockerfile")
```

### Paso 2.2 · Construir la imagen

La primera vez tarda uno o dos minutos porque descarga Ubuntu e instala `sudo`, `tree` y `nano`. Si lo repites, Docker reutiliza lo ya construido (*caché*) y termina en segundos: también es idempotente.

**Dónde:** tu ventana de PowerShell (Windows)

```powershell
# Asegúrate de estar en la carpeta del proyecto
cd "$env:ESCRITORIO\SO_Practica_Distribuidora_del_Valle"

# Construye la imagen a partir del Dockerfile de esta carpeta (el punto final significa "aquí")
docker build -t distribuidora-del-valle .

# Lista la imagen construida
docker image ls distribuidora-del-valle
```

### Paso 2.3 · Crear el contenedor (solo si no existe) y encenderlo

`docker run` crea el contenedor. Sus opciones, en orden:

| Opción | Para qué sirve |
|---|---|
| `-dit` | Lo deja encendido en segundo plano (`-d`) y con una terminal disponible (`-it`). |
| `--name distribuidora` | Le da un nombre fácil de usar en vez de un número. |
| `--hostname servidor-dv` | Es el nombre del servidor que verás en el prompt. |
| `-e ALUMNO_CUENTA -e ALUMNO_NOMBRE` | Copia tus variables de entorno **dentro** del contenedor. |
| `-v ...:/evidencias` | **Monta** tu carpeta de evidencias del Escritorio dentro del servidor, en `/evidencias`. |

Como `docker run` falla si el contenedor ya existe, primero preguntamos si existe y solo lo creamos cuando no. Así el bloque es idempotente:

**Dónde:** tu ventana de PowerShell (Windows)

```powershell
# Pregunta a Docker si ya existe un contenedor llamado distribuidora (guarda su id o nada)
$existe = docker ps -a --quiet --filter 'name=^distribuidora$'

# Solo si NO existe, créalo (lee la explicación de cada opción arriba de este bloque)
if (-not $existe) {
    docker run -dit --name distribuidora --hostname servidor-dv -e ALUMNO_CUENTA -e ALUMNO_NOMBRE -v "${env:EVIDENCIAS}:/evidencias" distribuidora-del-valle
}

# Enciende el contenedor (si ya estaba encendido, no pasa nada)
docker start distribuidora

# Muestra el contenedor y su estado
docker ps --filter 'name=^distribuidora$'
```

### Paso 2.4 · Registrar en la bitácora

**Dónde:** tu ventana de PowerShell (Windows)

```powershell
# Guarda la fecha en que se construyó la imagen
$imagen = docker image inspect distribuidora-del-valle --format '{{.Created}}'

# Guarda el estado del contenedor
$estado = docker inspect distribuidora --format '{{.State.Status}}'

# Agrega el título de la sección
Add-Content -Path $env:BITACORA -Value "--- Sección 2: servidor ---" -Encoding UTF8

# Agrega la fecha de la imagen
Add-Content -Path $env:BITACORA -Value "Imagen distribuidora-del-valle creada: $imagen" -Encoding UTF8

# Agrega el estado del contenedor
Add-Content -Path $env:BITACORA -Value "Contenedor distribuidora: $estado" -Encoding UTF8
```

### Actividad 2 · Responde en tu hoja

3. ¿Cuál es la diferencia entre la **imagen** `distribuidora-del-valle` y el **contenedor** `distribuidora`?
4. ¿Para qué le sirve a un administrador describir un servidor en un Dockerfile en lugar de configurarlo a mano cada vez?

---

## Sección 3 · Tres sistemas de archivos conviviendo (15 min)

**Por qué:** al usar Docker, en tu computadora conviven **tres** sistemas de archivos, cada uno con su propia nomenclatura. Un administrador debe saber **en cuál está trabajando**, porque de eso depende dónde quedan los datos y si sobreviven.

```mermaid
flowchart LR
    subgraph A["1 · Anfitrión: Windows 10 u 11 · NTFS (Windows)"]
        E["C:\Users\tu_usuario\Desktop\SO_Practica_...\evidencias"]
    end
    subgraph V["2 · Máquina virtual de Docker · WSL 2: distribución docker-desktop"]
        R["/var/lib/docker<br/>imágenes y contenedores"]
        subgraph C["3 · Contenedor distribuidora · overlay"]
            S["/srv/empresa<br/>vive y muere con el contenedor"]
            M["/evidencias"]
        end
    end
    E <-->|"montaje -v: la MISMA carpeta"| M
    R -.->|"guarda las capas de"| C
```

| Nivel | Ejemplo de ruta | Nomenclatura |
|---|---|---|
| 1 · Anfitrión (Windows 10 u 11) | `C:\Users\tu_usuario\Desktop\SO_Practica_...\evidencias` | Letra de unidad y diagonal invertida `\`; no distingue mayúsculas. |
| 2 · Máquina virtual de Docker | `/var/lib/docker` | Linux: un solo árbol desde `/`. Ahí Docker guarda imágenes y contenedores. |
| 3 · Contenedor | `/srv/empresa`, `/evidencias` | Linux: un solo árbol desde `/`; **sí** distingue mayúsculas. |

### Paso 3.1 · El anfitrión

**Dónde:** tu ventana de PowerShell (Windows)

```powershell
# Muestra la ruta de tu carpeta de proyecto, con nomenclatura de Windows
Get-Location

# Lista su contenido
Get-ChildItem
```

### Paso 3.2 · La máquina virtual de Docker

Docker no corre directamente sobre Windows: Docker Desktop enciende una **máquina virtual Linux** y dentro de ella ejecuta los contenedores. No la ves, pero puedes preguntarle a Docker por ella:

**Dónde:** tu ventana de PowerShell (Windows)

```powershell
# Pregunta qué sistema ejecuta el motor de Docker
$vm_sistema = docker info --format '{{.OperatingSystem}}'

# Pregunta la versión del kernel de la máquina virtual
$vm_kernel = docker info --format '{{.KernelVersion}}'

# Pregunta dónde guarda Docker imágenes y contenedores DENTRO de la máquina virtual
$vm_raiz = docker info --format '{{.DockerRootDir}}'

# Pregunta cómo registró Docker tu carpeta de evidencias
$montaje = docker inspect distribuidora --format '{{range .Mounts}}{{.Source}}{{end}}'

# Muestra el sistema que ejecuta el motor
$vm_sistema

# Muestra el kernel de la máquina virtual
$vm_kernel

# Muestra la carpeta raíz de Docker en la máquina virtual
$vm_raiz

# Muestra el origen de tu carpeta montada
$montaje

# Agrega a la bitácora el título de la sección
Add-Content -Path $env:BITACORA -Value "--- Sección 3: sistemas de archivos ---" -Encoding UTF8

# Agrega el sistema del motor
Add-Content -Path $env:BITACORA -Value "Motor de Docker: $vm_sistema" -Encoding UTF8

# Agrega el kernel de la máquina virtual
Add-Content -Path $env:BITACORA -Value "Kernel de la VM: $vm_kernel" -Encoding UTF8

# Agrega la carpeta raíz de Docker
Add-Content -Path $env:BITACORA -Value "Raíz de Docker en la VM: $vm_raiz" -Encoding UTF8

# Agrega el origen del montaje
Add-Content -Path $env:BITACORA -Value "Origen del montaje /evidencias: $montaje" -Encoding UTF8
```

Verás algo como `Docker Desktop`, un kernel que termina en `microsoft-standard-WSL2`, la ruta `/var/lib/docker` y la ruta de tu carpeta de evidencias. Esta última puede aparecer con nomenclatura de Windows (`C:\Users\...`) o como la ve la máquina virtual (por ejemplo `/run/desktop/mnt/host/c/Users/...`). Anota cuál te apareció.

### Paso 3.3 · Dentro del contenedor

Entra al servidor de la empresa. El prompt cambiará a `root@servidor-dv:/srv/empresa#`: ahora estás en Linux.

**Dónde:** tu ventana de PowerShell (Windows)

```powershell
# Abre una terminal DENTRO del contenedor (para salir, escribe exit)
docker exec -it distribuidora bash
```

**Dónde:** dentro del contenedor (`root@servidor-dv`)

```bash contenedor
# Muestra con qué usuario estás trabajando
whoami

# Muestra el nombre del servidor (lo definiste con --hostname)
hostname

# Muestra la carpeta actual (la definió el Dockerfile con WORKDIR)
pwd

# Muestra la versión del kernel que usa el contenedor
uname -r

# Tu número de cuenta llegó al contenedor como variable de entorno
echo $ALUMNO_CUENTA

# Muestra los sistemas de archivos de / (el contenedor) y de /evidencias (tu carpeta)
df -hT / /evidencias
```

**Qué observar:**

- `uname -r` muestra el **mismo kernel** que reportó la máquina virtual: el contenedor no tiene kernel propio, lo comparte.
- `df -hT` muestra que `/` es de tipo `overlay`, el sistema de archivos en capas del contenedor, mientras que `/evidencias` es de otro tipo porque viene **de fuera**: es tu carpeta del Escritorio.

Ahora guarda la evidencia y haz el experimento: escribe un archivo en la carpeta compartida y otro en la carpeta interna del contenedor.

**Dónde:** dentro del contenedor (`root@servidor-dv`)

```bash contenedor
# Crea la evidencia con tu identidad vista DESDE el contenedor (> crea o reemplaza el archivo)
echo "Cuenta: $ALUMNO_CUENTA" > /evidencias/03_contenedor.txt

# Agrega tu nombre (>> agrega al final sin borrar)
echo "Nombre: $ALUMNO_NOMBRE" >> /evidencias/03_contenedor.txt

# Agrega el nombre del servidor
hostname >> /evidencias/03_contenedor.txt

# Agrega la versión del kernel
uname -r >> /evidencias/03_contenedor.txt

# Agrega la tabla de sistemas de archivos
df -hT / /evidencias >> /evidencias/03_contenedor.txt

# Escribe un archivo en la carpeta COMPARTIDA
echo "Creado desde el contenedor" > /evidencias/03_desde_contenedor.txt

# Escribe un archivo en la carpeta INTERNA del contenedor
echo "Solo existo dentro del contenedor" > /srv/empresa/03_solo_contenedor.txt

# Lista lo que hay en la carpeta compartida
ls -l /evidencias

# Sal del contenedor y regresa a tu sistema anfitrión
exit
```

### Paso 3.4 · La carpeta compartida funciona en ambos sentidos

De regreso en tu sistema anfitrión, comprueba qué archivo llegó a tu Escritorio y cuál no:

**Dónde:** tu ventana de PowerShell (Windows)

```powershell
# Lista tu carpeta de evidencias desde Windows: ahí está lo que creó el contenedor
Get-ChildItem -Path $env:EVIDENCIAS

# Lee desde Windows el archivo que escribió Linux
Get-Content -Path (Join-Path $env:EVIDENCIAS "03_desde_contenedor.txt")

# Ahora escribe un archivo desde Windows en la misma carpeta
Set-Content -Path (Join-Path $env:EVIDENCIAS "03_desde_anfitrion.txt") -Value "Creado desde Windows" -Encoding ascii

# Léelo desde el contenedor sin entrar a él (docker exec ejecuta un solo comando)
docker exec distribuidora cat /evidencias/03_desde_anfitrion.txt

# Pregunta a Windows si existe la carpeta /srv/empresa en tu disco (responderá False)
Test-Path -Path "C:\srv\empresa"
```

**Conclusión:** `/evidencias` y tu carpeta `evidencias` del Escritorio son **la misma carpeta con dos nombres**: lo que escribe uno lo ve el otro. En cambio, `/srv/empresa` solo existe dentro del contenedor.

### Actividad 3 · Responde en tu hoja

5. Escribe la ruta de tu carpeta de evidencias vista **desde tu sistema** y vista **desde el contenedor**. ¿Por qué es la misma carpeta con dos nombres?
6. ¿Qué versión de kernel mostró `uname -r` en el contenedor? ¿Por qué coincide con la de la máquina virtual de Docker y no con la de tu Windows?

---

## Sección 4 · Navegar, crear y editar dentro del servidor (15 min)

**Por qué:** en un servidor no hay ventanas ni ratón: todo se hace con comandos. Aquí practicas las operaciones de todos los días: moverte entre carpetas, crear estructuras, escribir y editar archivos, siempre **con la identidad del usuario correcto**, porque los permisos deciden qué puede hacer cada quien.

### Paso 4.1 · Entrar y explorar como root

**Dónde:** tu ventana de PowerShell (Windows)

```powershell
# Abre una terminal DENTRO del contenedor (para salir, escribe exit)
docker exec -it distribuidora bash
```

**Dónde:** dentro del contenedor (`root@servidor-dv`)

```bash contenedor
# Ve a la carpeta compartida de la empresa (ruta absoluta: empieza con /)
cd /srv/empresa

# Confirma dónde estás
pwd

# Lista con detalle: tipo, permisos, dueño, grupo, tamaño, fecha y nombre
ls -l

# Lista también los ocultos (los que empiezan con punto), incluidos . y ..
ls -la

# Muestra el árbol completo con permisos (p), usuario (u) y grupo (g)
tree -pug /srv/empresa
```

### Paso 4.2 · sofia crea la estructura de reportes

`su usuario` te convierte en otra persona dentro del servidor; `exit` te regresa a root. **Siempre regresa a root antes de cambiar a otra persona**: entre usuarios normales, `su` pide una contraseña que no tienen.

**Dónde:** dentro del contenedor (`root@servidor-dv`)

```bash contenedor
# Conviértete en sofia, jefa de ventas (root no necesita contraseña)
su sofia

# Confirma que ahora eres sofia
whoami

# Entra a la carpeta de ventas
cd /srv/empresa/ventas

# Crea tres niveles de carpetas de una vez (-p: no marca error si ya existen)
mkdir -p reportes/2026/octubre

# Entra a la carpeta más profunda (ruta relativa: no empieza con /)
cd reportes/2026/octubre

# Confirma dónde estás
pwd

# Crea un archivo con una primera línea (> crea o reemplaza)
echo "Resumen de ventas de octubre" > resumen.txt

# Agrega una segunda línea (>> agrega al final)
echo "Pedidos atendidos: 120" >> resumen.txt

# Muestra el contenido del archivo
cat resumen.txt
```

### Paso 4.3 · Editar un archivo con nano

`nano` es un editor de texto dentro de la terminal. Al abrir el archivo:

1. Baja con las flechas hasta el final y escribe una línea nueva: `Revisado por: ` seguido de **tu nombre**.
2. Guarda con **Ctrl + O** y confirma con **Enter**.
3. Sal con **Ctrl + X**.

**Dónde:** dentro del contenedor (`root@servidor-dv`)

```bash contenedor
# Abre el archivo en el editor nano
nano resumen.txt

# Muestra el archivo para confirmar tu cambio
cat resumen.txt

# Haz una copia de respaldo del archivo
cp resumen.txt resumen_respaldo.txt

# Lista los archivos de esta carpeta
ls -l
```

### Paso 4.4 · Moverse con rutas relativas y absolutas

Una ruta **relativa** parte de donde estás (`..`, `../..`, `reportes/2026`). Una **absoluta** empieza en `/` y funciona desde cualquier lugar.

**Dónde:** dentro del contenedor (`root@servidor-dv`)

```bash contenedor
# Sube un nivel (.. es la carpeta padre)
cd ..

# Comprueba: estás en .../reportes/2026
pwd

# Sube dos niveles más
cd ../..

# Comprueba: estás en /srv/empresa/ventas
pwd

# Ve a tu carpeta personal (~ es el home de sofia)
cd ~

# Comprueba: estás en /home/sofia
pwd

# Regresa con ruta absoluta a la carpeta de la empresa
cd /srv/empresa

# Deja de ser sofia y regresa a root
exit
```

### Paso 4.5 · jorge intenta lo mismo

**Dónde:** dentro del contenedor (`root@servidor-dv`)

```bash contenedor
# Conviértete en jorge, el practicante
su jorge

# Muestra sus grupos: no está en ventas
id

# Intenta crear una carpeta dentro de ventas (debe fallar)
mkdir -p /srv/empresa/ventas/borrador

# Intenta ver el contenido de ventas (debe fallar)
ls /srv/empresa/ventas

# Regresa a root
exit
```

**Qué observar:** ambos comandos responden `Permission denied`. La carpeta `ventas` es `drwxrwx---` y jorge no es dueño ni pertenece a ventas: le aplica `---`.

### Paso 4.6 · Guardar la evidencia

Las evidencias se guardan **como root**, después de regresar de cada usuario.

**Dónde:** dentro del contenedor (`root@servidor-dv`)

```bash contenedor
# Guarda el árbol de ventas con permisos, dueños y grupos (> crea o reemplaza)
tree -pug /srv/empresa/ventas > /evidencias/04_estructura.txt

# Agrega el contenido del archivo que editaste
cat /srv/empresa/ventas/reportes/2026/octubre/resumen.txt >> /evidencias/04_estructura.txt

# Revisa la evidencia
cat /evidencias/04_estructura.txt

# Sal del contenedor
exit
```

### Paso 4.7 · Registrar en la bitácora

**Dónde:** tu ventana de PowerShell (Windows)

```powershell
# Agrega a la bitácora el título de la sección
Add-Content -Path $env:BITACORA -Value "--- Sección 4: estructura de carpetas ---" -Encoding UTF8

# Agrega el nombre de la evidencia generada
Add-Content -Path $env:BITACORA -Value "Evidencia: evidencias\04_estructura.txt" -Encoding UTF8
```

### Actividad 4 · Responde en tu hoja

7. Estando en `/srv/empresa/ventas/reportes/2026/octubre`, escribe la ruta **relativa** y la ruta **absoluta** para llegar a `/srv/empresa/ventas`.
8. ¿Por qué sofia pudo crear carpetas dentro de `ventas` y jorge no? Responde con la categoría (u, g, o) y el permiso que aplicó a cada uno.

---

## Sección 5 · Control de accesos: diagnosticar y corregir (20 min)

**Por qué:** este es el trabajo central de un administrador: **encontrar** configuraciones peligrosas, **comprobar** el riesgo y **corregirlo** con el usuario adecuado. Así se protege la confidencialidad y la integridad de la información. Recuerda el método:

```mermaid
flowchart TD
    A["Un usuario intenta leer, escribir o entrar"] --> B{"¿Es el dueño?"}
    B -->|"Sí"| U["Se usa SOLO el trío u"]
    B -->|"No"| G{"¿Está en el grupo del archivo?"}
    G -->|"Sí"| GG["Se usa SOLO el trío g"]
    G -->|"No"| O["Se usa el trío o"]
    U --> P{"¿Ese trío tiene el permiso?"}
    GG --> P
    O --> P
    P -->|"Sí"| OK["Permitido"]
    P -->|"No"| NO["Permission denied"]
```

### Paso 5.1 · Diagnóstico

**Dónde:** tu ventana de PowerShell (Windows)

```powershell
# Abre una terminal DENTRO del contenedor (para salir, escribe exit)
docker exec -it distribuidora bash
```

**Dónde:** dentro del contenedor (`root@servidor-dv`)

```bash contenedor
# Ve a la carpeta de la empresa
cd /srv/empresa

# Observa los permisos actuales
ls -l

# Guarda el estado inicial como evidencia
ls -l > /evidencias/05_antes.txt
```

Antes de seguir, ubica en el listado los **tres errores** del ejercicio en parejas: `clientes.csv`, `claves_wifi.txt` y `practicas`.

### Paso 5.2 · Comprobar el riesgo como jorge

**Dónde:** dentro del contenedor (`root@servidor-dv`)

```bash contenedor
# Conviértete en jorge, el practicante
su jorge

# Intenta leer las claves del wifi (NO debería poder)
cat claves_wifi.txt

# Intenta alterar la base de clientes (NO debería poder)
echo "hackeado" >> clientes.csv

# Comprueba que la alteración quedó guardada
cat clientes.csv

# Intenta entrar a su propia carpeta (debería poder, pero no puede)
cd practicas

# Regresa a root
exit
```

**Qué observar:** un practicante lee las claves y altera la base de clientes, pero no puede entrar a su propia carpeta. Los tres errores, comprobados.

### Paso 5.3 · Cada dueño corrige lo suyo

Solo el **dueño** de un archivo, o root, puede cambiar sus permisos. Por eso cada corrección la hace la persona adecuada:

**Dónde:** dentro del contenedor (`root@servidor-dv`)

```bash contenedor
# Conviértete en luis, dueño de clientes.csv
su luis

# Quita a los otros la lectura y la escritura: queda rw-rw----
chmod 660 clientes.csv

# Comprueba el cambio
ls -l clientes.csv

# Regresa a root
exit

# Conviértete en admin, el administrador
su admin

# Intenta corregir un archivo que es de root, sin sudo (debe fallar)
chmod 600 claves_wifi.txt

# Ahora pide el privilegio con sudo: queda rw-------
sudo chmod 600 claves_wifi.txt

# Comprueba el cambio
ls -l claves_wifi.txt

# Regresa a root
exit

# Conviértete en jorge, dueño de practicas
su jorge

# Agrega la x que le faltaba y cierra la carpeta a los demás: queda rwx------
chmod 700 practicas

# Ahora sí puede entrar
cd practicas

# Comprueba dónde está
pwd

# Regresa a root
exit
```

**Qué observar:** sin `sudo`, admin recibe `Operation not permitted`, porque `claves_wifi.txt` es de root. Con `sudo` pide el privilegio solo para esa tarea.

### Paso 5.4 · Atender las peticiones de la empresa

**Dónde:** dentro del contenedor (`root@servidor-dv`)

```bash contenedor
# Petición 1: el manual de ventas solo lo leen ventas. Lo hace su dueña, sofia
su sofia

# Quita la lectura a los otros
chmod o-r manual_ventas.pdf

# Regresa a root
exit

# Petición 2: marta debe poder actualizar la nómina. Lo hace su dueña, ana
su ana

# Agrega escritura al grupo contabilidad
chmod g+w nomina.xlsx

# Regresa a root
exit

# Petición 3: jorge termina sus prácticas; su carpeta pasa a sofia y al grupo ventas
su admin

# Cambiar el dueño requiere root: se usa sudo; -R incluye todo el contenido
sudo chown -R sofia:ventas practicas

# Regresa a root
exit

# Observa el resultado de todas las correcciones
ls -l
```

### Paso 5.5 · Verificar y guardar la evidencia

Un buen administrador **no supone que su cambio funcionó: lo comprueba**. Aquí, root ejecuta cada prueba en nombre de otro usuario con `su usuario -c "comando"` y guarda el resultado. La variable `$?` vale `0` cuando el comando funcionó y otro número cuando fue negado.

**Dónde:** dentro del contenedor (`root@servidor-dv`)

```bash contenedor
# Guarda el estado final como evidencia
ls -l > /evidencias/05_despues.txt

# Prueba 1: título de la prueba (> inicia el archivo)
echo "Prueba 1: jorge lee claves_wifi.txt" > /evidencias/05_verificacion.txt

# Ejecuta la prueba como jorge; 2>&1 guarda también el mensaje de error
su jorge -c "cat claves_wifi.txt" >> /evidencias/05_verificacion.txt 2>&1

# $? guarda el resultado del último comando: 0 = permitido, otro número = negado
echo "Resultado (0 = permitido): $?" >> /evidencias/05_verificacion.txt

# Prueba 2: escribe el título de la prueba
echo "Prueba 2: jorge escribe en clientes.csv" >> /evidencias/05_verificacion.txt

# Ejecuta la prueba como jorge y guarda su salida o su error
su jorge -c "echo prueba >> clientes.csv" >> /evidencias/05_verificacion.txt 2>&1

# Guarda el resultado de la prueba
echo "Resultado (0 = permitido): $?" >> /evidencias/05_verificacion.txt

# Prueba 3: escribe el título de la prueba
echo "Prueba 3: jorge entra a practicas" >> /evidencias/05_verificacion.txt

# Ejecuta la prueba como jorge y guarda su salida o su error
su jorge -c "cd practicas" >> /evidencias/05_verificacion.txt 2>&1

# Guarda el resultado de la prueba
echo "Resultado (0 = permitido): $?" >> /evidencias/05_verificacion.txt

# Prueba 4: escribe el título de la prueba
echo "Prueba 4: jorge lee manual_ventas.pdf" >> /evidencias/05_verificacion.txt

# Ejecuta la prueba como jorge y guarda su salida o su error
su jorge -c "cat manual_ventas.pdf" >> /evidencias/05_verificacion.txt 2>&1

# Guarda el resultado de la prueba
echo "Resultado (0 = permitido): $?" >> /evidencias/05_verificacion.txt

# Prueba 5: escribe el título de la prueba
echo "Prueba 5: marta escribe en nomina.xlsx" >> /evidencias/05_verificacion.txt

# Ejecuta la prueba como marta y guarda su salida o su error
su marta -c "echo marta,19500 >> nomina.xlsx" >> /evidencias/05_verificacion.txt 2>&1

# Guarda el resultado de la prueba
echo "Resultado (0 = permitido): $?" >> /evidencias/05_verificacion.txt

# Revisa la evidencia completa
cat /evidencias/05_verificacion.txt

# Sal del contenedor
exit
```

Resultado esperado: las pruebas 1 a 4 terminan en `1`, negado, y la prueba 5 en `0`, permitido.

> **¿Quieres repetir la sección 5 desde el principio?** Después del paso 5.4, `practicas` ya no es de jorge, así que algunos comandos del paso 5.3 fallarán. Para empezar de cero, ejecuta el paso 6.1, que recrea el contenedor con la configuración original, y vuelve al paso 5.1.

### Paso 5.6 · Registrar en la bitácora

**Dónde:** tu ventana de PowerShell (Windows)

```powershell
# Agrega a la bitácora el título de la sección
Add-Content -Path $env:BITACORA -Value "--- Sección 5: control de accesos ---" -Encoding UTF8

# Agrega el nombre de la evidencia generada
Add-Content -Path $env:BITACORA -Value "Evidencias: 05_antes.txt, 05_despues.txt, 05_verificacion.txt" -Encoding UTF8
```

### Actividad 5 · Responde en tu hoja

9. Para cada uno de los tres riesgos, ¿qué comando usaste y **quién** lo ejecutó? ¿Por qué tenía que ser esa persona?
10. ¿Por qué admin necesitó `sudo` para corregir `claves_wifi.txt` y luis no lo necesitó para `clientes.csv`?

---

## Sección 6 · ¿Qué sobrevive? Persistencia de los datos (8 min)

**Por qué:** los contenedores se crean y se destruyen todo el tiempo. Si no sabes **dónde** quedan los datos, puedes perder el trabajo de un día al borrar un contenedor. Aquí lo compruebas tú mismo.

```mermaid
flowchart LR
    subgraph ANTES["Antes de borrar"]
        A1["Capa del contenedor<br/>correcciones de la sección 5<br/>03_solo_contenedor.txt"]
        A2["Carpeta montada<br/>evidencias del Escritorio"]
    end
    subgraph DESPUES["Después de docker rm y docker run"]
        B1["Capa nueva desde la imagen<br/>regresan los 3 errores originales"]
        B2["Carpeta montada<br/>evidencias intactas"]
    end
    A1 -->|"se pierde"| B1
    A2 -->|"se conserva"| B2
```

### Paso 6.1 · Borrar y recrear el contenedor

**Dónde:** tu ventana de PowerShell (Windows)

```powershell
# Borra el contenedor (si no existe, Docker no hace nada)
docker rm -f distribuidora

# Pregunta si existe el contenedor: ahora no debe existir
$existe = docker ps -a --quiet --filter 'name=^distribuidora$'

# Como no existe, se crea uno nuevo desde la misma imagen
if (-not $existe) {
    docker run -dit --name distribuidora --hostname servidor-dv -e ALUMNO_CUENTA -e ALUMNO_NOMBRE -v "${env:EVIDENCIAS}:/evidencias" distribuidora-del-valle
}

# Enciende el contenedor
docker start distribuidora
```

### Paso 6.2 · Revisar desde adentro

**Dónde:** tu ventana de PowerShell (Windows)

```powershell
# Abre una terminal DENTRO del contenedor (para salir, escribe exit)
docker exec -it distribuidora bash
```

**Dónde:** dentro del contenedor (`root@servidor-dv`)

```bash contenedor
# Lista la carpeta de la empresa: ¿siguen tus correcciones?
ls -l /srv/empresa

# Guarda ese listado como evidencia
ls -l /srv/empresa > /evidencias/06_recreado.txt

# Busca el archivo que creaste en la sección 3 dentro del contenedor (2>&1 guarda el error)
ls -l /srv/empresa/03_solo_contenedor.txt >> /evidencias/06_recreado.txt 2>&1

# Lista la carpeta compartida: ¿siguen tus evidencias?
ls /evidencias >> /evidencias/06_recreado.txt

# Revisa la evidencia
cat /evidencias/06_recreado.txt

# Sal del contenedor
exit
```

**Qué observar:** `/srv/empresa` regresó a su estado original, con los errores de nuevo, y `03_solo_contenedor.txt` ya no existe. En cambio, `/evidencias` conserva todo. La **imagen** no cambió y la **capa del contenedor** se borró con él; tu carpeta montada vive en tu disco, fuera de Docker.

### Paso 6.3 · Registrar en la bitácora

**Dónde:** tu ventana de PowerShell (Windows)

```powershell
# Agrega a la bitácora el título de la sección
Add-Content -Path $env:BITACORA -Value "--- Sección 6: persistencia ---" -Encoding UTF8

# Agrega el nombre de la evidencia generada
Add-Content -Path $env:BITACORA -Value "Evidencia: evidencias\06_recreado.txt" -Encoding UTF8
```

### Actividad 6 · Responde en tu hoja

11. Después de borrar y recrear el contenedor, ¿qué se **perdió** y qué se **conservó**? Explica por qué.
12. Si administraras un servidor real con contenedores, ¿dónde guardarías los datos importantes de la empresa y por qué?

---

## Sección 7 · Empaquetar y entregar (7 min)

**Por qué:** la evidencia permite que otra persona, en este caso tu profesor, **verifique** que el trabajo se hizo y cómo quedó, sin repetirlo. Empaquetar en un solo `.zip` evita archivos sueltos o incompletos.

### Paso 7.1 · Cerrar la bitácora

**Dónde:** tu ventana de PowerShell (Windows)

```powershell
# Título de la sección final
Add-Content -Path $env:BITACORA -Value "--- Sección 7: entrega ---" -Encoding UTF8

# Guarda en una variable la lista de archivos de evidencias
$archivos = Get-ChildItem -Path $env:EVIDENCIAS -Name

# Agrega esa lista a la bitácora
Add-Content -Path $env:BITACORA -Value $archivos -Encoding UTF8

# Guarda la hora de término
$fin = Get-Date -Format "yyyy-MM-dd HH:mm"

# Agrega la hora de término a la bitácora
Add-Content -Path $env:BITACORA -Value "Fin: $fin" -Encoding UTF8

# Revisa la bitácora completa
Get-Content -Path $env:BITACORA
```

### Paso 7.2 · Crear el zip

El zip incluye la carpeta `evidencias` y el `Dockerfile`. La bitácora se envía **aparte**.

**Dónde:** tu ventana de PowerShell (Windows)

```powershell
# Define el nombre del zip: en el Escritorio y con tu número de cuenta
$env:ZIP = Join-Path $env:ESCRITORIO "SO_Practica_DV_$($env:ALUMNO_CUENTA).zip"

# Asegúrate de estar en la carpeta del proyecto
cd "$env:ESCRITORIO\SO_Practica_Distribuidora_del_Valle"

# Empaqueta la carpeta de evidencias y el Dockerfile (-Force reemplaza un zip anterior)
Compress-Archive -Path evidencias, Dockerfile -DestinationPath $env:ZIP -Force

# Comprueba que el zip existe y su tamaño
Get-Item -Path $env:ZIP
```

### Paso 7.3 · Enviar por correo

Sigue las instrucciones de [Entrega](README.md#10-entrega) del README. Debes adjuntar **dos archivos** de tu Escritorio:

1. `SO_Practica_DV_<tu_cuenta>.zip`
2. `bitacora_SO_<tu_cuenta>.log`

Tu **hoja de respuestas** no se entrega hoy: se entrega **el viernes siguiente a la práctica**, escaneada por correo **y** en mano (ver Entrega).

### Paso 7.4 · Opcional: limpiar

Hazlo **solo después** de enviar el correo:

**Dónde:** tu ventana de PowerShell (Windows)

```powershell
# Borra el contenedor de la práctica (tus evidencias en el Escritorio NO se borran)
docker rm -f distribuidora

# Opcional: borra también la imagen para liberar espacio
docker image rm distribuidora-del-valle
```

---

## Problemas frecuentes en Windows 10 u 11

| Síntoma | Qué hacer |
|---|---|
| `docker : The term 'docker' is not recognized` | Docker Desktop no está instalado o no ha terminado de instalarse. Ciérralo, ábrelo de nuevo y abre una nueva ventana de PowerShell. |
| `error during connect` | Docker Desktop no está encendido. Ábrelo y espera a que diga *Engine running*. |
| Las variables salen vacías | Cerraste la terminal. Ejecuta el [bloque de reanudación](#si-cerraste-la-terminal-bloque-de-reanudación). |
| `Conflict. The container name "/distribuidora" is already in use` | Usaste `docker run` fuera del bloque `if`. Usa el bloque del paso 2.3, que primero revisa si existe. |
| `su luis` pide contraseña | No estás como root. Escribe `exit` hasta ver `root@servidor-dv` y repite. |
| `/evidencias` aparece vacía dentro del contenedor | Revisa que `$env:EVIDENCIAS` tenga ruta (paso 1.2). Luego borra y recrea el contenedor con el bloque del paso 6.1. |
| Mi Escritorio está en OneDrive y el montaje falla | En OneDrive, marca la carpeta del proyecto como *Mantener siempre en este dispositivo*. |
| `Compress-Archive` dice que el archivo está en uso | Cierra los archivos de evidencias que tengas abiertos en el Bloc de notas y repite el paso 7.2. |

*Las fuentes y referencias están en el [anexo del README](README.md#anexo-fuentes-y-referencias).*
