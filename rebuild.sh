#!/usr/bin/env bash
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
ln -sfn "$DIR" ~/.dotfiles
# Write flake.lock as the user; otherwise sudo creates it (and git objects) owned by root.
nix flake lock "$DIR"
exec sudo darwin-rebuild switch --flake ~/.dotfiles#mac
