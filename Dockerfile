FROM phusion/baseimage@sha256:43af498ce9fd215f107825323877635903a51083cd123b121e728662041ac161 AS xdebug-patch

RUN apt-add-repository -y ppa:ondrej/php \
    && install_clean \
        pkg-config \
        php7.4-dev \
        git \
        make

WORKDIR /root
RUN git clone -b xdebug_2_9 https://github.com/dermario/xdebug.git
WORKDIR /root/xdebug
RUN phpize && ./configure && make

FROM devwithlando/php:7.4-fpm-4
COPY --from=xdebug-patch /root/xdebug/modules/xdebug.so /usr/local/lib/php/extensions/no-debug-non-zts-20190902/xdebug.so

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       vim \
       nano \
    && rm -rf /var/lib/apt/lists/*
