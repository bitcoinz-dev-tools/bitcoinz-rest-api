#!/usr/bin/env sh

# This script serves as a quick get-up-and-go script for those who aren't
# familiar with docker. All it really does is provide some aliases for
# docker-compose.

function _compose {
    /usr/bin/env docker-compose "$@"
}

function _docker {
    /usr/bin/env docker "$@"
}

binDir="$(cd $(dirname "$0") && pwd)"

case ${1} in
    st|status)
        containersUp=$(_compose ps)
        containerCount="$(echo "${containersUp}" | grep 'Up' | wc -l)"
        echo "Insight containers running: ${containerCount}"
        echo "${containersUp}"
        ;;

    start)
        _compose up -d --force-recreate && \
            _compose logs -f --tail=1
        ;;

    stop)
        _compose stop --time 30
        ;;

    build)
        _compose stop && \
            _compose rm -f && \
            _docker rmi $(echo "$(basename $PWD)_insight" | sed "s/[^a-zA-Z0-9_]//g"); \
            _compose build --no-cache
        ;;

    logs)
        _compose logs -f --tail=1
        ;;

    bash)
        _docker exec -it --detach-keys 'ctrl-q,q' $(echo "$(basename $PWD)_insight_1" | sed "s/[^a-zA-Z0-9_]//g") bash
        ;;

    rm)
        _compose stop --time 30 && \
            _compose rm -f && \
            _docker rmi $(echo "$(basename $PWD)_insight" | sed "s/[^a-zA-Z0-9_]//g")
        ;;

    *)
        echo "Welcome to the BitcoinZ Insight docker container!"
        echo "------------------------------------------------"
        echo "Available commands are:"
        echo ""
        echo "./bin/docker.sh start -- Build and/or start the service"
        echo "./bin/docker.sh stop -- Stop the service"
        echo "./bin/docker.sh status -- Query which containers are running"
        echo "./bin/docker.sh build -- Build or rebuild the service"
        echo "./bin/docker.sh logs -- Watch the log file"
        echo "./bin/docker.sh bash -- Enter into a bash prompt inside the container"
        echo "./bin/docker.sh bash -- Kill the service and delete the container's image"
        ;;
esac
