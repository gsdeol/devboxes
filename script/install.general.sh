#!/usr/bin/env -eux

function install_general() {
    echo "====================="
    echo "Install              "
    echo "git tree htop        "
    echo "====================="

    sudo apt dist-upgrade -y
    sudo apt update
    sudo apt install git -y
    cp /vagrant/templates/.gitconfig ~/.gitconfig
    sudo apt install tree -y
    sudo apt install htop -y
    sudo apt install nano -y
    sudo apt install vim -y
    sudo apt install build-essential -y
}

function install_api_toolchain() {
    echo "================"
    echo "Install Postman"
    echo "================"
    wget https://dl.pstmn.io/download/latest/linux64 -O postman.tar.gz
    sudo tar -xzf postman.tar.gz -C /opt
    rm postman.tar.gz
    sudo ln -s /opt/Postman/Postman /usr/bin/postman
    mkdir ~/.local/share/applications
    cat > ~/.local/share/applications/postman.desktop <<EOL
[Desktop Entry]
Encoding=UTF-8
Name=Postman
Exec=postman
Icon=/opt/Postman/resources/app/assets/icon.png
Terminal=false
Type=Application
Categories=Development;
EOL
   chmod ~/.local/share/applications/postman.desktop +x

    echo "================"
    echo "Install Newman"
    echo "================"
    npm install -g newman
}

function install_nvm_node() {
    echo "================"
    echo "Install NVM"
    echo "================"
    sudo apt-get install build-essential libssl-dev -y
    curl -sL https://raw.githubusercontent.com/creationix/nvm/master/install.sh -o ~/install_nvm.sh
    chmod +x ~/install_nvm.sh
    ~/install_nvm.sh
    source ~/.profile
    ls -a | grep .nvm
    source ~/.nvm/nvm.sh
    echo "source ~/.nvm/nvm.sh" >> ~/.profile
    echo "source ~/.nvm/nvm.sh" >> ~/.zshrc
    nvm install 6.12.2
    nvm install 9.3.0
    nvm alias default 9.3.0
    nvm use default
    node -v

    npm install -g grunt-cli
    # Install Grunt globally
    npm list -g --depth=0
    sudo apt-get clean
}

function info() {
    echo "=================="
    echo "Current Version of Linux Mint"
    echo "=================="
    cat /etc/linuxmint/info

    tree --version

    git --version
    nvm --version

    node -v
    java -version
    scala -version
    kotlin -version
    go version

    pip -V
    mvn --version
    gradle --version

    newman -v

    htop -v
    ansible --version
    puppet --version
    chef-shell --version

    docker -v
    docker-compose -v
}

function install_pip() {
    echo "=================="
    echo "Install Python pip"
    echo "=================="
    sudo apt install python-pip python-setuptools -y
    sudo pip install --upgrade pip
    sudo pip install -r requirements.txt
}

function install_sdk_man() {
    echo "=================="
    echo "Install SDK MAN"
    echo "=================="
    curl -s "https://get.sdkman.io" | bash
    source "$HOME/.sdkman/bin/sdkman-init.sh"
    sdk version

    sdk install ant
    sdk install gradle
    sdk install java
    sdk install kotlin
    sdk install maven
    sdk install sbt
    sdk install scala
}

function install_go() {
    sudo apt install golang-go -y
}

function install_docker() {

    echo "=================="
    echo "Install docker && docker-compose"
    echo "=================="

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
echo 'deb [arch=amd64] https://download.docker.com/linux/ubuntu zesty stable' | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo -k
sudo sh <<SCRIPT
    apt-get update
    apt-get install \
        apt-transport-https \
        ca-certificates \
        curl \
        software-properties-common -y

    apt-get install docker-ce -y
    usermod -aG docker $(whoami)

    echo 'Install Docker-Compose'
    systemctl stop docker
    curl -L https://github.com/docker/compose/releases/download/1.18.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose

    chmod +x  /usr/local/bin/docker-compose

    systemctl start docker
SCRIPT
}

function install_management_tools() {
# puppet
# chef
    curl -L https://omnitruck.chef.io/install.sh | sudo bash
    echo "=================="
    echo "Install Ansible"
    echo "=================="
sudo sh <<ANSIBLE
    apt-get install software-properties-common -y

    # add ansible PPA
    apt-add-repository ppa:ansible/ansible -y
    # refresh packages, to make sure ansible package is available
    apt-get update
    apt-get install ansible -y
    echo 'Ansible installed and hosts provisioned'
ANSIBLE
}

function install_brew() {
    echo "================"
    echo "Install Brew"
    echo "================"
    sudo apt install linuxbrew-wrapper -y
    yes "" | brew doctor
    brew update
    sudo sh -c "echo 'export PATH=/home/vagrant/.linuxbrew/bin:$PATH' >> ~/.bash_profile"
}

function install_tor() {
    sudo add-apt-repository ppa:webupd8team/tor-browser -y
    sudo apt-get update
    sudo apt-get install tor-browser -y
}

function clean() {
    sudo apt-get purge $(dpkg -l linux-{image,headers}-"[0-9]*" | awk '/ii/{print $2}' | grep -ve "$(uname -r | sed -r 's/-[a-z]+//')")
    sudo apt-get autoclean && sudo apt-get autoremove -y && sudo apt-get clean
}

function pass_asterix() {
    sed -i env_reset env_reset,pwfeedback
}

function main() {
    echo "Main function"
    install_general
    install_pip

    install_nvm_node
    install_api_toolchain
    install_sdk_man
    install_go
    install_docker
    install_management_tools

    clean
    info
}

main
# some git aliases
