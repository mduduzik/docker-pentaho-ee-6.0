#! /bin/bash

set -e

# Add $SSH_PUBLIC_KEY to the authorized_keys file.
add_ssh_key () {
    if grep -q "$SSH_PUBLIC_KEY" ~/.ssh/authorized_keys
    then
        # Do nothing if the key is already there.
        echo "The SSH public key already exists"
    else
        mkdir -p ~/.ssh
        # Add the key if not already there.
        echo $SSH_PUBLIC_KEY >> ~/.ssh/authorized_keys
    fi
}

# STEP 1: add the given SSH public key.
# During a `docker run` the environment variable SSH_PUBLIC_KEY must be passed.
# This key will be added to the authorized_keys of the SSH server of the container.
# This way the key's owner is allowed to SSH into the container.
echo " * Adding public SSH key..."
if [ ! -z "$SSH_PUBLIC_KEY" ]  # If the env var $SSH_PUBLIC_KEY is set.
then
    add_ssh_key
fi