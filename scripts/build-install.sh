#!/bin/bash

# Check if we are running as root
if [ "$(id -u)" -eq 0 ]; then
    echo "Running as root."
    use_sudo=""
else
    echo "Not running as root."
    use_sudo="sudo"
fi

# Extract ION source assuming no local source
./scripts/extract.sh || { echo "Extract failed"; exit 1; }

# Build ION-core
make || { echo "Make failed"; exit 1; }

# Run make install with or without sudo based on whether we are root
$use_sudo make install
