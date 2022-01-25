FROM nvidia/cuda:11.0-devel as builder

RUN apt-get -y update && \
    apt-get -y install \
        automake \
        libssl-dev \
        libcurl4-openssl-dev

COPY . /tmp/ccminer

RUN cd /tmp/ccminer && \
    ./autogen.sh && \
    ./configure --with-cuda=/usr/local/cuda && \
    make

FROM nvidia/cuda:11.0-base

RUN apt-get -y update && \
    apt-get -y install \
        libcurl4 \
        libgomp1

COPY --from=builder /tmp/ccminer/ccminer /usr/local/bin/ccminer

ENTRYPOINT ["ccminer"]

CMD ["--help"]
