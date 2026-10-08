# Crear y asegurar tu cuenta de GitHub

> **Tiempo:** 10 a 15 minutos. Hazlo **antes** de empezar la práctica.
> **Costo:** ninguno. No necesitas tarjeta de crédito.

**¿Por qué importa?** GitHub es la plataforma donde millones de organizaciones guardan su código y administran sus servidores en la nube. Una cuenta bien configurada es tu identidad profesional en ese mundo: si alguien entra a ella, puede usar tus recursos o hacerse pasar por ti. Por eso aquí no solo la creas: también la **verificas** y la **proteges**.

---

## Antes de empezar

- [ ] Un **correo electrónico** al que tengas acceso ahora mismo (institucional o personal).
- [ ] Una **contraseña nueva** que no uses en ningún otro sitio.
- [ ] Opcional pero recomendado: tu **celular** con una app de autenticación (Google Authenticator, Microsoft Authenticator u otra similar).

> 🔒 **Regla de oro:** escribe siempre la dirección **https://github.com** tú mismo. GitHub **nunca** te pedirá tu contraseña por correo. Si recibes un mensaje que te la pide, es un intento de robo de cuenta (*phishing*).

---

## Paso 1 · Crear la cuenta (5 min)

1. Abre **https://github.com/signup**
2. GitHub te pedirá, uno por uno:
   - **Correo electrónico.**
   - **Contraseña.** GitHub pide al menos **15 caracteres**, o al menos **8 que incluyan un número y una letra minúscula**. Una frase larga es fácil de recordar y difícil de adivinar, por ejemplo: `mi-gato-come-tacos-los-martes`.
   - **Nombre de usuario.** Será público. Elige uno profesional, sin datos sensibles (ni fecha de nacimiento ni número de cuenta). Ejemplo: `ana-lopez-dev`.
   - **País o región.**
   - **Preferencias de correo:** puedes desmarcar la casilla de anuncios.
3. Resuelve la **verificación** que te muestre (un pequeño rompecabezas o pregunta). Sirve para comprobar que eres una persona y no un programa automático.
4. Revisa tu correo: GitHub te enviará un **código** o un **enlace**. Escríbelo o ábrelo para continuar.
5. Si GitHub te ofrece planes o te hace preguntas de bienvenida, elige la opción **gratuita** (*Free* o *Continue for free*) y puedes omitir las preguntas.

> **Alternativa:** en la página de registro también aparece **Continue with Google**. Funciona igual; aun así, completa los pasos 2 y 3 de esta guía.

---

## Paso 2 · Verificar tu correo (2 min)

**¿Por qué?** Sin un correo verificado, GitHub **no te deja crear repositorios**, y la práctica necesita uno. Además, el correo verificado es la forma de **recuperar tu cuenta** si olvidas la contraseña.

1. Inicia sesión en https://github.com
2. Haz clic en tu **foto de perfil** (esquina superior derecha) › **Settings**.
3. En el menú de la izquierda, sección **Access**, entra a **Emails**.
4. Busca tu correo en la lista:
   - Si dice **Verified** o no muestra ningún aviso, ya está listo. ✅
   - Si dice **Unverified**, haz clic en **Resend verification email**, abre el correo que te llegue y haz clic en el enlace.
5. En esa misma página, activa **Keep my email addresses private**. Así tu correo no queda expuesto públicamente.

---

## Paso 3 · Proteger tu cuenta con doble verificación (5 min, recomendado)

La **verificación en dos pasos** (2FA) pide, además de la contraseña, un código que cambia cada 30 segundos en tu celular. Aunque alguien robe tu contraseña, no puede entrar sin tu teléfono.

1. Instala en tu celular una **app de autenticación**, por ejemplo Google Authenticator o Microsoft Authenticator.
2. En GitHub: **foto de perfil › Settings › Password and authentication**.
3. En la sección **Two-factor authentication**, haz clic en **Enable two-factor authentication**.
4. Con la app, **escanea el código QR** que aparece en pantalla.
5. Escribe en GitHub el **código de 6 dígitos** que muestra la app.
6. **Descarga los códigos de recuperación** (*Download*) y guárdalos en un lugar seguro, fuera del celular. Si pierdes el teléfono, son tu única forma de volver a entrar.
7. Confirma con **I have saved my recovery codes**.

> Si hoy no tienes tiempo, puedes dejarlo para después de la práctica, pero no lo olvides: es la medida de seguridad más importante de tu cuenta.

---

## Paso 4 · Confirmar que no hay costos (1 min)

1. **Foto de perfil › Settings › Billing and licensing**.
2. Comprueba que tu plan sea **GitHub Free**.
3. **No agregues ningún método de pago.** Sin tarjeta registrada, si algún día se agota la cuota gratuita de Codespaces, GitHub solo **bloquea** el uso hasta el mes siguiente; **no puede cobrarte**.

---

## Paso 5 · Ajustes para que tu cuota se cuide sola (2 min, opcional)

Estos ajustes hacen que GitHub apague y borre tus codespaces olvidados antes de lo normal. **No sustituyen** detener y eliminar tu codespace a mano al terminar la práctica: son una red de seguridad.

1. **Foto de perfil › Settings**.
2. En el menú de la izquierda, sección **Code, planning, and automation**, entra a **Codespaces**.
3. **Default idle timeout** (tiempo sin actividad antes de apagarse): cámbialo de 30 a **15 minutos**. Así, si cierras la pestaña sin detenerlo, se apaga antes.
4. **Default retention period** (días detenido antes de borrarse solo): cámbialo de 30 a **7 días**. Así, si olvidas eliminarlo, se borra antes. Elige un valor que te dé tiempo de descargar tus archivos; **no uses 0**, porque el codespace se borraría en cuanto se detuviera, junto con tus evidencias.
5. Guarda cada cambio con **Save**.

> Estos ajustes se aplican a los codespaces que crees **después** de cambiarlos. Hazlo antes de empezar la práctica.

---

## Lista de verificación final

- [ ] Puedo iniciar sesión en https://github.com
- [ ] Mi correo aparece como verificado en **Settings › Emails**.
- [ ] Activé **Keep my email addresses private**.
- [ ] Activé la verificación en dos pasos y guardé mis códigos de recuperación (recomendado).
- [ ] Mi plan es **GitHub Free** y **no** registré tarjeta.
- [ ] Opcional: ajusté el tiempo de inactividad a 15 minutos y la retención a 7 días.

Con esto ya puedes seguir con [`PRACTICA_CODESPACES.md`](PRACTICA_CODESPACES.md).

---

## Si algo falla

| Problema | Solución |
|---|---|
| No llega el correo de GitHub | Revisa **Spam** o **Promociones**. Espera 5 minutos y usa **Resend verification email**. |
| «Username is not available» | El nombre ya existe. Agrega un número o un guion: `ana-lopez-dev2`. |
| GitHub pide verificaciones adicionales al registrarte | Es normal cuando muchas personas se registran desde la misma red (por ejemplo, la de la escuela). Inténtalo desde los datos de tu celular o desde casa. |
| Olvidé mi contraseña | En la pantalla de inicio de sesión: **Forgot password?** Por eso es tan importante el correo verificado. |
| Perdí mi celular con la app de 2FA | Usa uno de tus **códigos de recuperación** para entrar y vuelve a configurar la app. |

---

### Fuentes

- Crear una cuenta en GitHub: https://docs.github.com/en/get-started/start-your-journey/creating-an-account-on-github
- Verificar tu correo: https://docs.github.com/en/account-and-profile/how-tos/email-preferences/verifying-your-email-address
- Configurar la verificación en dos pasos: https://docs.github.com/en/authentication/securing-your-account-with-two-factor-authentication-2fa/configuring-two-factor-authentication
- Facturación de Codespaces (cuota y bloqueo sin método de pago): https://docs.github.com/en/billing/concepts/product-billing/github-codespaces
