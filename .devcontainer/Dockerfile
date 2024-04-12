FROM php:5.6-apache

LABEL maintainer="Florin Buzec <florin.buzec@gmail.com>"

#ENV TZ="Europe/Bucharest"
# map to right env
#ENV COMPOSER_AUTH $COMPOSER_AUTH

ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

RUN sed -i 's/httpredir.debian.org/deb.debian.org/g' /etc/apt/sources.list
RUN rm -rf /var/lib/apt/lists/*

RUN echo "deb http://archive.debian.org/debian stretch main" > /etc/apt/sources.list

# update + install missing deps
RUN set -eux; \
    apt-get update && apt-get install -y \
        git \
        zip \
        unzip \
        curl \
        vim \
        nano \
        ncdu \
        iproute2 \
        procps \
        lsb-release \
        zlib1g-dev \
        libicu-dev \
        libxml2-dev \
        apt-utils \
        xz-utils \
        ssh \
        sudo \
        --no-install-recommends

RUN docker-php-ext-install mysqli pdo pdo_mysql \
    && docker-php-ext-enable pdo_mysql

# install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Clean up
RUN apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Create non-root user
RUN groupadd --gid $USER_GID $USERNAME && \
    useradd --uid $USER_UID --gid $USER_GID -c "VsCode user" -s /bin/bash -m $USERNAME

# add to root
RUN mkdir -p /etc/sudoers.d && \
    echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME && \
    chmod 0440 /etc/sudoers.d/$USERNAME

# Apache - link our site config
RUN rm -rf /etc/apache2/sites-enabled && \
    ln -s /var/www/html/.devcontainer/apache/sites-enabled /etc/apache2/sites-enabled && \
    a2enmod rewrite

# making global tools
RUN mkdir -p /opt/tools/php
RUN chown -R $USERNAME /opt/tools

USER ${USERNAME}

# global install PHP-CS
RUN mkdir -p /opt/tools/php/php-cs-fixer && \
    composer require --dev --working-dir=/opt/tools/php/php-cs-fixer friendsofphp/php-cs-fixer && \
    sudo ln -s /opt/tools/php/php-cs-fixer/vendor/bin/php-cs-fixer /usr/local/bin/

# global install PHPStan ponly works with 7.2|8.0
#RUN mkdir -p /opt/tools/php/phpstan && \
#    composer require --dev --working-dir=/opt/tools/php/phpstan phpstan/phpstan && \
#    sudo ln -s /opt/tools/php/phpstan/vendor/bin/phpstan /usr/local/bin/

# global install PHPUnit - already ./src/vendor/bin/phpunit exists
#RUN mkdir -p /opt/tools/php/phpunit

# Switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=dialog

EXPOSE 80

WORKDIR /var/www/html
