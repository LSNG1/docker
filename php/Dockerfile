FROM php:8.3-fpm

RUN apt-get update && apt-get install -y \
	curl git libonig-dev libpng-dev libxml2-dev nodejs npm unzip zip \
	&& docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd \
	&& curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
	&& apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /var/www

COPY ./laravel-app .

RUN chown -R www-data:www-data /var/www \
	&& chmod -R 755 /var/www/storage \
	&& chmod -R 755 /var/www/bootstrap/cache

COPY php/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
