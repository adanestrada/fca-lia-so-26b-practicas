# Práctica 6 · Docker GUI — Guía para **macOS** 🍎

> ¿Tienes Windows? Usa [`Practica6_Windows.md`](./Practica6_Windows.md). Para la visión general y los diagramas, consulta el [`README.md`](./README.md).

**Lo que vas a hacer:** instalar Docker Desktop, descargar la imagen de **nginx** desde la GUI, inspeccionarla, renombrarla, lanzar un contenedor y personalizar su página web con tu nombre y número de cuenta.

**Lo que vas a entregar:** un PDF con **6 capturas** (marcadas en esta guía con 📸).

---

## 📋 Antes de empezar

Ten a la mano estos datos; los usarás varias veces:

| Dato | Ejemplo | Tu valor |
|---|---|---|
| Nombre completo | Ana Sofía López Martínez | ______________ |
| Número de cuenta | `2412345` | ______________ |

**Cómo tomar capturas en macOS:**
- `Cmd + Shift + 4` → arrastra para seleccionar un área.
- `Cmd + Shift + 4`, luego `Espacio` → clic en una ventana para capturarla completa.
- `Cmd + Shift + 5` → panel con todas las opciones.

Las capturas se guardan en el Escritorio. Renómbralas `C1.png`, `C2.png`, … `C6.png` para armar tu PDF al final.

---

## Paso 0 · Verificar requisitos

Requisitos oficiales de Docker Desktop para Mac:

- **macOS con soporte vigente:** Docker da soporte a la versión actual de macOS y a las **dos anteriores**. Si tu Mac tiene una versión más antigua, actualízala primero (**Configuración del Sistema → General → Actualización de software**).
- **Al menos 4 GB de RAM** (8 GB o más se recomienda para trabajar cómodo).

### 0.1 Identifica tu chip

Menú  → **Acerca de esta Mac**:

- Si la línea **Chip** dice *Apple M1, M2, M3, M4…* → tienes **Apple Silicon**.
- Si la línea **Procesador** dice *Intel* → tienes **Intel**.

### 0.2 (Opcional, solo Apple Silicon) Rosetta 2

Ya **no es obligatorio**, pero Docker lo recomienda para la mejor experiencia. En la app **Terminal**:

```bash
softwareupdate --install-rosetta
```

> La imagen de nginx que usaremos es **multiarquitectura**: funciona de forma nativa en Apple Silicon, sin emulación.

---

## Paso 1 · Descargar e instalar Docker Desktop

### 1.1 Descarga (URLs oficiales)

| Tu Mac | Enlace oficial de descarga |
|---|---|
| **Apple Silicon** (M1–M4) | <https://desktop.docker.com/mac/main/arm64/Docker.dmg> |
| **Intel** | <https://desktop.docker.com/mac/main/amd64/Docker.dmg> |
| Página oficial con instrucciones | <https://docs.docker.com/desktop/setup/install/mac-install/> |

> ⚠️ Descargar el `.dmg` equivocado es el error más común. Revisa el Paso 0.1.

### 1.2 Instalación

1. Cierra antes aplicaciones que puedan usar Docker en segundo plano (VS Code, terminales abiertas).
2. Doble clic en **`Docker.dmg`**.
3. Arrastra el ícono de **Docker** a la carpeta **Aplicaciones**.
4. Mantén el volumen del instalador montado hasta que termine la copia.

> ⏳ **Ten paciencia:** copiar Docker a *Aplicaciones* puede tardar **1–3 minutos**, porque la app es grande. Espera a que desaparezca la barra de copia de Finder antes de expulsar el volumen `Docker`.

### 1.3 Primer arranque

1. Abre **Aplicaciones → Docker.app** (doble clic). macOS puede preguntar si deseas abrir una app descargada de internet: acepta.
2. Aparecerá el acuerdo de suscripción. Selecciona **Accept** (es gratuito para uso educativo).
3. En la ventana de instalación elige **Use recommended settings (Requires password)** y presiona **Finish**. Escribe la contraseña de tu Mac cuando la pida.
4. Si te pide iniciar sesión o registrarte, puedes elegir **Skip / Continue without signing in**: no se necesita cuenta para esta práctica.
5. Espera a que aparezca la **ballena** 🐳 en la barra de menús y que Docker Desktop muestre **Engine running** con indicador verde (esquina inferior izquierda).

> ⏳ **Ten paciencia — este es el paso más lento de toda la práctica.** La **primera vez** que abres Docker.app puede tardar **de 2 a 5 minutos** en estar lista:
>
> - Primero, macOS **verifica la app** («Verificando “Docker”…»). Con una app de este tamaño, la verificación puede tomar uno o dos minutos.
> - Después, Docker crea la máquina virtual Linux. Verás **«Starting the Docker Engine…»** y la ballena 🐳 **animada** en la barra de menús.
> - **No hagas doble clic varias veces** en el ícono ni fuerces la salida: solo retrasas el arranque.
> - Las siguientes veces será mucho más rápido (menos de 1 minuto).
> - Si después de **10 minutos** sigue igual, consulta la tabla de *Solución de problemas* al final.

### 1.4 Verifica desde la terminal

Docker Desktop trae una **terminal integrada**: botón **Terminal** en la esquina inferior derecha del panel. También puedes usar la app **Terminal** de macOS. Escribe:

```bash
docker version
```

Debes ver dos bloques: **Client** y **Server**. Si aparece el bloque *Server*, el motor funciona. En Apple Silicon verás la arquitectura `arm64`.

> ⏳ Si solo aparece *Client* y un error como `Cannot connect to the Docker daemon`, **el motor todavía no termina de arrancar**. Espera a ver **Engine running** en Docker Desktop, espera 30 segundos más y repite el comando. La primera vez que se abre la terminal integrada también puede tardar unos segundos en mostrar el cursor.

> ### 📸 CAPTURA C1 — Docker instalado y funcionando
> En una sola captura deben verse: la ventana de **Docker Desktop** con **Engine running** y la terminal con la salida de **`docker version`** (bloques *Client* y *Server*).

---

## Paso 2 · Descargar la imagen de nginx desde la GUI

Imagen oficial que usaremos: **nginx** → <https://hub.docker.com/_/nginx>

1. En Docker Desktop, haz clic en la **barra de búsqueda** de la parte superior (o presiona `Cmd + K`).
2. Escribe **`nginx`**.
3. En los resultados, elige el que se llama exactamente **nginx** y tiene la insignia **Docker Official Image**. No elijas variantes de otros autores.
4. Verifica que la etiqueta (*tag*) seleccionada sea **`latest`**.
5. Presiona **Pull**. Espera a que termine la descarga.

   > ⏳ **Ten paciencia:** la búsqueda puede tardar unos segundos en mostrar resultados, porque consulta Docker Hub por internet. La descarga de nginx (unos 70 MB) tarda **de 1 a 5 minutos** según la red; si tu internet en casa es lento o hay otras personas usándolo al mismo tiempo (videos, juegos, descargas), puede tardar más. **No presiones Pull otra vez**: la barra de progreso o el ícono girando indican que sigue descargando. Cuando termine, la imagen aparece en **Images** (si no la ves, cambia de vista y regresa para refrescar la lista).
6. En el menú izquierdo abre **Images**. Debe aparecer `nginx` con tag `latest`, su **Image ID**, fecha y tamaño.

> ### 📸 CAPTURA C2 — Imagen descargada
> Vista **Images** donde se lea claramente **nginx** · **latest** y su tamaño.

---

## Paso 3 · Visualizar (inspeccionar) la imagen

1. En **Images**, haz clic sobre la fila de **nginx**.
2. Se abre el detalle de la imagen. Explora:
   - **Layers / Image hierarchy:** las capas que componen la imagen. Cada capa es un cambio sobre la anterior.
   - **Image history:** los comandos que construyeron cada capa.
   - **Size / Created:** tamaño y fecha de creación.
   - **Vulnerabilities / Packages:** paquetes incluidos y posibles vulnerabilidades detectadas.
3. Observa que la imagen se basa en una distribución Linux mínima: aunque estés en macOS, **dentro del contenedor hay Linux**.

> ### 📸 CAPTURA C3 — Detalle de la imagen
> Pantalla de detalle de nginx donde se vean las **capas (layers)** o el **historial** de la imagen.

---

## Paso 4 · Cambiar el nombre de la imagen

Docker Desktop **no tiene botón para renombrar** imágenes. En Docker, «renombrar» significa **crear una nueva etiqueta (tag)** que apunta a la misma imagen. Lo haremos con un solo comando.

1. Abre la **terminal integrada** de Docker Desktop (botón **Terminal**, abajo a la derecha) o la app **Terminal**.
2. Escribe el comando cambiando `2412345` por **tu número de cuenta**:

   ```bash
   docker tag nginx:latest practica6-web:2412345
   ```

   > El nombre de una imagen debe ir **en minúsculas** y sin espacios.

3. Regresa a **Images** en la GUI. Ahora verás **dos filas**: `nginx:latest` y `practica6-web:<tu_cuenta>`.
4. Fíjate en el **Image ID**: ¡es el mismo en las dos! Son dos nombres para el mismo contenido; no se duplicó el espacio en disco.

> ### 📸 CAPTURA C4 — Imagen renombrada
> Vista **Images** mostrando **`practica6-web:<tu_cuenta>`** junto a **`nginx:latest`** (con el mismo Image ID), y la terminal con el comando **`docker tag`** visible.

---

## Paso 5 · Lanzar el contenedor desde la GUI

1. En **Images**, pasa el cursor sobre la fila **`practica6-web:<tu_cuenta>`** y presiona el botón **Run** (▶).
2. En la ventana que aparece, despliega **Optional settings** y llena:

   | Campo | Valor |
   |---|---|
   | **Container name** | `web-practica6` |
   | **Host port** (junto a `80/tcp`) | `8080` |

   > Así creas el mapeo **8080 (tu Mac) → 80 (contenedor)**. Consulta el segundo diagrama del [README](./README.md) para entender el recorrido.

3. Presiona **Run**.

   > ⏳ El contenedor suele arrancar en **unos segundos**, pero la vista puede tardar un momento en actualizarse. Si al abrir `localhost:8080` el navegador dice «No se puede acceder a este sitio», espera **10–15 segundos** y recarga antes de suponer que algo falló.
4. Ve a **Containers** en el menú izquierdo. Debes ver `web-practica6` con estado **Running** (verde) y la columna **Port(s)** con **`8080:80`**.
5. Haz clic en el enlace `8080:80` (o abre Safari/Chrome en <http://localhost:8080>). Debe aparecer **«Welcome to nginx!»**.

> ### 📸 CAPTURA C5 — Contenedor en ejecución
> Vista **Containers** con **`web-practica6`** en estado **Running**, la imagen **`practica6-web:<tu_cuenta>`** y los puertos **`8080:80`**.

---

## Paso 6 · Modificar el HTML dentro del contenedor

Ahora cambiarás la página que sirve nginx para que muestre que estás corriendo en Docker, con tu nombre y número de cuenta.

1. En **Containers**, haz clic sobre el nombre **`web-practica6`**.
2. Abre la pestaña **Exec**. Es una terminal **dentro del contenedor** (verás un símbolo `#`: estás en Linux).

   > ⏳ La pestaña **Exec** puede tardar **unos segundos** en conectarse y mostrar el `#`. Espera a ver el cursor antes de pegar el comando; si pegas antes, el texto puede perderse.
3. Copia el siguiente comando en un editor (TextEdit en modo texto simple, o Notas), **reemplaza `TU NOMBRE COMPLETO` y `TU_NUMERO_DE_CUENTA`**, y luego pégalo en la pestaña Exec y presiona `Enter`:

   ```sh
   echo '<!DOCTYPE html><html lang="es"><head><meta charset="utf-8"><title>Practica 6 - Docker GUI</title></head><body style="font-family:Calibri,Arial,sans-serif;text-align:center;margin-top:12%;background:#ffffff;"><h1 style="color:#2C5234;">Estoy corriendo en un contenedor Docker</h1><p style="font-size:1.4em;"><strong>Nombre:</strong> TU NOMBRE COMPLETO</p><p style="font-size:1.4em;"><strong>Numero de cuenta:</strong> TU_NUMERO_DE_CUENTA</p><hr style="width:40%;border:2px solid #9C8412;"><p style="color:#9C8412;">Practica 6 &middot; Docker GUI &middot; UAEMEX</p></body></html>' > /usr/share/nginx/html/index.html
   ```

   > El texto va sin acentos a propósito: así evitas problemas de codificación al pegar en la terminal.
   > Si tu nombre lleva apóstrofo (`'`), quítalo: rompería el comando.
   > En TextEdit usa **Formato → Convertir a texto normal**; las «comillas inteligentes» (`‘ ’`) rompen el comando.

4. Verifica que el archivo cambió:

   ```sh
   cat /usr/share/nginx/html/index.html
   ```

5. Regresa al navegador en <http://localhost:8080> y recarga **sin caché**: `Cmd + Shift + R`.

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

1. **Portada:** UAEMEX · unidad de aprendizaje · «Práctica 6 · Docker GUI» · nombre completo · número de cuenta · «macOS (Apple Silicon / Intel)» · fecha.
2. **Capturas C1 a C6** en orden, cada una con un pie de foto de una línea.
3. **Conclusión** de 3 a 5 líneas (diferencia entre imagen y contenedor; qué pasaría con tu HTML si borras el contenedor).

> En Pages o Keynote: **Archivo → Exportar a → PDF**. En Google Docs: **Archivo → Descargar → PDF**.

### ✅ Lista de verificación antes de entregar

- [ ] C1 muestra *Engine running* **y** la salida de `docker version`.
- [ ] C2 muestra `nginx` · `latest` en **Images**.
- [ ] C3 muestra capas o historial de la imagen.
- [ ] C4 muestra `practica6-web:<mi_cuenta>` y el comando `docker tag`.
- [ ] C5 muestra `web-practica6` en **Running** con `8080:80`.
- [ ] C6 muestra `localhost:8080` con **mi nombre y mi número de cuenta**.
- [ ] El PDF tiene el nombre correcto y una conclusión.

---

## 🛠️ Solución de problemas frecuentes

| Síntoma | Causa probable | Solución |
|---|---|---|
| El instalador no abre o dice que la app es incompatible | Descargaste el `.dmg` del chip equivocado | Repite el Paso 0.1 y descarga el correcto |
| Mensaje «Docker.app is damaged» | Instalación interrumpida | Sigue la guía oficial: <https://docs.docker.com/desktop/troubleshoot-and-support/troubleshoot/topics/> |
| Se queda en «Starting the Docker Engine…» | Arranque lento o bloqueado | Espera 2–3 minutos; si sigue, ballena 🐳 → **Quit Docker Desktop** y ábrelo de nuevo |
| `Bind for 0.0.0.0:8080 failed: port is already allocated` | Otro programa usa el puerto 8080 | Elimina el contenedor y vuelve a crearlo con **Host port** `8081`; abre `localhost:8081` |
| `invalid reference format` al hacer `docker tag` | Mayúsculas o espacios en el nombre | Usa solo minúsculas, números y guiones: `practica6-web:2412345` |
| El navegador sigue mostrando «Welcome to nginx!» | Caché del navegador | `Cmd + Shift + R` o abre una ventana privada |
| El comando `echo` marca error | Comillas «inteligentes» al copiar | Copia desde un editor de texto plano; el comando debe empezar con `echo '` y terminar con `' > /usr/share/nginx/html/index.html` |

## 🧹 Limpieza (opcional, después de entregar)

En **Containers**: botón ■ **Stop** y luego 🗑️ **Delete** en `web-practica6`. En **Images**: 🗑️ en `practica6-web` y `nginx`. **No desinstales Docker Desktop**: lo usarás en las siguientes prácticas (ver la nota al final).

---

## 📚 Referencias recientes para consultar

1. **Blog (inglés, 2026):** *Install Docker on macOS 2026: Desktop, Colima, and Podman* — Luca Berton. Instalación paso a paso para Apple Silicon e Intel y ajustes de recursos recomendados.
   <https://lucaberton.com/blog/install-docker-macos/>
2. **Blog (inglés, 2026):** *How to Run Nginx in a Docker Container: A Step-by-Step Guide* — iTechGuides. El mismo ejercicio de nginx pero con línea de comandos, útil para comparar GUI vs. CLI.
   <https://www.itechguides.com/how-to-run-nginx-in-a-docker-container-a-step-by-step-guide/>
3. **Video (inglés, 2026):** *Docker in 10 Minutes* — guía rápida para principiantes sobre imágenes, contenedores y puertos (activa subtítulos en español).
   <https://www.youtube.com/watch?v=ZyWBs0CU2wk>

**Documentación oficial:** instalación en Mac <https://docs.docker.com/desktop/setup/install/mac-install/> · vista Images <https://docs.docker.com/desktop/use-desktop/images/> · imagen nginx <https://hub.docker.com/_/nginx>

---

## 🔔 Importante: no desinstales Docker

> **Esta práctica es la base de las siguientes prácticas del curso.** Docker Desktop y la configuración que hiciste hoy se seguirán usando en las próximas sesiones.
>
> - **No desinstales Docker Desktop** al terminar ni lo borres para liberar espacio.
> - Si al día siguiente no aparece la ballena 🐳, solo **abre Docker Desktop** otra vez. Arrancará más rápido que la primera vez.
> - La *Limpieza (opcional)* de esta guía solo borra el contenedor y las imágenes de la práctica, **no** el programa. Si tienes dudas, mejor no borres nada.
> - Si cambias de computadora o formateas tu equipo, avisa a tu profesor y repite los Pasos 0 y 1 antes de la siguiente práctica.
