FROM php:7.1-fpm

ARG DOCKER_USER=devops

# Install packages
RUN apt-get update \
    && apt-get install -y \
        libicu-dev \
        zlib1g-dev \
        git \
        sudo \
        wget \
        htop \
        ncdu \
        nano \
    && docker-php-ext-install \
        zip \
        intl \
        json \
        mbstring \
        mysqli \
        pdo_mysql \
    && php -r "readfile('https://getcomposer.org/installer');" | php -- --install-dir=/usr/local/bin --filename=composer \
    && chmod +x /usr/local/bin/composer


# Add user DOCKER_USER defined in .env & give sudo privilege
RUN adduser --disabled-password --gecos '' ${DOCKER_USER}
RUN adduser ${DOCKER_USER} sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers


# Override default bash config
ADD .bashrc /home/${DOCKER_USER}/.bashrc


# Install PhpMetrics
RUN wget -O /phpmetrics.phar http://github.com/phpmetrics/PhpMetrics/raw/master/build/phpmetrics.phar
RUN chmod +x /phpmetrics.phar
RUN mv /phpmetrics.phar /usr/local/bin/phpmetrics


# Install PhpDocumentor
RUN wget -O /phpDocumentor.phar https://github.com/phpDocumentor/phpDocumentor2/releases/download/v2.9.0/phpDocumentor.phar
RUN chmod +x /phpDocumentor.phar
RUN mv /phpDocumentor.phar /usr/local/bin/phpDocumentor


# Add opcache
RUN docker-php-ext-install opcache


# Add APCu
RUN pecl install apcu \
	&& echo "extension=apcu.so\napc.enable_cli = 1" > /usr/local/etc/php/conf.d/ext-apcu.ini


# Install NodeJs
RUN curl -o /tmp/setup_node.sh https://deb.nodesource.com/setup_6.x
RUN chmod +x /tmp/setup_node.sh
RUN /tmp/setup_node.sh
RUN apt-get update \
    && apt-get install -y \
    nodejs \
    build-essential


# Install Yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update \
    && apt-get install -y \
    yarn


# Add Provisionning Scripts
ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
