FROM littleof/php:latest


RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends openssl libssl-dev build-essential \
    libidn11-dev libidn11 libcurl4-openssl-dev libc-ares-dev; \
    pecl update-channels; \
    pecl install --configureoptions 'enable-openssl="yes" \
    enable-http2="yes" enable-swoole-json="yes" enable-swoole-curl="yes" \
    enable-cares="yes" with-openssl-dir="/usr"' swoole; \
    docker-php-ext-enable swoole; \
    docker-php-source delete; \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
    rm -rf /var/lib/apt/lists/* $HOME/.composer/*-old.phar /usr/bin/qemu-*-static; \
    rm -rf /tmp/pear ~/.pearrc; \
    rm -rf /tmp/*

ENV EXTRA_EXT \
    bcmath bz2 calendar exif ffi gd gettext intl \
    mysqli pcntl pdo_mysql pdo_pgsql shmop soap \
    sockets sysvmsg sysvsem sysvshm tidy zip
ENV EXTRA_LIBS \
    libbz2-dev \
    libffi-dev \
    zlib1g-dev \
    libpng-dev \
    libicu-dev \
    libpq-dev \
    libxml2-dev \
    libtidy-dev \
    libzip-dev

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends $EXTRA_LIBS; \
    docker-php-ext-install $EXTRA_EXT; \
    docker-php-source delete; \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
    rm -rf /var/lib/apt/lists/* $HOME/.composer/*-old.phar /usr/bin/qemu-*-static; \
    rm -rf /tmp/pear ~/.pearrc; \
    rm -rf /tmp/*

RUN set -eux; \
    php --version; \
    { \
    echo "[swoole]"; \
    echo "extension=swoole"; \
    echo "swoole.unixsock_buffer_size=128M"; \
    echo "swoole.use_shortname=Off"; \
    echo "swoole.enable_preemptive_scheduler=On"; \
    } | tee /usr/local/etc/php/conf.d/docker-php-ext-swoole.ini

CMD ["php", "-a"]
