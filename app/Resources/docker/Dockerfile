FROM php:7.1-fpm

ARG DOCKER_USER

RUN apt-get update \
    && apt-get install -y \
        libicu-dev \
        zlib1g-dev \
        git \
        nodejs \
        npm \
        sudo \
        wget \
        htop \
        ncdu \
        tig \
    && docker-php-ext-install \
        zip \
        intl \
        json \
        mbstring \
        mysqli \
        pdo_mysql \
    && php -r "readfile('https://getcomposer.org/installer');" | php -- --install-dir=/usr/local/bin --filename=composer \
    && chmod +x /usr/local/bin/composer

# Install PhpMetrics
RUN wget -O /phpmetrics.phar http://github.com/phpmetrics/PhpMetrics/raw/master/build/phpmetrics.phar
RUN chmod +x /phpmetrics.phar
RUN mv /phpmetrics.phar /usr/local/bin/phpmetrics

# Add opcache
RUN docker-php-ext-install opcache

# Add APCu
RUN pecl install apcu \
	&& echo "extension=apcu.so\napc.enable_cli = 1" > /usr/local/etc/php/conf.d/ext-apcu.ini

# Install NodeJs
RUN ln -s /usr/bin/nodejs /usr/bin/node

# Install BlackFire Probe for profiling App
RUN version=$(php -r "echo PHP_MAJOR_VERSION.PHP_MINOR_VERSION;") \
    && curl -A "Docker" -o /tmp/blackfire-probe.tar.gz -D - -L -s https://blackfire.io/api/v1/releases/probe/php/linux/amd64/$version \
    && tar zxpf /tmp/blackfire-probe.tar.gz -C /tmp \
    && mv /tmp/blackfire-*.so $(php -r "echo ini_get('extension_dir');")/blackfire.so \
    && printf "extension=blackfire.so\nblackfire.agent_socket=tcp://blackfire:8707\n" > $PHP_INI_DIR/conf.d/blackfire.ini

# Add user DOCKER_USER defined in .env & give sudo privilege
RUN adduser --disabled-password --gecos '' ${DOCKER_USER}
RUN adduser ${DOCKER_USER} sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Override default bash config
ADD .bashrc /home/${DOCKER_USER}/.bashrc

# Add Provisionning Scripts
ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
