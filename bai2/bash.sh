
#!/bin/bash
sudo apt -y update
sudo apt install -y nginx
sudo systemctl start nginx
sudo systemctl enable nginx
sudo apt install php-fpm php-mysql
sudo apt install php-cli unzip
sudo apt install -y php-fpm php-mysql
sudo apt install -y php-cli unzip
cd ~ 
curl -sS https://getcomposer.org/installer -o /tmp/composer-setup.php 
echo $HASH
php -r "if (hash_file('SHA384', '/tmp/composer-setup.php') === '$HASH') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
sudo php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer 
compposer
sudo apt install php-mbstring php-xml php-bcmath
composer create-project --prefer-dist laravel/laravel danhsach
cd travellist 
php artisan 
sudo chown -R www-data.www-data /var/www/danhsach/storage
sudo chown -R www-data.www-data /var/www/danhsach/bootstrap/cache 
sudo rm -rf /etc/nginx/sites-enabled/*
aws s3 cp s3:///bucket-demo1126/nginx.txt /etc/nginx/sites-enabled/danhsach.conf
aws s3 cp s3:///bucket-demo1126/env.txt /var/www/danhsach/.env
cd /var/www/danhsach 
export DB_HOST=${aws_db_instance. demo_mysql_db.address}
export DB_DATABASE=${aws_db_instance. demo_mysql_db.name}
export DB_USERNAME=${aws_db_instance. demo_mysql_db.username}
export DB_PASSWORD =${aws_db_instance. demo_mysql_db.password}
sudo php artisan config:cache 
sudo systemctl reload nginx 