# Práctica: HTTPS con Let's Encrypt y Certbot

Despliegue de la pila LAMP en una instancia EC2 de AWS (Ubuntu Server) y configuración de un certificado SSL/TLS de Let's Encrypt con Certbot en Apache.

> **TODO antes de entregar:** sustituye `CAMBIA_ESTO` por tus datos reales, rellena los huecos marcados con `TODO` y comprueba que todas las imágenes existen en `images/`.

## 1. Estructura del repositorio

```
.
├── README.md
├── conf
│   └── 000-default.conf
├── php
│   └── index.php
└── scripts
    ├── .env
    ├── install_lamp.sh
    └── setup_letsencrypt_certificate.sh
```

## 2. Conceptos básicos

- **HTTPS**: versión segura de HTTP; cifra la comunicación entre el navegador y el servidor.
- **Let's Encrypt**: autoridad de certificación gratuita que emite certificados X.509 de forma automática.
- **Certbot**: cliente ACME que demuestra a Let's Encrypt que controlamos el dominio, obtiene el certificado, configura Apache y programa la renovación automática.
- A diferencia de un certificado autofirmado, el navegador **confía** en este certificado y no muestra ninguna advertencia.

## 3. Instancia EC2 y red

TODO: describe cómo creaste la instancia (AMI Ubuntu Server, tipo, par de claves `vockey`), el grupo de seguridad con los puertos **22 (SSH), 80 (HTTP) y 443 (HTTPS)** y la IP elástica asignada.

![Grupo de seguridad](images/01-security-group.png)

IP elástica: `TODO`

## 4. Dominio y DNS

TODO: indica el proveedor de dominio gratuito que has usado (por ejemplo, DuckDNS) y el dominio: `TODO`.

Se configura el registro DNS para que el dominio resuelva hacia la IP elástica de la instancia.

![Configuración DNS](images/02-dns.png)

Comprobación con `nslookup`:

![nslookup](images/03-nslookup.png)

## 5. Scripts

### `scripts/.env`
Variables de configuración que usan los scripts:

| Variable | Descripción |
|---|---|
| `CERTBOT_EMAIL` | Correo para avisos de renovación |
| `CERTBOT_DOMAIN` | Dominio para el que se emite el certificado |

### `scripts/install_lamp.sh`
Instala Apache, PHP y MySQL, copia la configuración de Apache y una página de prueba (`phpinfo`) y reinicia Apache.

### `scripts/setup_letsencrypt_certificate.sh`
1. Instala `snapd` y actualiza `core`.
2. Elimina cualquier instalación previa de `certbot` con `apt`.
3. Instala Certbot con `snap` y crea un alias en `/usr/bin/certbot`.
4. Ejecuta `certbot --apache` con estos parámetros:
   - `-m`: correo electrónico.
   - `--agree-tos`: acepta los términos de uso.
   - `--no-eff-email`: no compartir el correo con la EFF.
   - `-d`: dominio del certificado.
   - `--non-interactive`: no pide datos por teclado, lo que permite automatizarlo.

## 6. Ejecución

En la instancia:

```bash
git clone https://github.com/TODO_USUARIO/TODO_REPO.git
cd TODO_REPO/scripts
sudo bash install_lamp.sh
sudo bash setup_letsencrypt_certificate.sh
```

Salida de `install_lamp.sh`:

![install_lamp](images/04-install-lamp.png)

Salida de `setup_letsencrypt_certificate.sh`:

![setup_letsencrypt](images/05-certbot-ok.png)

## 7. Cambios que realiza Certbot en Apache

Certbot modifica `000-default.conf` para redirigir de HTTP a HTTPS y crea `000-default-le-ssl.conf` con el VirtualHost del puerto 443 y las rutas al certificado en `/etc/letsencrypt/live/`.

![000-default.conf](images/06-conf-http.png)

![000-default-le-ssl.conf](images/07-conf-ssl.png)

## 8. Comprobación

Acceso por HTTPS sin advertencias (candado) y detalles del certificado emitido por Let's Encrypt:

![Candado](images/08-browser-https.png)

![Detalles del certificado](images/09-certificate.png)

Información del certificado y fecha de caducidad:

```bash
sudo certbot certificates
```

![certbot certificates](images/10-certbot-certificates.png)

## 9. Renovación automática

El temporizador del sistema renueva los certificados automáticamente:

```bash
systemctl list-timers | grep certbot
sudo certbot renew --dry-run
```

![Temporizador](images/11-renewal.png)
