FROM phusion/baseimage:master AS xdebug-patch

RUN apt-add-repository -y ppa:ondrej/php \
    && install_clean \
        pkg-config \
        php7.4-dev \
        git \
        make \
        vim \
        nano \
        pngquant \
        jpegoptim

WORKDIR /root
RUN git clone -b xdebug_2_9 https://github.com/dermario/xdebug.git
WORKDIR /root/xdebug
RUN phpize && ./configure && make

FROM devwithlando/php:7.4-fpm-2
COPY --from=xdebug-patch /root/xdebug/modules/xdebug.so /usr/local/lib/php/extensions/no-debug-non-zts-20190902/xdebug.so
