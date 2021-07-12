FROM alpine:3.14.0 as librdkafka_base

ENV LIBRD_VER=1.7.0
WORKDIR /tmp
RUN apk add --no-cache --virtual .make-deps bash make wget git gcc g++ \
&& apk add --no-cache musl-dev zlib-dev openssl zstd-dev pkgconfig libc-dev \
&& wget https://github.com/edenhill/librdkafka/archive/v${LIBRD_VER}.tar.gz \
&& tar -xvf v${LIBRD_VER}.tar.gz \
&& cd librdkafka-${LIBRD_VER} \
&& ./configure --prefix /usr \
&& make && make install && make clean && rm -rf librdkafka-${LIBRD_VER} \
&& rm -rf v${LIBRD_VER}.tar.gz \
&& apk del .make-deps && rm -rf /tmp/
RUN export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/lib/pkgconfig/

FROM librdkafka_base as k_compiler
COPY producer/producer.cpp /usr/src/producer/
RUN apk add --no-cache gcc g++ \
&& cd /usr/src/producer && g++ producer.cpp -o kproducer `pkg-config --cflags --libs --static rdkafka++`

FROM librdkafka_base
RUN apk add --no-cache libstdc++
COPY --from=k_compiler /usr/src/producer/kproducer /usr/bin/
CMD ["kproducer","localhost","my_topic"]



