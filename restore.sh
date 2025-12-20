#!/bin/bash

# Reset data/ directory
rm -rf ./data
mkdir -p ./data

# Extract most recent backup
tar -xzf $(ls -t backups/minecraft-data-*.tar.gz | head -n1) -C ./data/