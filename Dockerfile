ARG CUDA=11.0
FROM nvidia/cuda:$CUDA-devel as builder

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

FROM nvidia/cuda:$CUDA-base

RUN apt-get -y update && \
    apt-get -y install \
        libcurl4 \
        libgomp1

COPY --from=builder /tmp/ccminer/ccminer /usr/local/bin/ccminer

ENTRYPOINT ["ccminer"]

CMD ["--help"]
