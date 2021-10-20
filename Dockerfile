FROM phusion/baseimage@sha256:43af498ce9fd215f107825323877635903a51083cd123b121e728662041ac161 AS xdebug-patch

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

FROM devwithlando/php@sha256:0ae90f095fcd18ace1723441fad32f9df80266ae1b6eb4739185beed549ee774
COPY --from=xdebug-patch /root/xdebug/modules/xdebug.so /usr/local/lib/php/extensions/no-debug-non-zts-20190902/xdebug.so

# Install blackfire.
RUN wget -q -O - https://packages.blackfire.io/gpg.key | apt-key add - \
    && echo "deb http://packages.blackfire.io/debian any main" | tee /etc/apt/sources.list.d/blackfire.list \
    && apt-get update \
    && apt install blackfire \
    && apt install blackfire-php \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       vim \
       nano \
    && rm -rf /var/lib/apt/lists/*
