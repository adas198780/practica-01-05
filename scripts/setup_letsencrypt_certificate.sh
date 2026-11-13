#!/bin/bash
set -ex

# Trabajamos siempre desde la carpeta donde está el script
cd "$(dirname "$0")"

# Importamos el archivo .env
source .env

# Instalamos snapd y actualizamos core
snap install core
snap refresh core

# Eliminamos cualquier instalación previa de certbot con apt
apt remove certbot -y

# Instalamos el cliente certbot con snap
snap install --classic certbot

# Creamos un alias para el comando certbot
ln -fs /snap/bin/certbot /usr/bin/certbot

# Obtenemos el certificado y configuramos Apache
certbot --apache \
  -m "$CERTBOT_EMAIL" \
  --agree-tos \
  --no-eff-email \
  -d "$CERTBOT_DOMAIN" \
  --non-interactive
