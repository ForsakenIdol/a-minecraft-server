# Using systemd to run the server

There is an example unit file for reference. Note particularly the `WorkingDirectory` paramter, which needs to be set to the absolute path from root to the top level of this repository, as the scripts are sensitive to the working directory that they're called from.

Remember to pass the `--user` directive in calls to `systemctl`. We do this because our unit file should be placed into the relevant folder in the home directory for the **current user** (`~/.config/systemd/user`), not in the global cron directory (`/etc/cron.d`).

Because the `kali-minecraft` service will log to journald by default (without an explicit logging path specified), we need to run `journalctl --user -u kali-minecraft.service` to get the service logs (pass `--follow` to watch the logs live).

Running the server in the foreground with systemd (i.e. calling `run.sh` instead of `run-detached.sh`) means:
- Systemd can track the Docker Compose process as the main service process.
- The container logs actually appear in journald.

In detached mode, systemd can't see the main Docker Compose service process, can't restart it if it fails, and the container logs don't appear in journald (so they are inaccessible via `journalctl`).

## Using systemd Timers

You can also use systemd timers for the backup process. A systemd timer comprises 2 files:
- The `.service` file that contains **what** to run.
- The `.timer` file that contains **when** to run the executable defined in the `.service` file.

## Useful Commands:

- `systemctl --user list-unit-files --type=service | grep -i minecraft`
    - Find all the Minecraft-related unit files for the calling user by doing a case-insensitive search.
- `systemctl --user daemon-reload`
    - Reload systemd if it's not picking up on the new unit file.
- `mkdir -p ~/.config/systemd/user`
    - Make the directory for systemd unit files for the current user. This is the default location for all systemd-based Linux distributions, including Amazon Linux 2023 (Fedora) and Kali Linux (Debian).
    - Note that this directory may not already exist if the current user doesn't have any custom unit files to put in there yet, but systemd will pick up on it automatically once created, as it's a well-known directory.
- `journalctl --user -u minecraft.service`
    - By default, systemd services log to journald unless we explicitly specify a different location.

Timer-specific commands (`start`, `stop`, `enable`, and `disable` work for timers just like they do for services):

- `systemctl --user status worldbackup.timer`
    - You can fetch the status of systemd timers using the same syntax for systemd services.
- `systemctl --user enable --now worldbackup.timer`
    - Combines `start` and `enable`. Makes the timer run on boot, and also triggers it to start executing **now**. With just `enable`, the timer will start on next boot, but will wait until the system is next booted.
- `systemctl --user list-timers`
    - List all the timers for the calling user. Pass `--all` to see loaded but inactive timers as well.
