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
}

function install_vim() {
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

function install_jb_tools() {
    curl -L https://download.jetbrains.com/toolbox/jetbrains-toolbox-1.6.2914.tar.gz -o /tmp/jetbrains-toolbox.tar.gz
    tar -xf /tmp/jetbrains-toolbox.tar.gz
    sudo mkdir /develop
    sudo chown $USER:$USER /develop
    mkdir /develop/tools
    mv /tmp/jetbrains-toolbox-1.6.2914/jetbrains-toolbox /develop/tools/jetbrains-toolbox
    rm -rf /tmp/jetbrains*
    chmod -R 777 /develop/tools/jetbrains-toolbox
}

function install_vs_code() {
    curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
    sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
    sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
    sudo apt-get update
    sudo apt-get install code # or code-insiders
    mkdir -p $HOME/.config/Code/User/
    curl -L https://gist.githubusercontent.com/tanzwud/bd1e94b194a9a148b425e7f55991bbd5/raw/a6860d9a285bdefcec547225ba9b8874b0e5345f/settings.json  -o $HOME/.config/Code/User/settings.json
    curl -L https://gist.githubusercontent.com/tanzwud/bd1e94b194a9a148b425e7f55991bbd5/raw/a6860d9a285bdefcec547225ba9b8874b0e5345f/keybindings.json -o $HOME/.config/Code/User/keybindings.json
}


function main() {
    sudo apt update
    sudo apt install git -y
    echo "Main function"
    install_vs_code
    install_keepasxc
    install_jb_tools
    slick_dock
    install_theme
    install_vim
    install_zsh
}

main
