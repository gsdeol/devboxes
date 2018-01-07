#!/usr/bin/env bash

set -xv

function install_keepasxc() {
    echo "================="
    echo "Install keepassxc"
    echo "================="
    sudo add-apt-repository ppa:phoerious/keepassxc -y
    sudo apt-get update
    sudo apt-get install keepassxc -y
}

function slick_dock() {
    echo "=================="
    echo "Install Slick Dock"
    echo "=================="
    sudo add-apt-repository ppa:ricotz/docky -y
    sudo apt-get update && sudo apt-get install plank -y
}

function install_zsh() {
    echo "=================="
    echo "Install ZSH"
    echo "=================="
    sudo apt install zsh -y
    zsh --version
    sudo chsh -s $(which zsh)
    sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    sudo cp /vagrant/templates/.zshrc ~/.zshrc
    sudo cp /vagrant/templates/passwd /etc/passwd
    sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
    # plugins
    git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
    git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions

    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

    sh fonts/install.sh
    # source ~/.zshrc
    #How to run it?
    # chsh -s $(which zsh)
    echo "================"
    echo "Install VIM"
    echo "================"
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    cp /vagrant/templates/.vimrc ~/.vimrc
    mkdir -p ~/.vim/autoload ~/.vim/bundle && curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
    git clone https://github.com/scrooloose/nerdtree.git ~/.vim/bundle/nerdtree
    vim +PluginInstall +qall
}


function install_theme() {
    echo "================"
    echo "Install Theme"
    echo "================"
    # https://github.com/daniruiz/Flat-Remix
    sudo add-apt-repository ppa:daniruiz/flat-remix -y
    sudo apt-get update
}


function main() {

    echo "Main function"
    install_keepasxc
    slick_dock
    install_zsh
    install_theme
}

main
