#!/bin/bash -eux

set -e

install_general() {
    echo "====================="
    echo "Install              "
    echo "git tree htop        "
    echo "====================="
    sudo apt dist-upgrade -y
    sudo apt update
    sudo apt install git tree htop -y
    sudo apt install build-essential -y
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
    sudo apt install zsh
    zsh --version
    sudo chsh -s $(which zsh)
    sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    sudo cp /vagrant/templates/.zshrc ~/.zshrc
}

main() {
    echo "Main function"
    install_general

    install_pip
    install_zsh
    install_sdk_man
}

main
