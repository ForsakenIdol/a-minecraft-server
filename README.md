# a-minecraft-server

A Minecraft server for me and my friends to play on.

## Setup and Management

- On a new instance or VM, `cd` into the directory with this `README.md` file, then run `./restore.sh`. This will set up the server from the most recent backup. If there isn't a backup, then this is probably either:
    - The first time you're setting up the server, or
    - Someone has accidentally overwritten or removed the `backups/` folder. Check the git log to see if this is the case, probably just the last 1 or 2 commits.
- To start the server, use `./run.sh`, or `./run-detached.sh` for a non-blocking mode.
- To stop the server, run `docker compose down` from the directory with this README.md file.
- Backups can be taken while the server is still running and should be done just before stopping the server. To take a backup (which is just compressing the important world and configuration files into an archive in the `backup/` directory), run `./backup.sh`.
    - This will probably need to be run as a cronjob. Please let ForsakenIdol know if a cronjob has not been configured, if this repository is being run on a VM.

Cronjob example:
```
0 * * * * cd /path/to/repo && ./backup.sh > most-recent-backup.log
```

Note that the whitelist should not be configured in the `data/` directory. Add users to the whitelist via tha variable defined in the `whitelist.env` file.

## The World Seed

If a world has not already been loaded into the `data/` directory:

- Leaving the container's `SEED` environment variable empty will result in a random seed being chosen when the inital world is being created.
- Using a valid `SEED` number (positive or negative) will use that seed during random generation.

If a world is already loaded in `data/`, the `SEED` container environment variable has no effect and seems to be ignored.


## Ataching to TTY

Run `docker-compose attach minecraft`. Here, you can run the standard server command suite (e.g. try `say Hello World!` to speak as the server, or `/whitelist add <username>` to add users). Once done, press `Ctrl` + `P` and then `Ctrl` + `Q` to detach - do not use `Ctrl` + `C`, because you will stop the server (remember - you're attached to the main process' STDIN).

If you accidentally stop the server, first, run `docker compose down` to make sure it's stopped properly, then run either of the `run` scripts to start it up again.

## Token Management

You may need to specify the GitHub Personal Access Token (PAT) to push to the remote origin. In either case, the following commands may be helpful, assuming you already have the PAT, to avoid constantly having to provide the token:

```sh
git config credential.helper # Get the current setting for the credential helper
git config --global credential.helper 'cache --timeout=10800' # Cache the token for 10800 seconds (3 hours)
git config credential.helper store # Store the token in local storage
```

This becomes important if you run the `pull-and-run-detached.sh` script.
