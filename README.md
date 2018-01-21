# Insight Docker
A docker build for insight

## Requirements
The following applications are required to run Insight:
* Docker 17.05 or higher

## Build
Build the container with the following command:

```
docker build -t btcz/insight .
```

## Usage
To simplying get the container up and running using the following command:

```
docker run -it --name insight \
  -p 3001:3001 \
  -p 1989:1989 \
  btcz/insight
```

NOTE: The BitcoinZ data lives in `/bitcoinz/data`. It is suggested to mount a shared volume so that
if the docker container is ever updated or deleted, the node data is still available. You can
mount a shared volume like so:


```
mkdir -p /opt/storage/bitcoinz/data/
chmod a+x /opt/storage/bitcoinz/data/
cp bitcoinz.conf /opt/storage/bitcoinz/data/zcash.conf
docker run -it --name insight \
  -p 3001:3001 \
  -p 1989:1989 \
  -v /opt/storage/bitcoinz/data/:/bitcoinz/data \
  btcz/insight
```
