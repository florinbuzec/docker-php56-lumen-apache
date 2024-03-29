FROM php:5.6-apache

LABEL maintainer="Florin Buzec <florin.buzec@gmail.com>"

RUN sed -i 's/httpredir.debian.org/deb.debian.org/g' /etc/apt/sources.list
RUN rm -rf /var/lib/apt/lists/*

RUN echo "deb http://archive.debian.org/debian stretch main" > /etc/apt/sources.list

RUN set -eux; \
    apt-get -y update \
    && apt-get install -y \
       git \
       zip \
       unzip \
       zlib1g-dev \
       curl \
       vim \
       libicu-dev \
       libxml2-dev \
       --no-install-recommends

RUN docker-php-ext-install pdo_mysql zip

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

#RUN composer create-project laravel/lumen . "5.1.*"

RUN sed -i 's/Listen 80/Listen 8083/g' /etc/apache2/ports.conf /etc/apache2/sites-available/000-default.conf
RUN sed -i -e 's|DocumentRoot /var/www/html|DocumentRoot /var/www/html/public|g' \
    -e 's|<VirtualHost \*:80>|<VirtualHost \*:8083>|g' /etc/apache2/sites-available/000-default.conf

RUN cat <<EOF > /var/www/html/info.php
<?php phpinfo();
EOF

EXPOSE 8083

WORKDIR /var/www/html

#service apache2 start
#CMD ["apache2-foreground"]
CMD ["/bin/bash"]
