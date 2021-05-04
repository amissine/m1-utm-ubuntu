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

s6up () { # {{{1
  local old=$1
  local new=$2
  local dir=${3:-admin}
  sudo rm -rf /package/$dir/$old; rm -rf $old $old.build sources/$old.tar.gz
  mv hashes/$old.tar.gz.sha1 hashes/$new.tar.gz.sha1
}

s6_upgrade210502 () { # {{{1
  s6up 'bcnm-0.0.1.2' 'bcnm-0.0.1.3'
  s6up 'execline-2.8.0.0' 'execline-2.8.0.1'
  s6up 'mdevd-0.1.3.0' 'mdevd-0.1.4.0'
  s6up 'nsss-0.1.0.0' 'nsss-0.1.0.1'
  s6up 's6-2.10.0.2' 's6-2.10.0.3'
  s6up 's6-dns-2.3.5.0' 's6-dns-2.3.5.1' web
  s6up 's6-linux-init-1.0.6.1' 's6-linux-init-1.0.6.3'
  s6up 's6-linux-utils-2.5.1.4' 's6-linux-utils-2.5.1.5'
  s6up 's6-networking-2.4.1.0' 's6-networking-2.4.1.1' net
  s6up 's6-portable-utils-2.2.3.1' 's6-portable-utils-2.2.3.2'
  s6up 's6-rc-0.5.2.1' 's6-rc-0.5.2.2'
  s6up 'skalibs-2.10.0.2' 'skalibs-2.10.0.3' prog
  s6up 'utmps-0.1.0.0' 'utmps-0.1.0.2'
  make SKIP_SHASUM=yes
}

update_hashes () { # {{{1
  echo '- updating hashes:'; cd sources
  for s in *; do
    echo "-   $s"
    sha1sum -b $s > $s.sha1
    mv -f $s.sha1 ../hashes/$s.sha1
    sleep 1; touch $s
    r=${s%.tar.gz}
    sleep 1; touch ../$r.build; sleep 1; touch ../$r
  done
  cd -
}
