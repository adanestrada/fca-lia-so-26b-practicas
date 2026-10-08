# Hoja de respuestas · Práctica «Un archivo, tres mundos» · Versión Codespaces

---

## Instrucciones de entrega (léelas antes de empezar)

1. Responde **a mano** en esta hoja impresa o en una hoja tamaño carta con las preguntas numeradas del 1 al 12.
2. Llena el encabezado **completo**. El identificador del equipo y la huella SHA-256 los copias de tu bitácora (registros `S1.2` y `S7.4`): así tu hoja queda ligada a tu evidencia digital.
3. Responde cada pregunta **al terminar la sección que le corresponde**. Usa tus propias palabras, de 2 a 4 renglones. Cuando se pida un dato, cópialo exactamente de tu pantalla o de tu bitácora.
4. Entrega la hoja **firmada**: en el salón, o **escaneada en PDF** como adjunto del correo si el profesor te autorizó entregar a distancia.
5. Envía también por correo tu `bitacora_<cuenta>.log` y tu `entrega_<cuenta>.zip`, como indica la Sección 7 de tu guía.

---

## Encabezado

| Campo | Respuesta |
|---|---|
| Nombre completo | |
| Número de cuenta | |
| Grupo | |
| Fecha | |
| Sistema operativo de mi computadora | |
| Identificador del codespace, `CODESPACE_NAME` (registro `S1.2`) | |
| Huella SHA-256 del `.zip`, primeros 8 caracteres (registro `S7.4`) | |

---

## Sección 1 · Identidad, carpeta y bitácora

**1.** ¿Por qué la guía tomó la carpeta de trabajo de la variable `CODESPACE_VSCODE_FOLDER` en lugar de escribir la ruta a mano o usar el Escritorio? Además, ¿por qué **no** debes ejecutar `env` sin filtro dentro del codespace?

_______________________________________________________________________________

_______________________________________________________________________________

_______________________________________________________________________________

**2.** ¿Qué significa que un procedimiento sea **idempotente**? Da **dos ejemplos** de comandos o banderas de la práctica que lo logran y explica por qué esto le importa a un administrador informático.

_______________________________________________________________________________

_______________________________________________________________________________

_______________________________________________________________________________

---

## Sección 2 · Tres mundos en la nube

**3.** Escribe la ruta completa de tu carpeta de proyecto **vista desde el codespace** y **vista desde el contenedor**. Si es la misma carpeta, ¿por qué tiene dos nombres? ¿Qué mecanismo de Docker lo permite?

Desde el codespace: ___________________________________________________________

Desde el contenedor: __________________________________________________________

_______________________________________________________________________________

**4.** Anota lo que reportaron `S2.1`, `S2.2`, `S2.3` y la primera línea de `S2.4`. ¿Qué kernels coinciden? ¿Qué te indican las palabras **`azure`** y **`(containerized)`**? Describe en orden los «mundos» por los que pasa tu trabajo, desde tu computadora hasta el contenedor Alpine.

Cliente / Servidor (S2.1): ____________________________________________________

Codespace (S2.2): _____________________ Motor de Docker (S2.3): _______________

Contenedor (S2.4): ____________________________________________________________

_______________________________________________________________________________

_______________________________________________________________________________

**5.** ¿Por qué desapareció `/tmp/prueba.txt` y en cambio sobrevivió `/datos/firma.txt`? ¿Por qué tu usuario **no pudo** ver `/var/lib/docker/volumes` y con `sudo` sí? ¿Qué principio de seguridad muestra esto?

_______________________________________________________________________________

_______________________________________________________________________________

_______________________________________________________________________________

---

## Sección 3 · Navegación

**6.** ¿Cuál es la diferencia entre una **ruta absoluta** y una **relativa**? Da un ejemplo de cada una que hayas usado. Además, ¿qué información extra te dieron `ls -l`, `ls -la` y `ls -lh`, y en qué situación de trabajo usarías cada una?

_______________________________________________________________________________

_______________________________________________________________________________

_______________________________________________________________________________

---

## Sección 4 · Construir y editar

**7.** Describe la diferencia entre `cp`, `mv` y `rm` según lo que hiciste con `notas.txt`, `borrador.txt` y `basura.tmp`. ¿Por qué `rm` en un servidor Linux es más riesgoso que «Eliminar» en tu explorador de archivos? ¿Qué hiciste **antes** de modificar `notas.txt` que te protege de ese riesgo?

_______________________________________________________________________________

_______________________________________________________________________________

_______________________________________________________________________________

**8.** ¿Cuántos archivos quedaron al crear `Nota.txt` y `nota.txt` en el contenedor (`S4.5`), en el codespace (`S7.1`) y, si hiciste la prueba opcional, en tu computadora? ¿Por qué el codespace se comporta igual que el contenedor? Describe un **problema real** que esto podría causar al copiar archivos de un servidor Linux a una computadora con Windows o macOS.

Contenedor: ____ archivos   Codespace: ____ archivos   Mi computadora: ____ archivos

_______________________________________________________________________________

_______________________________________________________________________________

---

## Sección 5 · Analizar datos

**9.** ¿Cuántas líneas tiene `inventario.csv` y cuántos equipos registra realmente? ¿Cuántos están en mantenimiento? Escribe el **comando que usaste en el reto** para contar los equipos con Windows y su resultado.

Líneas: ______  Equipos: ______  En mantenimiento: ______

Comando del reto: _____________________________________________  Resultado: ______

**10.** ¿En qué casos conviene usar `less` en lugar de `cat`? Relaciónalo con la revisión de la bitácora de un servidor que mide varios gigabytes.

_______________________________________________________________________________

_______________________________________________________________________________

---

## Sección 6 · Sistema y red

**11.** Según `S6.1` y `S6.2`, ¿qué tipo y qué tamaño tiene el sistema de archivos de `/` y el de `/practica`? Si «están en el mismo contenedor», ¿por qué no son iguales?

`/` : ___________________   `/practica` : ___________________

_______________________________________________________________________________

_______________________________________________________________________________

**12.** ¿Cuántos procesos mostró `top` en el contenedor y cuántos `ps -e | wc -l` en el codespace? ¿A qué se debe la diferencia? El `ping` a 8.8.8.8 no respondió, pero la conexión HTTPS sí funcionó: ¿qué concluyes como administrador?

Procesos en el contenedor: ______   En el codespace: ______

_______________________________________________________________________________

_______________________________________________________________________________

_______________________________________________________________________________

---

Declaro que realicé personalmente esta práctica en el codespace indicado en el encabezado.

Firma del alumno: ______________________________

**Para uso del profesor:** Bitácora ☐  ZIP ☐  Huella coincide ☐  Codespace coincide ☐  Calificación: ______
