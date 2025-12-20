#!/bin/bash

# Config
DATA_DIR="./data"           # The directory where the server files are
BACKUP_DIR="./backups"      # The directory in which to put the backups
MAX_BACKUPS=10              # The number of backups to retain
CONTAINER="minecraft"       # The name of the Docker-Compose Minecraft service

# Announce backup
docker compose exec -T $CONTAINER rcon-cli say "§c[Backup] Starting automated backup - save-all in progress..."

# Flush and pause world saving (minimal downtime)
docker compose exec -T $CONTAINER rcon-cli save-all
docker compose exec -T $CONTAINER rcon-cli save-off

# Quick sync (seconds)
sleep 3

# Create timestamped backup
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/minecraft-data-$TIMESTAMP.tar.gz"
# Only back up what is necessary; exclude stuff that can be pulled at server startup
tar -czf $BACKUP_FILE \
    --exclude="minecraft_server.1.21.11.jar" \
    --exclude="libraries" \
    --exclude="versions" \
    --exclude=".cache" \
    -C "$DATA_DIR" .


# Re-enable saving
docker compose exec -T $CONTAINER rcon-cli save-on
docker compose exec -T $CONTAINER rcon-cli say "§a[Backup] Complete! $(basename $BACKUP_FILE)"

# Rotate: keep only last 10
ls -t $BACKUP_DIR/minecraft-data-*.tar.gz | tail -n +$((MAX_BACKUPS + 1)) | xargs -r rm -f

echo "Backup complete: $BACKUP_FILE ($(du -h $BACKUP_FILE | cut -f1))."
echo "Current list of backups:"
du -sh backups/* | sort -rh
