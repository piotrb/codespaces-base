#!/bin/zsh

# A command to run after starting the container. This command is run after "postCreateCommand" and before "postAttachCommand".

set -e

echo "Installing Ruby ..." > /dev/stderr
rbenv download `cat .ruby-version`
#rbenv install --skip-existing

echo "Installing Node ..." > /dev/stderr
nodenv update-version-defs
nodenv install --skip-existing

echo "Installing Yarn ..." > /dev/stderr
npm install --global yarn

echo "Installing Node Packages ..." > /dev/stderr
yarn

echo "Installing Gems ..." > /dev/stderr
bundle
