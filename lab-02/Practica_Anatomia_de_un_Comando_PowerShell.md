# Práctica Command Line Interface (CLI) Anatomía de un Comando 
## Anatomía de un Comando en la Interfaz de Línea de Comandos de Windows (PowerShell)

**Tema:** Interfaz de Línea de Comandos en Windows
**Basado en:** Diapositiva 12 · Anatomía de un comando (30:00 – 33:00)

**Nombre del alumno:** ______________________________________
**Grupo:** ___________  **Fecha:** ___________  **Calificación:** ___________

---

## 1. Objetivo de la práctica

Al finalizar esta práctica, el alumno será capaz de:

- Identificar y separar correctamente las **cuatro partes** que componen un comando ejecutado en la terminal de Windows (PowerShell): **Prompt, Comando, Opciones/Banderas y Argumentos**.
- Consultar la ayuda integrada de PowerShell (`Get-Help`) para investigar la sintaxis de un cmdlet antes de utilizarlo.
- Reconocer comandos introductorios de uso común: navegación entre directorios, listado de contenidos, creación y edición de archivos de texto.

---

## 2. Materiales necesarios

- Equipo con Windows 10 u 11.
- Acceso a **Windows PowerShell** (Inicio → escribir "PowerShell" → Enter, o `Win + X` → *Windows PowerShell*).
- En una hoja de tu cuardeno para entrega, registra tus respuestas (solo las secciones marcadas).

---

## 3. Marco conceptual: ¿de qué partes se compone un comando?

Todo comando que se escribe en la terminal sigue, de manera general, la siguiente estructura:

```
PROMPT   COMANDO   [-Opcion1 Argumento1]  [-Opcion2 Argumento2]  [-Bandera]
```

| Elemento | ¿Qué es? | ¿Cómo se identifica en PowerShell? |
|---|---|---|
| **Prompt** | Es el texto que la terminal muestra antes de que el usuario escriba algo. Indica que el sistema está listo para recibir una instrucción y normalmente muestra la ruta (directorio) actual. | Tiene la forma `PS C:\ruta\actual>` |
| **Comando** | Es la instrucción o programa (cmdlet) que le decimos a la computadora que ejecute. | En PowerShell casi siempre sigue el formato *Verbo-Sustantivo*, por ejemplo `Get-ChildItem`, `Set-Location`. |
| **Opciones / Banderas** | También llamados *parámetros*. Modifican el comportamiento del comando. Siempre inician con un guion `-`. Pueden ser: (a) **parámetros con valor**, como `-Path`, `-Name`; o (b) **banderas de interruptor (switch)** que no requieren un valor, como `-Recurse`, `-Force`, `-Confirm`. | Empiezan con `-` seguido del nombre del parámetro. |
| **Argumentos** | Son los datos o valores concretos sobre los que actúa el comando: nombres de archivos, rutas, texto, etc. En PowerShell, el argumento suele ser el **valor** que acompaña a una opción (por ejemplo, en `-Path C:\Windows`, el argumento es `C:\Windows`). | Es el texto, número o ruta que aparece después de una opción, o directamente después del comando. |

> **Importante:** No todos los comandos tienen las cuatro partes. Un comando puede ejecutarse solo con el Prompt y el Comando (sin opciones ni argumentos), como en el caso de `Get-Location`.

---

## 4. Instrucciones generales

1. Lee con atención el marco conceptual anterior antes de comenzar.
2. Revisa los **3 ejemplos resueltos** de la sección 5; te muestran exactamente cómo debes trabajar cada ejercicio.
3. Abre PowerShell y, si lo deseas, crea una carpeta de trabajo para practicar sin afectar tus archivos personales:
   ```
   PS C:\Users\Estudiante> New-Item -Path .\Desktop -Name "PracticaCLI" -ItemType Directory
   PS C:\Users\Estudiante> Set-Location -Path .\Desktop\PracticaCLI
   ```
4. En cada uno de los 10 ejercicios encontrarás:
   - **Presentación del comando:** qué es y para qué sirve el cmdlet.
   - **Ejemplo de uso:** una muestra general de su sintaxis.
   - **Cómo pedir ayuda en PowerShell:** el comando exacto que debes escribir para consultar la documentación de ese cmdlet.
   - **Comando a analizar:** la línea de comando real que debes descomponer.
   - **Tu entrega:** una tabla en blanco donde escribirás tu respuesta final.
5. Se recomienda (no obligatorio) ejecutar cada comando en tu propia terminal para comparar el resultado real con tu análisis escrito.
6. Al terminar, entrega esta hoja completa (las 10 tablas llenas) a tu docente.

---

## 5. Ejemplos resueltos

### Ejemplo 1 — Comando sin opciones

**Comando a analizar:**
```
PS C:\Users\Estudiante> Get-Location
```

| Elemento | Respuesta |
|---|---|
| Prompt | `PS C:\Users\Estudiante>` |
| Comando | `Get-Location` |
| Opciones/Banderas | *(ninguna)* |
| Argumentos | *(ninguno)* |

---

### Ejemplo 2 — Comando con una opción y un argumento

**Comando a analizar:**
```
PS C:\Users\Estudiante> Set-Location -Path "C:\Windows"
```

| Elemento | Respuesta |
|---|---|
| Prompt | `PS C:\Users\Estudiante>` |
| Comando | `Set-Location` |
| Opciones/Banderas | `-Path` |
| Argumentos | `"C:\Windows"` |

---

### Ejemplo 3 — Comando con varias opciones y varios argumentos

**Comando a analizar:**
```
PS C:\Windows> Get-ChildItem -Path . -Filter *.exe -Recurse
```

| Elemento | Respuesta |
|---|---|
| Prompt | `PS C:\Windows>` |
| Comando | `Get-ChildItem` |
| Opciones/Banderas | `-Path`, `-Filter`, `-Recurse` |
| Argumentos | `.` (valor de -Path), `*.exe` (valor de -Filter). *Nota: `-Recurse` es una bandera de interruptor, no lleva argumento.* |

---

## 6. Ejercicios (10)

> A partir de aquí, imagina que has abierto PowerShell y te encuentras trabajando dentro de tu carpeta personal de documentos.

---

### Ejercicio 1 — Ubicación actual

**Presentación del comando:** `Get-Location` muestra la ruta (directorio) en la que te encuentras actualmente dentro del sistema de archivos.

**Ejemplo de uso:** `Get-Location`

**Cómo pedir ayuda en PowerShell:**
```
PS C:\Users\Estudiante> Get-Help Get-Location
```

**Comando a analizar:**
```
PS C:\Users\Estudiante> Get-Location
```

**Tu entrega:**

| Elemento | Escribe aquí tu respuesta |
|---|---|
| Prompt | |
| Comando | |
| Opciones/Banderas | |
| Argumentos | |

---

### Ejercicio 2 — Navegar entre directorios

**Presentación del comando:** `Set-Location` permite cambiar el directorio de trabajo actual (equivalente al clásico `cd`).

**Ejemplo de uso:** `Set-Location -Path "C:\Users"`

**Cómo pedir ayuda en PowerShell:**
```
PS C:\Users\Estudiante> Get-Help Set-Location -Examples
```

**Comando a analizar:**
```
PS C:\Users\Estudiante> Set-Location -Path "C:\Users\Estudiante\Documents"
```

**Tu entrega:**

| Elemento | Escribe aquí tu respuesta |
|---|---|
| Prompt | |
| Comando | |
| Opciones/Banderas | |
| Argumentos | |

---

### Ejercicio 3 — Listar el contenido de un directorio

**Presentación del comando:** `Get-ChildItem` lista los archivos y subcarpetas contenidos en una ruta (equivalente a `dir`).

**Ejemplo de uso:** `Get-ChildItem -Path C:\Windows -Force`

**Cómo pedir ayuda en PowerShell:**
```
PS C:\Users\Estudiante\Documents> Get-Help Get-ChildItem -Detailed
```

**Comando a analizar:**
```
PS C:\Users\Estudiante\Documents> Get-ChildItem -Path . -Recurse -Filter *.txt
```

**Tu entrega:**

| Elemento | Escribe aquí tu respuesta |
|---|---|
| Prompt | |
| Comando | |
| Opciones/Banderas | |
| Argumentos | |

---

### Ejercicio 4 — Crear un directorio nuevo

**Presentación del comando:** `New-Item` crea nuevos elementos en el sistema de archivos; con el parámetro `-ItemType Directory` crea una carpeta.

**Ejemplo de uso:** `New-Item -Path . -Name "Ejemplos" -ItemType Directory`

**Cómo pedir ayuda en PowerShell:**
```
PS C:\Users\Estudiante\Documents> Get-Help New-Item -Full
```

**Comando a analizar:**
```
PS C:\Users\Estudiante\Documents> New-Item -Path . -Name "Practica1" -ItemType Directory
```

**Tu entrega:**

| Elemento | Escribe aquí tu respuesta |
|---|---|
| Prompt | |
| Comando | |
| Opciones/Banderas | |
| Argumentos | |

---

> **Nota antes de continuar:** entra a la carpeta que acabas de crear con `Set-Location -Path .\Practica1` (este paso no se analiza, solo ejecútalo para continuar la práctica).

---

### Ejercicio 5 — Crear un archivo de texto con contenido

**Presentación del comando:** `New-Item` también puede crear archivos; con `-ItemType File` y `-Value` se crea un archivo de texto y se le agrega una línea de contenido inicial.

**Ejemplo de uso:** `New-Item -Path . -Name "datos.txt" -ItemType File -Value "Hola mundo"`

**Cómo pedir ayuda en PowerShell:**
```
PS C:\Users\Estudiante\Documents\Practica1> Get-Help New-Item -Examples
```

**Comando a analizar:**
```
PS C:\Users\Estudiante\Documents\Practica1> New-Item -Path . -Name "notas.txt" -ItemType File -Value "Primera linea de texto"
```

**Tu entrega:**

| Elemento | Escribe aquí tu respuesta |
|---|---|
| Prompt | |
| Comando | |
| Opciones/Banderas | |
| Argumentos | |

---

### Ejercicio 6 — Agregar líneas a un archivo existente

**Presentación del comando:** `Add-Content` agrega texto al final de un archivo existente sin borrar lo que ya contiene.

**Ejemplo de uso:** `Add-Content -Path .\datos.txt -Value "Segunda linea"`

**Cómo pedir ayuda en PowerShell:**
```
PS C:\Users\Estudiante\Documents\Practica1> Get-Help Add-Content -Online
```

**Comando a analizar:**
```
PS C:\Users\Estudiante\Documents\Practica1> Add-Content -Path .\notas.txt -Value "Segunda linea agregada"
```

**Tu entrega:**

| Elemento | Escribe aquí tu respuesta |
|---|---|
| Prompt | |
| Comando | |
| Opciones/Banderas | |
| Argumentos | |

---

### Ejercicio 7 — Leer el contenido de un archivo

**Presentación del comando:** `Get-Content` muestra en pantalla el contenido de un archivo de texto. El parámetro `-TotalCount` limita cuántas líneas se muestran desde el inicio.

**Ejemplo de uso:** `Get-Content -Path .\notas.txt -TotalCount 5`

**Cómo pedir ayuda en PowerShell:**
```
PS C:\Users\Estudiante\Documents\Practica1> Get-Help Get-Content -Examples
```

**Comando a analizar:**
```
PS C:\Users\Estudiante\Documents\Practica1> Get-Content -Path .\notas.txt -TotalCount 1
```

**Tu entrega:**

| Elemento | Escribe aquí tu respuesta |
|---|---|
| Prompt | |
| Comando | |
| Opciones/Banderas | |
| Argumentos | |

---

### Ejercicio 8 — Copiar un archivo

**Presentación del comando:** `Copy-Item` crea una copia de un archivo o carpeta en una nueva ubicación o con un nuevo nombre.

**Ejemplo de uso:** `Copy-Item -Path .\notas.txt -Destination .\notas_copia.txt`

**Cómo pedir ayuda en PowerShell:**
```
PS C:\Users\Estudiante\Documents\Practica1> Get-Help Copy-Item -Detailed
```

**Comando a analizar:**
```
PS C:\Users\Estudiante\Documents\Practica1> Copy-Item -Path .\notas.txt -Destination .\notas_respaldo.txt
```

**Tu entrega:**

| Elemento | Escribe aquí tu respuesta |
|---|---|
| Prompt | |
| Comando | |
| Opciones/Banderas | |
| Argumentos | |

---

### Ejercicio 9 — Renombrar un archivo

**Presentación del comando:** `Rename-Item` cambia el nombre de un archivo o carpeta existente.

**Ejemplo de uso:** `Rename-Item -Path .\notas_copia.txt -NewName "copia_final.txt"`

**Cómo pedir ayuda en PowerShell:**
```
PS C:\Users\Estudiante\Documents\Practica1> Get-Help Rename-Item -Examples
```

**Comando a analizar:**
```
PS C:\Users\Estudiante\Documents\Practica1> Rename-Item -Path .\notas_respaldo.txt -NewName "notas_backup.txt"
```

**Tu entrega:**

| Elemento | Escribe aquí tu respuesta |
|---|---|
| Prompt | |
| Comando | |
| Opciones/Banderas | |
| Argumentos | |

---

### Ejercicio 10 — Eliminar un archivo con confirmación

**Presentación del comando:** `Remove-Item` elimina un archivo o carpeta. El parámetro `-Confirm` es una bandera de interruptor que hace que PowerShell pida confirmación antes de borrar.

**Ejemplo de uso:** `Remove-Item -Path .\prueba.txt -Confirm`

**Cómo pedir ayuda en PowerShell:**
```
PS C:\Users\Estudiante\Documents\Practica1> Get-Help Remove-Item -Full
```

**Comando a analizar:**
```
PS C:\Users\Estudiante\Documents\Practica1> Remove-Item -Path .\notas_backup.txt -Confirm
```

**Tu entrega:**

| Elemento | Escribe aquí tu respuesta |
|---|---|
| Prompt | |
| Comando | |
| Opciones/Banderas | |
| Argumentos | |

---

## 7. Rúbrica de evaluación sugerida

| Criterio | Puntos |
|---|---|
| Identifica correctamente el Prompt en los 10 ejercicios | 20 |
| Identifica correctamente el Comando en los 10 ejercicios | 20 |
| Identifica correctamente las Opciones/Banderas en los 10 ejercicios | 30 |
| Identifica correctamente los Argumentos en los 10 ejercicios | 30 |
| **Total** | **100** |

---

*Fin de la práctica.*
