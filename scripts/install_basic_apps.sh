#!/bin/bash

INSTALL_CMD="$1"

if [[ -z "$INSTALL_CMD" ]]; then
  echo "Error: INSTALL_CMD not set. Exiting."
  exit 1
fi

echo "Installing basic development tools using: $INSTALL_CMD"

BASIC_APPS=(
  git
  curl
  wget
  jq
)

for app in "${BASIC_APPS[@]}"; do
  echo "Installing $app..."
  $INSTALL_CMD "$app"
done

echo "Basic applications installed."

