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
* bitcoinz-insight-patched docker container

## Build
Build the container with the following command:

```
docker build -t btcz/bitcoinz-rest-api .
```

## Usage
To simplying get the container up and running using the following command:

```
docker run -it --name bitcoinz-insight-patched \
  -p 1989:1989 \
  btcz/bitcoinz-insight-patched

docker run -it --name bitcoinz-rest-api \
  -p 3001:3001 \
  btcz/bitcoinz-rest-api
```

## Docker Compose
To simplify operation of the insight service, you can use [docker
compose](https://docs.docker.com/compose/install/). After installation, you can
use docker-compose by running the `./bin/docker.sh` script.
