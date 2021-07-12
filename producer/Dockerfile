FROM kodefoundry/alpine-kafka:1.0

COPY producer.cpp /usr/src/producer/
WORKDIR /usr/src/producer

RUN apk add --no-cache musl-dev zlib-dev openssl zstd-dev pkgconfig libc-dev gcc g++
RUN g++ producer.cpp -o kproducer `pkg-config --cflags --libs --static rdkafka++` && rm -f producer.cpp && apk del gcc g++
CMD ["/usr/src/producer/kproducer"] 
