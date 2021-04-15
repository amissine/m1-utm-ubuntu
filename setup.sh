#!/usr/bin/env bash

bootstrap () { # {{{1
  echo '- bootstrapping...'

  # Create our id_ed25519 pair (no passphrase).
  rm -f ~/.ssh/known_hosts ~/.ssh/id_ed25519*
  ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -q -N ''

  echo fake > ~/.ssh/config
  echo '  ...done'; echo
}

# Bootstrap {{{1
#
# Right after the server has been created, noone can SSH to it. But the server's 
# original configuration supports SSH to its creator with password authentication,
# so initially we create our id_ed25519 pair, pass the public key to the creator,
# along with a script for it to run. The creator saves the public key in its
# authorized_keys, and responds with a copy of its /etc/hosts file. The server
# uses the data to propagate its public key to the rest of users. When this is
# done, a new ~/.ssh/config is being written. It disables password authentication
# and sets the connect timeout.
[ -e ~/.ssh/config ] || bootstrap

# Setup {{{1
#
# Our server is set up when its users can SSH to it. A user can SSH to our server
# using remote port forwarding. To enable this, the server tries and connects to
# its users (creator included).
echo '- setting up...'
echo '  ...done'; echo
