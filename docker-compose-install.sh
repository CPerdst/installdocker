VERSION=$1

if [ "$VERSION" == "" ]; then
        VERSION=2.20.2
fi

install_docker_compose() {
        # insatll
        curl -fSL https://github.com/docker/compose/releases/download/v$VERSION/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
        chmod +x /usr/local/bin/docker-compose

        # get hash
        curl -fsSL https://github.com/docker/compose/releases/download/v$VERSION/docker-compose-`uname -s | tr "L" "l"`-`uname -m`.sha256 -o /tmp/docker-compose-`uname -s | tr "L" "l"`-`uname -m`.sha256

        # compare hash
        remote_hash=$(cat /tmp/docker-compose-`uname -s | tr "L" "l"`-`uname -m`.sha256 | awk -F " " '{print $1}')
        # echo "remote_hash: $remote_hash"
        local_hash=$(sha256sum /usr/local/bin/docker-compose | awk -F " " '{print $1}')
        # echo "local_hash: $local_hash"

        if [ "$remote_hash" == "$local_hash" ]; then
                echo "installed success"
        else
                echo "installed failed"
        fi

        # remove hash
        rm -rf /tmp/docker-compose-`uname -s | tr "L" "l"`-`uname -m`.sha256
}

if docker-compose --version > /dev/null 2>&1; then
        echo "docker-compose is installed, Version: $(docker-compose --version | awk '{print $4}')"
else
        install_docker_compose
f