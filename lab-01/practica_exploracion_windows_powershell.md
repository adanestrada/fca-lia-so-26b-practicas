# Práctica de Laboratorio: Exploración del Sistema Operativo Windows con PowerShell

**Duración:** 2 sesiones de 1 hora
**Herramienta:** PowerShell (no requiere permisos de administrador)
**Entregable:** un único archivo `.log` con evidencia de todos los comandos ejecutados

---

## Instrucciones generales (leer antes de empezar)

- Vas a trabajar en un equipo **compartido** del laboratorio. No vas a instalar nada ni a dejar configuraciones permanentes: todo lo que declares (tus datos personales) vive solo mientras la ventana de PowerShell esté abierta.
- Para abrir PowerShell: **Inicio → escribe "PowerShell" → Enter.** No necesitas "Ejecutar como administrador".
- Vas a copiar y pegar cada comando **uno por uno**, presionando Enter después de cada uno, y observando la salida antes de continuar.
- Antes de cada comando encontrarás un comentario (línea que empieza con `#`) explicando qué hace y para qué sirve. Ese comentario también lo puedes pegar en la consola sin problema: PowerShell lo ignora como código.
- Al final de la Sesión 1 vas a **cerrar** el registro y al inicio de la Sesión 2 lo vas a **reabrir en modo "continuar"**, para que todo quede junto en un solo archivo.

---

## SESIÓN 1 (60 min) — Identidad y datos generales del equipo

### Paso 1. Iniciar el registro de evidencia

```powershell
# Declara tus datos de identidad primero para usarlos en el nombre del archivo.
$env:NOMBRE_APELLIDOS = "NOMBRE_APELLIDO1_APELLIDO2"
$env:NUM_CUENTA = "12345678"

# Resuelve la carpeta del Escritorio de forma portable.
# En Windows, el nombre real puede cambiar por idioma o perfil; si no existe, usa la carpeta actual.
$logDir = [Environment]::GetFolderPath('Desktop')
if (-not $logDir -or -not (Test-Path -LiteralPath $logDir)) {
    $logDir = $PWD.Path
}

# Genera la ruta del archivo de evidencia sin asumir una carpeta fija ni idioma.
$logPath = Join-Path $logDir "practica_SO_$env:NUM_CUENTA.log"

# Inicia la grabación de todo lo que aparezca en la consola (comandos y salidas)
Start-Transcript -Path $logPath
```

📌 **Qué observar:** PowerShell debe confirmar `Transcript started, output file is ...`. Si no aparece esa línea, el archivo no se está guardando: avisa a tu profesor(a).

> Si tu equipo usa un entorno con el Escritorio en otra ruta o con sincronización en OneDrive, esta versión sigue funcionando porque calcula la ruta real del sistema.

---

### Paso 2. Declarar tus variables de identidad

```powershell
# Crea dos variables de entorno de sesión con tus datos.
# Solo existen mientras esta ventana esté abierta; no modifican el equipo de forma permanente.
$env:NOMBRE_APELLIDOS = "NOMBRE_APELLIDO1_APELLIDO2"
$env:NUM_CUENTA = "12345678"
```

Sustituye los valores por los tuyos, por ejemplo:
`$env:NOMBRE_APELLIDOS = "JUAN_PEREZ_LOPEZ"`

### Paso 3. Mostrar tus variables (para que queden en el log como evidencia)

```powershell
# Imprime en pantalla el valor de cada variable declarada
Write-Output "Nombre y apellidos: $env:NOMBRE_APELLIDOS"
Write-Output "Número de cuenta: $env:NUM_CUENTA"
```

📌 **Qué observar:** confirma que tus datos aparecen escritos correctamente, sin errores de dedo, ya que esto identifica tu evidencia.

---

### Paso 4. Versión del sistema operativo

```powershell
# Consulta datos generales del sistema operativo: nombre, versión, compilación (build)
Get-ComputerInfo | Select-Object WindowsProductName, WindowsVersion, OsHardwareAbstractionLayer
```

📌 **Qué observar:** anota el nombre del sistema operativo (ej. "Windows 11 Pro") y su número de versión.

*(Si el comando tarda mucho, es normal: `Get-ComputerInfo` recopila muchos datos. Espera a que termine.)*

---

### Paso 5. Nombre del equipo (hostname)

```powershell
# Muestra el nombre con el que este equipo se identifica en la red del laboratorio
$env:COMPUTERNAME
```

*Equivalente en CMD: `hostname`*

📌 **Qué observar:** este nombre suele indicar el número de aula/equipo (ej. `LAB3-PC12`); anótalo, te sirve para saber en qué máquina trabajaste.

---

### Paso 6. Memoria RAM total y disponible

```powershell
# Consulta la memoria física total instalada y la que está libre en este momento (en MB)
Get-CimInstance Win32_OperatingSystem |
    Select-Object @{N="RAM Total (MB)";E={[math]::Round($_.TotalVisibleMemorySize/1KB,0)}},
                  @{N="RAM Libre (MB)";E={[math]::Round($_.FreePhysicalMemory/1KB,0)}}
```

📌 **Qué observar:** compara la RAM total instalada contra la disponible en este momento; la diferencia es lo que otros programas ya están usando.

---

### Paso 7. Procesador: modelo y núcleos

```powershell
# Muestra el modelo del procesador, sus núcleos físicos y sus núcleos lógicos (hilos)
Get-CimInstance Win32_Processor | Select-Object Name, NumberOfCores, NumberOfLogicalProcessors
```

📌 **Qué observar:** anota el modelo exacto del CPU y compara núcleos físicos vs. lógicos (si son distintos, el procesador tiene Hyper-Threading/SMT).

---

### Cierre de la Sesión 1

```powershell
# Detiene la grabación; el archivo .log queda guardado con todo lo hecho hasta ahora
Stop-Transcript
```

⚠️ **No cierres la ventana todavía sin ejecutar este comando**, o el archivo puede quedar incompleto.

---
---

## SESIÓN 2 (60 min) — Periféricos, procesos y consumo de recursos

### Paso 8. Reabrir el registro (continuar el mismo archivo)

```powershell
# Reabre PowerShell y vuelve a declarar tus variables (se perdieron al cerrar la ventana anterior)
$env:NOMBRE_APELLIDOS = "NOMBRE_APELLIDO1_APELLIDO2"
$env:NUM_CUENTA = "12345678"

# Reutiliza la misma ruta del archivo de la sesión anterior sin asumir una carpeta fija.
$logDir = [Environment]::GetFolderPath('Desktop')
if (-not $logDir -or -not (Test-Path -LiteralPath $logDir)) {
    $logDir = $PWD.Path
}
$logPath = Join-Path $logDir "practica_SO_$env:NUM_CUENTA.log"

# Reanuda la grabación agregando (Append) al mismo archivo de la Sesión 1
Start-Transcript -Path $logPath -Append
```

📌 **Qué observar:** verifica que el mensaje de confirmación aparezca; si cambiaste la ruta manualmente o usaste otro nombre, tu evidencia quedará en dos archivos y eso no es lo que se pide.

---

### Paso 9. Periféricos y versión de sus drivers

```powershell
# Lista los dispositivos conectados (periféricos y controladores) y la versión de su driver
Get-CimInstance Win32_PnPSignedDriver |
    Select-Object DeviceName, DriverVersion |
    Sort-Object DeviceName |
    Format-Table -AutoSize
```

📌 **Qué observar:** identifica al menos 5 periféricos reales (ej. mouse, teclado, tarjeta de red, tarjeta de video, monitor) y anota su versión de driver.

---

### Paso 10. Software / procesos clave del sistema en ejecución

```powershell
# Extracto simple: lista, en orden alfabético, los procesos que están corriendo ahora mismo
Get-Process | Sort-Object Name | Select-Object -First 20 Name, Id
```

📌 **Qué observar:** busca procesos típicos del sistema operativo (ej. `explorer`, `svchost`, `winlogon`, `System`) y distíngelos de programas de usuario que tengas abiertos (ej. navegador).

---

### Paso 11. Top 5 procesos con más uso de RAM

```powershell
# Ordena todos los procesos por memoria de trabajo (WS) de mayor a menor y muestra los 5 primeros
Get-Process |
    Sort-Object WS -Descending |
    Select-Object -First 5 Name, @{N="RAM (MB)";E={[math]::Round($_.WS/1MB,2)}}
```

📌 **Qué observar:** ¿qué proceso consume más RAM en este momento? ¿Es el sistema operativo o alguna aplicación que abriste?

---

### Paso 12. Top 5 procesos con más uso de CPU

```powershell
# Ordena los procesos por tiempo total de procesador consumido desde que iniciaron, de mayor a menor
# Nota: esto es tiempo acumulado, no un porcentaje "en vivo" (para eso se usaría el Administrador de tareas)
Get-Process |
    Sort-Object CPU -Descending |
    Select-Object -First 5 Name, @{N="CPU (s)";E={[math]::Round($_.CPU,2)}}
```

📌 **Qué observar:** compara este resultado con lo que ves en el Administrador de tareas (Ctrl+Shift+Esc) en la pestaña "Procesos", ordenando por CPU. ¿Coincide el proceso que aparece en primer lugar?

---

### Cierre de la práctica

```powershell
# Detiene definitivamente la grabación; el archivo .log queda completo y listo para entregar
Stop-Transcript
```

---

## Instrucciones de entrega

1. Busca el archivo `practica_SO_TUNUMEROCUENTA.log` en la carpeta del Escritorio que PowerShell resolvió para ti. Si tu equipo no tiene ese Escritorio disponible, puede estar guardado en la carpeta actual de PowerShell.
2. Ábrelo con el Bloc de notas y verifica que contenga: tus variables de identidad (Paso 3), y las salidas de los pasos 4 a 12.
3. Verifica que el archivo **no esté vacío** (0 KB) — si lo está, probablemente olvidaste ejecutar `Start-Transcript` antes de continuar; vuelve a repetir la práctica.
4. Sube el archivo `.log` a la plataforma del curso en la tarea correspondiente. **No lo renombres** (debe conservar tu número de cuenta en el nombre).

> En equipos con Windows en español, inglés u otra configuración, la carpeta del Escritorio puede tener una ruta distinta, por eso se recomienda usar la ruta calculada por PowerShell, no una ruta literal como `"$HOME\Desktop\..."`.

### Checklist antes de entregar
- [ ] El archivo incluye `NOMBRE_APELLIDOS` y `NUM_CUENTA` correctos.
- [ ] Aparece la versión de Windows y el hostname.
- [ ] Aparece la RAM total/disponible y el procesador con sus núcleos.
- [ ] Aparece la lista de periféricos con versión de driver.
- [ ] Aparece la lista de procesos y los Top 5 de RAM y de CPU.
- [ ] El archivo tiene un solo nombre y contiene ambas sesiones.
