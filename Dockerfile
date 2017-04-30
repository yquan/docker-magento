FROM php:7.0-fpm-alpine
MAINTAINER YQ <yquan@msn.com>

RUN apk upgrade --update && apk add \
    curl \
    sed \
    git \
    vim \
    nodejs \
    freetype-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    icu-dev \
    libmcrypt-dev \
    libxslt-dev \
    autoconf \
    make \
    g++ \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-configure hash --with-mhash \
    && docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) mcrypt intl xsl gd zip pdo_mysql opcache soap bcmath json iconv \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && pecl channel-update pecl.php.net \
    && pecl install xdebug redis \
    && docker-php-ext-enable xdebug redis \
    && echo "xdebug.remote_enable=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_port=9000" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_connect_back=0" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_host=127.0.0.1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.idekey=PHPSTORM" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.max_nesting_level=1000" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && rm -rf /var/cache/apk/* \
    && find / -type f -iname \*.apk-new -delete \
    && rm -rf /var/cache/apk/* \
    && rm -rf /tmp/*

# PHP config
ADD conf/php.ini /usr/local/etc/php

WORKDIR /
