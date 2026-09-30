# Práctica 6 · Docker GUI (Docker Desktop)

**Universidad Autónoma del Estado de México (UAEMEX)**
Unidad: Virtualización y contenedores · Modalidad: individual · Entregable: **1 PDF con 6 capturas**

---

## 🎯 Objetivo

Instalar **Docker Desktop** en tu computadora y, usando principalmente su interfaz gráfica (GUI):

1. Descargar la imagen oficial del servidor web **nginx**.
2. Inspeccionar la imagen (capas, tamaño, historial).
3. Crear una copia de la imagen con **un nombre nuevo** que incluya tu número de cuenta.
4. Lanzar un **contenedor** a partir de esa imagen y abrirlo en el navegador.
5. Modificar la página HTML **dentro del contenedor** para que muestre tu nombre y número de cuenta.
6. Documentar el proceso con capturas y entregar un **PDF**.

> ⏱️ Tiempo estimado: 45–60 minutos (la instalación es lo que más tarda).

---

## 📂 ¿Qué guía debo seguir?

| Tu sistema operativo | Guía paso a paso |
|---|---|
| 🪟 **Windows 11 / Windows 10** (la mayoría del grupo) | [`Practica6_Windows.md`](./Practica6_Windows.md) |
| 🍎 **macOS** (Apple Silicon M1–M4 o Intel) | [`Practica6_macOS.md`](./Practica6_macOS.md) |

Ambas guías tienen **los mismos pasos y las mismas 6 capturas**; solo cambian la instalación y algunos atajos de teclado.

**Imagen que usaremos:** nginx (imagen oficial) → <https://hub.docker.com/_/nginx>

---

## 🗺️ Mapa completo de la práctica

Las capturas de pantalla 📸 indican los momentos exactos en los que debes tomar captura.

```mermaid
flowchart TD
    A([Inicio]) --> B{"¿Qué sistema tienes?"}
    B -- Windows --> C1["Verificar virtualización<br/>e instalar/actualizar WSL 2"]
    B -- macOS --> C2["Identificar chip<br/>Apple Silicon o Intel"]
    C1 --> D["Descargar e instalar<br/>Docker Desktop"]
    C2 --> D
    D --> E["Abrir Docker Desktop<br/>y aceptar términos"]
    E --> F["📸 C1: Docker Desktop funcionando<br/>+ docker version"]
    F --> G["Buscar 'nginx' en la GUI<br/>y hacer Pull"]
    G --> H["📸 C2: Imagen nginx<br/>en la vista Images"]
    H --> I["Abrir el detalle de la imagen<br/>capas, tamaño, historial"]
    I --> J["📸 C3: Detalle de la imagen"]
    J --> K["Renombrar la imagen con docker tag<br/>practica6-web:NUMERO_CUENTA"]
    K --> L["📸 C4: Imagen renombrada<br/>en la lista Images"]
    L --> M["Run desde la GUI<br/>nombre web-practica6, puerto 8080"]
    M --> N["📸 C5: Contenedor en ejecución<br/>con puertos 8080:80"]
    N --> O["Pestaña Exec: modificar<br/>index.html con nombre y cuenta"]
    O --> P["Abrir http://localhost:8080"]
    P --> Q["📸 C6: Navegador con tu leyenda"]
    Q --> R["Armar el PDF y entregar"]
    R --> S([Fin])

    classDef foto fill:#9C8412,color:#ffffff,stroke:#6b5a0c;
    classDef fin fill:#2C5234,color:#ffffff,stroke:#1c3622;
    class F,H,J,L,N,Q foto;
    class A,S fin;
```

---

## 🔌 ¿Cómo se conecta un contenedor con tu sistema operativo?

Un contenedor **no es una máquina virtual completa**: comparte el *kernel* (núcleo) de Linux con el sistema que lo ejecuta. Como Windows y macOS no son Linux, Docker Desktop crea una **máquina virtual Linux ligera** y ahí corre el motor de Docker. Tu navegador llega al contenedor gracias al **mapeo de puertos**.

```mermaid
flowchart LR
    subgraph HOST["💻 Tu computadora — SO anfitrión (Windows o macOS)"]
        NAV["🌐 Navegador<br/>http://localhost:8080"]
        GUI["🐳 Docker Desktop<br/>GUI + CLI docker"]

        subgraph VM["🐧 VM Linux ligera<br/>WSL 2 en Windows · Apple Virtualization en macOS"]
            ENG["Docker Engine<br/>dockerd + containerd"]
            IMG[("📦 Imagen<br/>practica6-web:CUENTA<br/>capas de solo lectura")]

            subgraph CT["Contenedor web-practica6"]
                NGX["nginx escuchando<br/>en el puerto 80"]
                HTML["Archivo index.html en<br/>/usr/share/nginx/html<br/>capa escribible"]
            end
        end
    end

    HUB[("☁️ Docker Hub<br/>hub.docker.com/_/nginx")]

    HUB -- "1. pull" --> ENG
    ENG -- "guarda" --> IMG
    GUI -- "2. órdenes: pull, tag, run, exec" --> ENG
    IMG -- "3. run crea" --> CT
    NAV -- "4. petición HTTP a localhost:8080" --> ENG
    ENG -- "5. reenvía 8080 → 80" --> NGX
    NGX -- "6. lee y responde" --> HTML

    style HOST fill:#f7f7f2,stroke:#2C5234,stroke-width:2px
    style VM fill:#eef3ef,stroke:#2C5234
    style CT fill:#fff8dc,stroke:#9C8412,stroke-width:2px
```

### La misma idea, como secuencia de una petición web

```mermaid
sequenceDiagram
    autonumber
    actor A as Alumno
    participant N as Navegador (host)
    participant D as Docker Desktop / VM Linux
    participant C as Contenedor nginx (puerto 80)

    A->>N: Escribe http://localhost:8080
    N->>D: Petición HTTP al puerto 8080 del host
    D->>C: Reenvía al puerto 80 del contenedor (mapeo 8080:80)
    C->>C: nginx lee /usr/share/nginx/html/index.html
    C-->>D: Respuesta HTML
    D-->>N: Respuesta HTML
    N-->>A: Muestra "Estoy corriendo en Docker" con tu nombre
```

---

## 📖 Conceptos clave (vocabulario mínimo)

| Concepto | En una frase |
|---|---|
| **Imagen** | Plantilla de solo lectura con todo lo necesario para ejecutar un programa (aquí: nginx + Linux mínimo). |
| **Contenedor** | Una instancia en ejecución de una imagen. Tiene su propia capa escribible encima de la imagen. |
| **Tag (etiqueta)** | El nombre `repositorio:versión` de una imagen, por ejemplo `nginx:latest`. «Renombrar» una imagen = crearle otro tag que apunta al mismo contenido. |
| **Registro** | Almacén de imágenes en internet. El público más usado es Docker Hub. |
| **Mapeo de puertos** | Regla `host:contenedor` (ej. `8080:80`) que conecta un puerto de tu computadora con uno del contenedor. |
| **Exec** | Abrir una terminal *dentro* de un contenedor que ya está corriendo. |

> ⚠️ **Importante:** el cambio que harás al `index.html` vive en la **capa escribible del contenedor**, no en la imagen. Si borras el contenedor, el cambio se pierde; la imagen sigue intacta. Es justo lo que queremos que observes.

---

## 📸 Resumen de capturas (las mismas en Windows y macOS)

| # | Momento | Qué debe verse |
|---|---|---|
| **C1** | Docker instalado | Docker Desktop abierto con el motor en ejecución y una terminal mostrando `docker version` |
| **C2** | Imagen descargada | Vista **Images** con `nginx` `latest` en la lista |
| **C3** | Imagen inspeccionada | Detalle de la imagen nginx (capas / historial / tamaño) |
| **C4** | Imagen renombrada | Lista **Images** con `practica6-web:<tu_cuenta>` y el comando `docker tag` visible |
| **C5** | Contenedor en ejecución | Vista **Containers** con `web-practica6` en verde y puertos `8080:80` |
| **C6** | Resultado final | Navegador en `localhost:8080` mostrando tu nombre y número de cuenta |

## 📄 Entregable

Un solo archivo PDF llamado:

```
P6_DockerGUI_<ApellidoPaterno>_<NumeroDeCuenta>.pdf
```

Estructura sugerida (3–4 páginas):

1. **Portada:** UAEMEX, unidad de aprendizaje, «Práctica 6 · Docker GUI», nombre completo, número de cuenta, sistema operativo usado, fecha.
2. **Capturas C1 a C6**, cada una con un pie de foto de una línea que explique qué se ve.
3. **Conclusión** (3 a 5 líneas): ¿qué diferencia observaste entre imagen y contenedor? ¿Qué pasaría con tu cambio al HTML si eliminas el contenedor?

Puedes armarlo en Word, Google Docs o Pages y exportar a PDF.

---

## 🗂️ Estructura del repositorio

```
.
├── README.md               ← este archivo (visión general + diagramas)
├── Practica6_Windows.md    ← guía detallada para Windows
└── Practica6_macOS.md      ← guía detallada para macOS
```

## 🔗 Enlaces oficiales

- Docker Desktop (página del producto): <https://www.docker.com/products/docker-desktop/>
- Instalación en Windows: <https://docs.docker.com/desktop/setup/install/windows-install/>
- Instalación en macOS: <https://docs.docker.com/desktop/setup/install/mac-install/>
- Vista *Images* de Docker Desktop: <https://docs.docker.com/desktop/use-desktop/images/>
- Imagen oficial de nginx: <https://hub.docker.com/_/nginx>

> Docker Desktop es gratuito para uso personal y **educativo**, de acuerdo con los términos de suscripción de Docker.

> 🔔 **Esta práctica es la base de las siguientes prácticas del curso: no desinstales Docker Desktop al terminar.**
