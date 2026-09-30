# Práctica 6 · Docker GUI — Guía para **Windows** 🪟

> ¿Tienes Mac? Usa [`Practica6_macOS.md`](./Practica6_macOS.md). Para la visión general y los diagramas, consulta el [`README.md`](./README.md).

**Lo que vas a hacer:** instalar Docker Desktop, descargar la imagen de **nginx** desde la GUI, inspeccionarla, renombrarla, lanzar un contenedor y personalizar su página web con tu nombre y número de cuenta.

**Lo que vas a entregar:** un PDF con **6 capturas** (marcadas en esta guía con 📸).

---

## 📋 Antes de empezar

Ten a la mano estos datos; los usarás varias veces:

| Dato | Ejemplo | Tu valor |
|---|---|---|
| Nombre completo | Ana Sofía López Martínez | ______________ |
| Número de cuenta | `2412345` | ______________ |

**Cómo tomar capturas en Windows:** `Win + Shift + S` → selecciona el área → la imagen queda en el portapapeles y en la app *Recortes*. Guárdalas como `C1.png`, `C2.png`, … `C6.png` para armar tu PDF al final.

---

## Paso 0 · Verificar requisitos

Requisitos oficiales de Docker Desktop (backend WSL 2):

- **Windows 11** 64 bits, versión 23H2 (compilación 22631) o superior — *recomendado*.
- **Windows 10** 64 bits, versión 22H2 (compilación 19045). ⚠️ Windows 10 dejó de recibir soporte general de Microsoft en octubre de 2025; Docker solo da soporte a versiones de Windows que Microsoft sigue manteniendo, así que si puedes, usa Windows 11.
- **8 GB de RAM**, procesador de 64 bits y **virtualización activada** en BIOS/UEFI.
- **WSL** versión **2.1.5 o posterior**.

### 0.1 Comprueba que la virtualización está activada

1. Abre el **Administrador de tareas** (`Ctrl + Shift + Esc`).
2. Ve a **Rendimiento → CPU**.
3. Busca la línea **Virtualización: Habilitado**.

> Si dice *Deshabilitado*, reinicia, entra al BIOS/UEFI (normalmente con `F2`, `F10`, `Supr` o `Esc` al encender) y activa **Intel VT-x / Intel Virtualization Technology** o **AMD-V / SVM Mode**. Guarda y reinicia.

### 0.2 Instala o actualiza WSL 2

1. Clic derecho en el botón Inicio → **Terminal (Administrador)** o **Windows PowerShell (Administrador)**.
2. Revisa tu versión:

   ```powershell
   wsl --version
   ```

3. Según el resultado:
   - Si **no aparece información de versión** o el comando falla → instala WSL:
     ```powershell
     wsl --install
     ```
   - Si aparece una versión menor a 2.1.5 → actualiza:
     ```powershell
     wsl --update
     ```
4. **Reinicia la computadora** si te lo pide.

> ⏳ **Ten paciencia:** `wsl --install` descarga e instala componentes de Windows y puede tardar **de 5 a 15 minutos**, según tu internet. Es normal que la barra de progreso se quede quieta un rato en el mismo porcentaje. **No cierres la terminal** hasta que vuelva a aparecer el cursor. Después del reinicio, Windows puede mostrar una pantalla de «Configurando actualizaciones»: déjala terminar.

---

## Paso 1 · Descargar e instalar Docker Desktop

### 1.1 Descarga (URLs oficiales)

| Tu procesador | Enlace oficial de descarga |
|---|---|
| Intel / AMD (x86_64) — *la mayoría* | <https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe> |
| ARM (ej. Snapdragon, *acceso anticipado*) | <https://desktop.docker.com/win/main/arm64/Docker%20Desktop%20Installer.exe> |
| Página oficial con instrucciones | <https://docs.docker.com/desktop/setup/install/windows-install/> |

> ¿No sabes cuál es tu procesador? **Configuración → Sistema → Información → Tipo de sistema**. Si dice «procesador basado en x64», usa el primer enlace.

### 1.2 Instalación

1. Doble clic en **`Docker Desktop Installer.exe`**.
2. Cuando pregunte el modo de instalación, deja **Per-user (por usuario)**, que es el recomendado: no necesita permisos de administrador.
3. En la página de configuración, deja marcada **Use WSL 2 instead of Hyper-V**.
4. Sigue el asistente hasta el final y presiona **Close**.

> ⏳ **Ten paciencia:** el instalador pesa alrededor de 500 MB y la fase de **«Unpacking files»** puede tardar **de 3 a 10 minutos**. Aunque parezca congelado, está trabajando. No lo cierres ni lo vuelvas a abrir; si lo ejecutas dos veces al mismo tiempo, la instalación puede fallar.

### 1.3 Primer arranque

1. Docker Desktop **no se abre solo** después de instalar. Búscalo en el menú Inicio: **Docker Desktop**.
2. Aparecerá el acuerdo de suscripción. Selecciona **Accept** (es gratuito para uso educativo).
3. Si te pide iniciar sesión o registrarte, puedes elegir **Skip / Continue without signing in**: no se necesita cuenta para esta práctica.
4. Espera a que la esquina inferior izquierda muestre **Engine running** (motor en ejecución) con indicador verde.

> ⏳ **Ten paciencia — este es el paso más lento de toda la práctica.** La **primera vez** que haces clic en el ícono de Docker Desktop puede tardar **de 2 a 5 minutos** en abrir por completo (en equipos con disco duro mecánico o poca RAM, incluso más). Detrás de escena está creando la máquina virtual Linux dentro de WSL 2.
>
> - Durante ese tiempo verás mensajes como **«Starting the Docker Engine…»** o la ballena 🐳 animada en la bandeja del sistema (junto al reloj).
> - **No hagas doble clic varias veces** en el ícono ni cierres la ventana: solo retrasas el arranque.
> - Las siguientes veces será mucho más rápido (menos de 1 minuto).
> - Si después de **10 minutos** sigue igual, consulta la tabla de *Solución de problemas* al final.

### 1.4 Verifica desde la terminal

Docker Desktop trae una **terminal integrada**: botón **Terminal** en la esquina inferior derecha del panel. También puedes usar PowerShell. Escribe:

```powershell
docker version
```

Debes ver dos bloques: **Client** y **Server**. Si aparece el bloque *Server*, el motor funciona.

> ⏳ Si solo aparece *Client* y un error como `error during connect` o `Cannot connect to the Docker daemon`, **el motor todavía no termina de arrancar**. Espera a ver **Engine running** en Docker Desktop, espera 30 segundos más y repite el comando. La primera vez que se abre la terminal integrada también puede tardar unos segundos en mostrar el cursor.

> ### 📸 CAPTURA C1 — Docker instalado y funcionando
> En una sola captura deben verse: la ventana de **Docker Desktop** con **Engine running** y la terminal con la salida de **`docker version`** (bloques *Client* y *Server*).

---

## Paso 2 · Descargar la imagen de nginx desde la GUI

Imagen oficial que usaremos: **nginx** → <https://hub.docker.com/_/nginx>

1. En Docker Desktop, haz clic en la **barra de búsqueda** de la parte superior (o presiona `Ctrl + K`).
2. Escribe **`nginx`**.
3. En los resultados, elige el que se llama exactamente **nginx** y tiene la insignia **Docker Official Image**. No elijas variantes de otros autores (`nginx/nginx-…`, `bitnami…`, `ubuntu/nginx`, etc.).
4. Deja la etiqueta (*tag*) que aparece **seleccionada por defecto** en el menú **Tag** (por ejemplo `stable-alpine3.24-perl`); no hace falta cambiarla. **Anota cuál es**, porque la usarás en el Paso 4.

   > ℹ️ Una imagen oficial se publica en muchas **variantes** (versiones y bases distintas, como *alpine* o *perl*). Para esta práctica cualquiera funciona: todas incluyen el servidor web nginx.
5. Presiona **Pull**. Espera a que termine la descarga.

   > ⏳ **Ten paciencia:** la búsqueda puede tardar unos segundos en mostrar resultados, porque consulta Docker Hub por internet. La descarga (decenas de MB, según la variante) tarda **de 1 a 5 minutos** según la red; si tu internet en casa es lento o hay otras personas usándolo al mismo tiempo (videos, juegos, descargas), puede tardar más. **No presiones Pull otra vez**: la barra de progreso o el ícono girando indican que sigue descargando. Cuando termine, la imagen aparece en **Images** (si no la ves, cambia de vista y regresa para refrescar la lista).
6. En el menú izquierdo abre **Images**. Debe aparecer `nginx` con la **etiqueta que descargaste**, su **Image ID**, fecha y tamaño.

> ### 📸 CAPTURA C2 — Imagen descargada
> Vista **Images** donde se lea claramente **nginx**, su **etiqueta** y su tamaño.

---

## Paso 3 · Visualizar (inspeccionar) la imagen

1. En **Images**, haz clic sobre la fila de **nginx**.
2. Se abre el detalle de la imagen. Explora:
   - **Layers / Image hierarchy:** las capas que componen la imagen. Cada capa es un cambio sobre la anterior.
   - **Image history:** los comandos que construyeron cada capa.
   - **Size / Created:** tamaño y fecha de creación.
   - **Vulnerabilities / Packages:** paquetes incluidos y posibles vulnerabilidades detectadas.
3. Observa que la imagen se basa en una distribución Linux mínima: aunque estés en Windows, **dentro del contenedor hay Linux**.

> ### 📸 CAPTURA C3 — Detalle de la imagen
> Pantalla de detalle de nginx donde se vean las **capas (layers)** o el **historial** de la imagen.

---

## Paso 4 · Cambiar el nombre de la imagen

Docker Desktop **no tiene botón para renombrar** imágenes. En Docker, «renombrar» significa **crear una nueva etiqueta (tag)** que apunta a la misma imagen. Lo haremos con un solo comando.

1. Abre la **terminal integrada** de Docker Desktop (botón **Terminal**, abajo a la derecha) o PowerShell.
2. Escribe el comando cambiando `ETIQUETA` por la **etiqueta que descargaste** (la que ves en la columna *Tag* de **Images**) y `2412345` por **tu número de cuenta**:

   ```powershell
   docker tag nginx:ETIQUETA practica6-web:2412345
   ```

   Por ejemplo, si descargaste `stable-alpine3.24-perl`:

   ```powershell
   docker tag nginx:stable-alpine3.24-perl practica6-web:2412345
   ```

   > El nombre de una imagen debe ir **en minúsculas** y sin espacios.

3. Regresa a **Images** en la GUI. Ahora verás **dos filas**: `nginx` con su etiqueta original y `practica6-web:<tu_cuenta>`.
4. Fíjate en el **Image ID**: ¡es el mismo en las dos! Son dos nombres para el mismo contenido; no se duplicó el espacio en disco.

> ### 📸 CAPTURA C4 — Imagen renombrada
> Vista **Images** mostrando **`practica6-web:<tu_cuenta>`** junto a **`nginx`** con su etiqueta original (con el mismo Image ID), y la terminal con el comando **`docker tag`** visible.

---

## Paso 5 · Lanzar el contenedor desde la GUI

1. En **Images**, pasa el cursor sobre la fila **`practica6-web:<tu_cuenta>`** y presiona el botón **Run** (▶).
2. En la ventana que aparece, despliega **Optional settings** y llena:

   | Campo | Valor |
   |---|---|
   | **Container name** | `web-practica6` |
   | **Host port** (junto a `80/tcp`) | `8080` |

   > Así creas el mapeo **8080 (tu computadora) → 80 (contenedor)**. Consulta el segundo diagrama del [README](./README.md) para entender el recorrido.

3. Presiona **Run**.

   > ⏳ El contenedor suele arrancar en **unos segundos**, pero la vista puede tardar un momento en actualizarse. Si al abrir `localhost:8080` el navegador dice «No se puede acceder a este sitio», espera **10–15 segundos** y recarga antes de suponer que algo falló.
4. Ve a **Containers** en el menú izquierdo. Debes ver `web-practica6` con estado **Running** (verde) y la columna **Port(s)** con **`8080:80`**.
5. Haz clic en el enlace `8080:80` (o abre el navegador en <http://localhost:8080>). Debe aparecer **«Welcome to nginx!»**.

> ### 📸 CAPTURA C5 — Contenedor en ejecución
> Vista **Containers** con **`web-practica6`** en estado **Running**, la imagen **`practica6-web:<tu_cuenta>`** y los puertos **`8080:80`**.

---

## Paso 6 · Modificar el HTML dentro del contenedor

Ahora cambiarás la página que sirve nginx para que muestre que estás corriendo en Docker, con tu nombre y número de cuenta.

1. En **Containers**, haz clic sobre el nombre **`web-practica6`**.
2. Abre la pestaña **Exec**. Es una terminal **dentro del contenedor** (verás un símbolo `#`: estás en Linux).

   > ⏳ La pestaña **Exec** puede tardar **unos segundos** en conectarse y mostrar el `#`. Espera a ver el cursor antes de pegar el comando; si pegas antes, el texto puede perderse.
3. Copia el siguiente comando en un editor (Bloc de notas), **reemplaza `TU NOMBRE COMPLETO` y `TU_NUMERO_DE_CUENTA`**, y luego pégalo en la pestaña Exec y presiona `Enter`:

   ```sh
   echo '<!DOCTYPE html><html lang="es"><head><meta charset="utf-8"><title>Practica 6 - Docker GUI</title></head><body style="font-family:Calibri,Arial,sans-serif;text-align:center;margin-top:12%;background:#ffffff;"><h1 style="color:#2C5234;">Estoy corriendo en un contenedor Docker</h1><p style="font-size:1.4em;"><strong>Nombre:</strong> TU NOMBRE COMPLETO</p><p style="font-size:1.4em;"><strong>Numero de cuenta:</strong> TU_NUMERO_DE_CUENTA</p><hr style="width:40%;border:2px solid #9C8412;"><p style="color:#9C8412;">Practica 6 &middot; Docker GUI &middot; UAEMEX</p></body></html>' > /usr/share/nginx/html/index.html
   ```

   > El texto va sin acentos a propósito: así evitas problemas de codificación al pegar en la terminal.
   > Si tu nombre lleva apóstrofo (`'`), quítalo: rompería el comando.

4. Verifica que el archivo cambió:

   ```sh
   cat /usr/share/nginx/html/index.html
   ```

5. Regresa al navegador en <http://localhost:8080> y recarga **sin caché**: `Ctrl + F5`.

> ### 📸 CAPTURA C6 — Resultado final
> Navegador mostrando la barra de direcciones con **`localhost:8080`** y la página con **«Estoy corriendo en un contenedor Docker»**, **tu nombre** y **tu número de cuenta**.

**Reflexiona para tu conclusión:** modificaste un archivo en la **capa escribible del contenedor**, no en la imagen. Si ejecutas otro contenedor desde `practica6-web:<tu_cuenta>`, ¿verá tu página o la de nginx por defecto?

---

## Paso 7 · Armar y entregar el PDF

Nombre del archivo:

```
P6_DockerGUI_<ApellidoPaterno>_<NumeroDeCuenta>.pdf
```

Contenido:

1. **Portada:** UAEMEX · unidad de aprendizaje · «Práctica 6 · Docker GUI» · nombre completo · número de cuenta · «Windows 11 / 10» · fecha.
2. **Capturas C1 a C6** en orden, cada una con un pie de foto de una línea.
3. **Conclusión** de 3 a 5 líneas (diferencia entre imagen y contenedor; qué pasaría con tu HTML si borras el contenedor).

### ✅ Lista de verificación antes de entregar

- [ ] C1 muestra *Engine running* **y** la salida de `docker version`.
- [ ] C2 muestra `nginx` y su etiqueta en **Images**.
- [ ] C3 muestra capas o historial de la imagen.
- [ ] C4 muestra `practica6-web:<mi_cuenta>` y el comando `docker tag`.
- [ ] C5 muestra `web-practica6` en **Running** con `8080:80`.
- [ ] C6 muestra `localhost:8080` con **mi nombre y mi número de cuenta**.
- [ ] El PDF tiene el nombre correcto y una conclusión.

---

## 🛠️ Solución de problemas frecuentes

| Síntoma | Causa probable | Solución |
|---|---|---|
| «Virtualization support not detected» | Virtualización desactivada en BIOS | Paso 0.1: activar VT-x / AMD-V |
| Docker Desktop pide actualizar WSL o no arranca | WSL antiguo | `wsl --update` en PowerShell (Administrador) y reiniciar |
| Se queda en «Starting the Docker Engine…» | Arranque lento o bloqueado | Espera 2–3 minutos; si sigue, menú de la ballena → **Quit Docker Desktop** y ábrelo de nuevo |
| `Bind for 0.0.0.0:8080 failed: port is already allocated` | Otro programa usa el puerto 8080 | Elimina el contenedor y vuelve a crearlo con **Host port** `8081`; abre `localhost:8081` |
| `No such image: nginx:...` al hacer `docker tag` | La etiqueta no coincide con la que descargaste | Copia la etiqueta **exactamente** como aparece en la columna *Tag* de **Images** |
| `invalid reference format` al hacer `docker tag` | Mayúsculas o espacios en el nombre | Usa solo minúsculas, números y guiones: `practica6-web:2412345` |
| El navegador sigue mostrando «Welcome to nginx!» | Caché del navegador | `Ctrl + F5` o abre una ventana de incógnito |
| El comando `echo` no hace nada o marca error | Comillas rotas al pegar | Asegúrate de que el comando empieza con `echo '` y termina con `' > /usr/share/nginx/html/index.html` |

## 🧹 Limpieza (opcional, después de entregar)

En **Containers**: botón ■ **Stop** y luego 🗑️ **Delete** en `web-practica6`. En **Images**: 🗑️ en `practica6-web` y `nginx`. **No desinstales Docker Desktop**: lo usarás en las siguientes prácticas (ver la nota al final).

---

## 📚 Referencias recientes para consultar

1. **Blog (español, 2026):** *Cómo instalar Docker Desktop en Windows (guía 2026)* — Donweb News. Requisitos, orden correcto WSL 2 → instalador → verificación y errores comunes.
   <https://donweb.news/instalar-docker-desktop-windows-guia-2026/>
2. **Blog (inglés, 2026):** *How to Run Nginx in a Docker Container: A Step-by-Step Guide* — iTechGuides. El mismo ejercicio de nginx pero con línea de comandos, útil para comparar GUI vs. CLI.
   <https://www.itechguides.com/how-to-run-nginx-in-a-docker-container-a-step-by-step-guide/>
3. **Video (inglés, 2026):** *Docker in 10 Minutes* — guía rápida para principiantes sobre imágenes, contenedores y puertos (activa subtítulos en español).
   <https://www.youtube.com/watch?v=ZyWBs0CU2wk>

**Documentación oficial:** instalación en Windows <https://docs.docker.com/desktop/setup/install/windows-install/> · vista Images <https://docs.docker.com/desktop/use-desktop/images/> · imagen nginx <https://hub.docker.com/_/nginx>

---

## 🔔 Importante: no desinstales Docker

> **Esta práctica es la base de las siguientes prácticas del curso.** Docker Desktop, WSL 2 (en Windows) y la configuración que hiciste hoy se seguirán usando en las próximas sesiones.
>
> - **No desinstales Docker Desktop** al terminar ni lo borres para liberar espacio.
> - Si al día siguiente no aparece la ballena 🐳, solo **abre Docker Desktop** otra vez. Arrancará más rápido que la primera vez.
> - La *Limpieza (opcional)* de esta guía solo borra el contenedor y las imágenes de la práctica, **no** el programa. Si tienes dudas, mejor no borres nada.
> - Si cambias de computadora o formateas tu equipo, avisa a tu profesor y repite los Pasos 0 y 1 antes de la siguiente práctica.
