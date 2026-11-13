#!/bin/bash
set -ex

# Trabajamos siempre desde la carpeta donde está el script
cd "$(dirname "$0")"

# Actualizamos los repositorios e instalamos la pila LAMP
apt update
apt install -y apache2 php libapache2-mod-php php-mysql mysql-server

# Copiamos el archivo de configuración de Apache y la página de prueba
cp ../conf/000-default.conf /etc/apache2/sites-available/000-default.conf
cp ../php/index.php /var/www/html/index.php

# Reiniciamos Apache para aplicar los cambios
systemctl restart apache2
