# BitcoinZ REST APIs 
Docker build scripts for the BitcoinZ Restful API.

## About
The BitcoinZ REST APIs are a set of APIs based on the insight explorer.
For more information about the APIs routes available, you can checkout
the documentation on the API project here: 
https://github.com/bitcoinz-dev-tools/insight-api-btcz 

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
sudo mkdir -p /opt/storage/bitcoinz/data/
sudo chmod a+rwx /opt/storage/bitcoinz/data/
cp bitcoinz.conf /opt/storage/bitcoinz/data/zcash.conf
docker run -it --name insight \
  -p 3001:3001 \
  -p 1989:1989 \
  -v /opt/storage/bitcoinz/data/:/bitcoinz/data \
  btcz/insight
```

## Docker Compose
To simplify operation of the insight service, you can use [docker
compose](https://docs.docker.com/compose/install/). After installation, you can
use docker-compose by running the `./bin/docker.sh` script.
