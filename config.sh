CREATOR_HOSTNAME='MacBook-Air.local'
CREATOR_IP='10.0.2.2'
CREATOR_USERNAME='alec'

vim_config_update () { # {{{1
  echo "  - updating vim configuration files..."

  cp .vimrc $HOME

  echo '    ...done'; echo
}
