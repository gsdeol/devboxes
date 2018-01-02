#!/usr/bin/env bash

set -xv

install_general() {
    echo "====================="
    echo "Install              "
    echo "git tree htop        "
    echo "====================="
    sudo apt dist-upgrade -y
    sudo apt update
    sudo apt install git tree htop nano newman -y
    sudo apt install build-essential -y
}

install_api_toolchain() {
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

install_nvm_node() {
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

install_brew() {
    echo "================"
    echo "Install Brew"
    echo "================"
    sudo apt install linuxbrew-wrapper -y
    yes "" | brew doctor
    brew update
    sudo sh -c "echo 'export PATH=/home/vagrant/.linuxbrew/bin:$PATH' >> ~/.bash_profile"

}

install_pip() {
    echo "=================="
    echo "Install Python pip"
    echo "=================="
    sudo apt install python-pip python-setuptools -y
    sudo pip install --upgrade pip
    sudo pip install -r requirements.txt
}

install_sdk_man() {
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

install_zsh() {
    echo "=================="
    echo "Install ZSH"
    echo "=================="
    sudo apt install zsh -y
    zsh --version
    sudo chsh -s $(which zsh)
    sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    sudo cp /vagrant/templates/.zshrc ~/.zshrc
    sudo cp /vagrant/templates/passwd /etc/passwd
    #How to run it?
    # chsh -s $(which zsh)
}

install_docker() {
    # NOT YET WROKING!!!
    echo "=================="
    echo "Install docker && docker-compose"
    echo "=================="

    sudo apt-get update
    sudo apt-get remove docker docker-engine docker.io
        sudo apt-get install \
        apt-transport-https \
        ca-certificates \
        curl \
        software-properties-common -y
    wget -qO- https://get.docker.com/ | sh
    sudo usermod -aG docker $(whoami)
   # source ~/.profile
  #  sudo systemctl enable docker
    echo 'Install Docker-Compose'
  #  sudo systemctl stop docker
    sudo curl -L https://github.com/docker/compose/releases/download/1.18.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
#sudo curl --silent -L https://github.com/docker/compose/releases/download/1.13.0/docker-compose-`uname -s`-`uname -m` > ~/docker-compose
    chmod +x  /usr/local/bin/docker-compose
#sudo mv ~/docker-compose /usr/local/bin/docker-compose
    docker-compose -v
    sudo systemctl start docker
    echo 'Docker Installation completed'
    sudo apt-get clean
}

install_management_tools() {
    echo "=================="
    echo "Install Puppet"
    echo "=================="
# puppet
# chef
    echo "=================="
    echo "Install Ansible"
    echo "=================="
    sudo apt-get install software-properties-common -y

    # add ansible PPA
    sudo apt-add-repository ppa:ansible/ansible -y
    # refresh packages, to make sure ansible package is available
    sudo apt-get update
    sudo apt-get install ansible -y

    echo 'Ansible installed and hosts provisioned'
    sudo apt-get clean
}

main() {
    echo "Main function"
    # install_general
    # install_pip
    # install_zsh
    # install_nvm_node
    # install_api_toolchain
    # install_sdk_man
    install_docker
#    install_management_tools
}

main
