#!/bin/sh

eval "$(/usr/bin/gnome-keyring-daemon --start --components=secrets,ssh,gpg)"
export GNOME_KEYRING_CONTROL SSH_AUTH_SOCK GPG_AGENT_INFO
