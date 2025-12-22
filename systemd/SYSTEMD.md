# Using systemd to run the server

There is an example unit file for reference. Note particularly the `WorkingDirectory` paramter, which needs to be set to the absolute path from root to the top level of this repository, as the scripts are sensitive to the working directory that they're called from.

Remember to pass the `--user` directive in calls to `systemctl` and don't put the unit in the system-wide directory. Likewise, because the `kali-minecraft` service will log to journald by default (without an explicit logging path specified), we need to run `journalctl --user -u kali-minecraft.service` to get the service logs (pass `--follow` to watch the logs live).

Running the server in the foreground with systemd (i.e. calling `run.sh` instead of `run-detached.sh`) means:
- Systemd can track the Docker Compose process as the main service process.
- The container logs actually appear in journald.

In detached mode, systemd can't see the main Docker Compose service process, can't restart it if it fails, and the container logs don't appear in journald (so they are inaccessible via `journalctl`).

## Useful Commands:

- `systemctl --user list-unit-files --type=service | grep -i minecraft`
    - Find all the Minecraft-related unit files for the calling user by doing a case-insensitive search.
- `systemctl --user daemon-reload`
    - Reload systemd if it's not picking up on the new unit file.
- `mkdir -p ~/.config/systemd/user`
    - Make the directory for systemd unit files for the current user. This is the default location for all systemd-based Linux distributions, including Amazon Linux 2023 (Fedora) and Kali Linux (Debian).
    - Note that this directory may not already exist if the current user doesn't have any custom unit files to put in there yet, but systemd will pick up on it automatically once created, as it's a well-known directory.