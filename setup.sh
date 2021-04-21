#!/usr/bin/env bash

. config.sh

add_creator () { # {{{1
  echo '  - adding creator...'

  sudo echo "# Adding creator on $(date)" >> /etc/hosts
  sudo echo "${CREATOR_IP} ${CREATOR_HOSTNAME} ## ${CREATOR_USERNAME}" >> /etc/hosts

  echo '    ...done'; echo
}

bootstrap () { # {{{1
  echo '- bootstrapping...'

  # Add creator info to /etc/hosts {{{2
  [ -e creator_added ] || add_creator

  # Create our id_ed25519 pair (no passphrase) {{{2
  local t='ed25519'
  local key="$HOME/.ssh/id_$t"
  rm -f ~/.ssh/known_hosts ${key}*
  ssh-keygen -t $t -f $key -q -N ''

  # SSH to the creator with password authentication {{{2
  local pubkey="${key}.pub"
  local uri="${CREATOR_USERNAME}@${CREATOR_HOSTNAME}"
  local script=${2:-'project/m1-utm-ubuntu/bootstrap-creator.sh'}
  ssh $uri $script < $pubkey > response

  # Write new ~/.ssh/config {{{2
  cp config ~/.ssh/
  # }}}2

  echo '  ...done'; echo
}

# Bootstrap {{{1
#
# Right after the server has been created, noone can SSH to it. But the server's 
# original configuration supports SSH to its creator with password authentication,
# so initially the server creates its own id_ed25519 pair and passes the public key
# to the creator, along with the name of a script for creator to run. 
#
# The creator saves the public key in its authorized_keys, [ TODO propagates it to
# the rest of the users ], and responds with a copy of its ~/.ssh/id_ed25519.pub
# and /etc/hosts files [ TODO , followed by the public keys of the users it knows ].
# The server uses the data to establish connections with its users during the setup.
#
# Finally, a new ~/.ssh/config is being written. It allows remote port forwarding
# and sets the connect timeout. This completes the bootstrap.
#
[ -e ~/.ssh/config ] || bootstrap

# Setup {{{1
#
# Our server is set up when its users can SSH to it. A user can SSH to our server
# using remote port forwarding. To enable this, the server tries and connects to
# its users (creator included).
echo '- setting up...'

# Try and connect to the users {{{2
# TODO ./users.awk response
cat response
# }}}2

echo '  ...done'; echo
