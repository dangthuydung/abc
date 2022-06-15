#!/bin/bash
sudo apt -y update
sudo apt install -y nginx
sudo systemctl start nginx
nginx -v
sudo apt install mysql-server 
sudo mysql
sudo apt install php-fpm php-mysql 
sudo apt install php-cli unzip 
cd ~
curl -sS https://getcomposer.org/installer -o /tmp/composer-setup.php 
HASH=`curl -sS https://composer.github.io/installer.sig` 
echo $HASH 
php -r "if (hash_file('SHA384', '/tmp/composer-setup.php') === '$HASH') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" 
sudo php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer 
composer
sudo apt install php-mbstring php-xml php-bcmath
composer create-project --prefer-dist laravel/laravel danhsach
cd danhsach
php artisan 
aws s3 cp s3://my-tf-test-bucket112/env.txt /var/www/danhsach/.env
sudo mv ~/danhsach /var/www/danhsach
sudo chown -R www-data.www-data /var/www/danhsach/storage 
sudo chown -R www-data.www-data /var/www/danhsach/bootstrap/cache 
aws s3 cp s3://my-tf-test-bucket112/nginx.txt /etc/nginx/sites-enabled/danhsach
sudo ln -s /etc/nginx/sites-available/danhsach/etc/nginx/sites-enabled/ 
sudo nginx -t 
sudo systemctl reload nginx 
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt
sudo cp /etc/ssl/private/nginx-selfsigned.key /etc/nginx/snippets/self-signed.conf
sudo cp /etc/ssl/certs/nginx-selfsigned.crt /etc/nginx/snippets/self-signed.conf
aws s3 cp s3://my-tf-test-bucket112/ssl-params.txt /etc/nginx/snippets/ssl-params.conf
sudo ufw allow 'Nginx Full'
sudo ufw delete allow 'Nginx HTTP'
sudo systemctl restart nginx