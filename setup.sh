#!/usr/bin/env bash

. config.sh

bootstrap () { # {{{1
  echo '- bootstrapping...'

  # Create our id_ed25519 pair (no passphrase) {{{2
  local t='ed25519'
  local key="$HOME/.ssh/id_$t"
  rm -f ~/.ssh/known_hosts ${key}*
  ssh-keygen -t $t -f $key -q -N ''

  # SSH to the creator with password authentication {{{2
  local pubkey="${key}.pub"
  local uri=$1
  cat $pubkey | ssh $uri 'project/m1-utm-ubuntu/bootstrap-creator.sh' | cat > hosts

  # Write new ~/.ssh/config {{{2
  echo fake > ~/.ssh/config
  # }}}2

  echo '  ...done'; echo
}

# Bootstrap {{{1
#
# Right after the server has been created, noone can SSH to it. But the server's 
# original configuration supports SSH to its creator with password authentication,
# so initially we create our id_ed25519 pair, pass the public key to the creator,
# along with a script for it to run. The creator saves the public key in its
# authorized_keys, propagates it to the rest of the users,and responds with a copy 
# of its /etc/hosts file. The server uses the data to connect to its users in the 
# setup phase. Finally, a new ~/.ssh/config is being written. It disables password
# authentication and sets the connect timeout.
[ -e ~/.ssh/config ] || bootstrap $CREATOR

# Setup {{{1
#
# Our server is set up when its users can SSH to it. A user can SSH to our server
# using remote port forwarding. To enable this, the server tries and connects to
# its users (creator included).
echo '- setting up...'

# Try and connect to the users {{{2
cat hosts
# }}}2

echo '  ...done'; echo
