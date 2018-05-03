FROM php:7.1-fpm

ARG DOCKER_USER="devops"
ARG DOCKER_USER_ID=1001
ARG GIT_USER_NAME="John Doe"
ARG GIT_USER_EMAIL="johndoe@example.com"


# Install packages
RUN apt-get update \
    && apt-get install -y \
        libicu-dev \
        zlib1g-dev \
        git \
        sudo \
        wget \
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


# Install & configure xdebug extention
RUN pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && echo 'xdebug.remote_enable=on' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo 'xdebug.remote_autostart=on' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo 'xdebug.remote_connect_back=off' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo 'xdebug.remote_handler=dbgp' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo 'xdebug.profiler_enable=0' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo 'xdebug.profiler_output_dir="/var/www/html"' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo 'xdebug.remote_port=9000' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo 'xdebug.extended_info = 1' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini


# Install PhpMetrics
RUN wget -O /phpmetrics.phar http://github.com/phpmetrics/PhpMetrics/raw/master/build/phpmetrics.phar
RUN chmod +x /phpmetrics.phar
RUN mv /phpmetrics.phar /usr/local/bin/phpmetrics


# Add local user & give sudo privilege
RUN useradd --shell /bin/bash -u ${DOCKER_USER_ID} -o -c "" -m ${DOCKER_USER} \
    && adduser ${DOCKER_USER} sudo \
    && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
    && export HOME=/home/${DOCKER_USER}


# Override default bash config
ADD .bashrc /home/${DOCKER_USER}/.bashrc
RUN chown ${DOCKER_USER}:${DOCKER_USER} /home/${DOCKER_USER}/.bashrc


# Install Php cs-fixer
RUN wget -O /php-cs-fixer-v2.phar http://cs.sensiolabs.org/download/php-cs-fixer-v2.phar
RUN chmod +x /php-cs-fixer-v2.phar
RUN mv /php-cs-fixer-v2.phar /usr/local/bin/php-cs-fixer


# Configure git
RUN su ${DOCKER_USER} -c "git config --global user.name ${GIT_USER_NAME}"
RUN su ${DOCKER_USER} -c "git config --global user.email ${GIT_USER_EMAIL}"
RUN su ${DOCKER_USER} -c "git config --global core.editor nano"


# Install TIG (cli git interface)
RUN apt-get install tig


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


# Add Provisionning Scripts
ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
