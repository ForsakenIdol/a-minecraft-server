# a-minecraft-server

A Minecraft server for me and my friends to play on.

## Ataching to TTY

Run `docker-compose attach minecraft`. Here, you can run the standard server command suite (e.g. try `say Hello World!` to speak as the server, or `/whitelist add <username>` to add users). Once done, press `Ctrl` + `P` and then `Ctrl` + `Q` to detach - do not use `Ctrl` + `C`, because you will stop the server (remember - you're attached to the main process' STDIN).