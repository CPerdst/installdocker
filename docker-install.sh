VERSION=$(cat /etc/os-release | grep CENTOS_MANTISBT_PROJECT_VERSION | awk -F '"' '{print $2}')
USER=$(whoami)

install_yum_config_manager() {
        yum install yum-units
}

install_docker() {
        yum_config_manager=0

        if command -v yum-config-manager > /dev/null 2>&1; then
                yum_config_manager=1
        fi

        if [ "$yum_config_manager" == "1" ]; then
                echo "install yum-units"
                install_yum_config_manager
        fi

        # add docker repo
        yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

        # modify /etc/yum.repo.d/docker-ce.repo
        sed -i "s/\$releasever/$VERSION/" /etc/yum.repos.d/docker-ce.repo

        # install
        yum install -y docker-ce docker-ce-cli containerd.io

        # set daemon
        systemctl enable docker

        # start docker
        systemctl start docker
}


if docker --version > /dev/null 2>&1; then
        version=$(docker --version | awk '{gsub(/,/, "", $3); print $3}')
        echo "Docker is installed, Version: $version"
else
        if [ "$(whoami)" != "root" ]; then
                echo "You don't have permission to download everything"
                exit
        fi
        install_docker
fi