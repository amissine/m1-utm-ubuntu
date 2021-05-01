CREATOR_HOSTNAME='MacBook-Air.local'
CREATOR_IP='10.0.2.2'
CREATOR_USERNAME='alec'

vim_config_update () { # {{{1
  echo "  - updating vim configuration files..."

  cp .vimrc $HOME

  echo '    ...done'; echo
}

install_packages () { # {{{1
  echo "  - installing packages..."

  export DEBIAN_FRONTEND=noninteractive
  sudo -E apt-get update && \
    sudo -E apt-get -y install build-essential # autoconf automake libtool

  make

  echo '    ...done'; echo
}

lns () { # {{{1
  local target=$1
  local name=$2
  local dir=$3
  cd $dir
  sudo rm -f $name; sudo ln -s $target $name
  cd -
}
