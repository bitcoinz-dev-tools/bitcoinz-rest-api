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
Run the container using the following command:

```
docker run -d --name insight \
  -p 3001:3001 \
  -p 1989:1989 \
  -v /opt/storage/bitcoinz/data/:/bitcoinz/data \
  btcz/insight
```
