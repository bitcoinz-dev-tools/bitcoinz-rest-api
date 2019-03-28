FROM node:8

RUN mkdir -p /usr/src/app/
WORKDIR /usr/src/app/

# Setup application directory
RUN mkdir -p /bitcoinz/data

# Add our user and group first to ensure consistency
RUN groupadd -r bitcoinz && useradd -r -d /bitcoinz -g bitcoinz bitcoinz

RUN apt-get update \
  && apt-get install -y \
    build-essential \
    libzmq3-dev \
    zlib1g-dev \
  && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/bitcoinz-dev-tools/bitcore-node-btcz.git
RUN cd bitcore-node-btcz; npm install
RUN ./bitcore-node-btcz/bin/bitcore-node create -d /bitcoinz/data btcz-explorer
WORKDIR /usr/src/app/btcz-explorer
RUN ../bitcore-node-btcz/bin/bitcore-node install bitcoinz-dev-tools/insight-api-btcz bitcoinz-dev-tools/insight-ui-btcz

COPY bitcoinz.conf /bitcoinz/data/zcash.conf
COPY bitcore-node.json .

RUN chown -R bitcoinz: /bitcoinz
USER bitcoinz
CMD ["../bitcore-node-btcz/bin/bitcore-node", "start"]
