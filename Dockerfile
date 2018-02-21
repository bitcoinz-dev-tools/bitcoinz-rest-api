FROM debian:stretch-slim as build

# Install our build dependencies
RUN apt-get update \
  && apt-get install -y \
    curl \
    build-essential \
  	pkg-config \
  	libc6-dev \
  	m4 \
  	g++-multilib \
    autoconf \
  	libtool \
  	ncurses-dev \
  	unzip \
  	git \
  	python \
    zlib1g-dev \
  	wget \
  	bsdmainutils \
  	automake \
  	p7zip-full \
  	pwgen \
  && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/bitcoinz-dev-tools/bitcoinz-insight-patched.git /usr/local/src/

WORKDIR /usr/local/src/
RUN ./zcutil/build.sh -j$(nproc)
RUN ./zcutil/fetch-params.sh

# Now, let's build the insight application
FROM debian:stretch-slim

RUN mkdir -p /usr/src/app/
WORKDIR /usr/src/app/

# Setup application directory
RUN mkdir -p /bitcoinz/data

# Add our user and group first to ensure consistency
RUN groupadd -r bitcoinz && useradd -r -d /bitcoinz -g bitcoinz bitcoinz

RUN apt-get update \
  && apt-get install -y \
    autoconf \
    automake \
    bsdmainutils \
    build-essential \
    coreutils \
    curl \
    libc6-dev \
    libtool \
    libzmq3-dev \
    m4 \
    ncurses-dev \
    g++-multilib \
    gnupg2 \
    git \
    pkg-config \
    unzip \
    wget \
    zlib1g-dev \
  && rm -rf /var/lib/apt/lists/*

RUN curl -sL https://deb.nodesource.com/setup_4.x > setup_4.x \
  && chmod +x setup_4.x \
  && ./setup_4.x \
  && apt install -y nodejs \
  && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/bitcoinz-dev-tools/bitcore-node-btcz.git
RUN cd bitcore-node-btcz; npm install
RUN ./bitcore-node-btcz/bin/bitcore-node create -d /bitcoinz/data btcz-explorer
WORKDIR /usr/src/app/btcz-explorer
RUN ../bitcore-node-btcz/bin/bitcore-node install bitcoinz-dev-tools/insight-api-btcz bitcoinz-dev-tools/insight-ui-btcz

# Copy binaries from build container
COPY --from=build /usr/local/src/src/zcashd /usr/src/app/bitcore-node-btcz/bin
COPY --from=build /usr/local/src/src/zcash-cli /usr/src/app/bitcore-node-btcz/bin
COPY --from=build /usr/local/src/src/zcash-gtest /usr/src/app/bitcore-node-btcz/bin
COPY --from=build /usr/local/src/src/zcash-tx /usr/src/app/bitcore-node-btcz/bin

# Copy zcash params and defaults
COPY --from=build /root/.zcash-params /bitcoinz/.zcash-params
COPY bitcoinz.conf /bitcoinz/data/zcash.conf
COPY bitcore-node.json .

RUN chown -R bitcoinz: /bitcoinz
USER bitcoinz
CMD ["../bitcore-node-btcz/bin/bitcore-node", "start"]
