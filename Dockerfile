FROM pataquets/ubuntu:focal AS builder

RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive \
    apt-get -y install \
      autoconf \
      build-essential \
      cmake \
      libgetdns-dev \
      libssl-dev \
      libyaml-dev \
  && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/

COPY . /usr/src/stubby/
WORKDIR /usr/src/stubby/

RUN cmake .
RUN make

FROM pataquets/ubuntu:focal

RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive \
    apt-get -y install \
      libgetdns10 \
      libyaml-0-2 \
      openssl \
  && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/

COPY --from=builder /usr/src/stubby /usr/local/bin

ENTRYPOINT [ "stubby" ]
