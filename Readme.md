# Deluge plugin dev env

This repository provides a turnkey Deluge plugin dev environment.

It allows you to create a new plugin, register it and start a
sandboxed `deluge` instance with that plugin.

Why you want this:
* No fiddling with python virtual env
* No need to clone deluge repo
* Fully reproducible thanks to nix
* Fully sandboxed environment
* Test plugin easily on web and gtk

## Tutorial

Start a `deluge` instance with a local config directory:

```bash
nix run github:ibizaman/deluge-plugindev#deluged -- \
    --config .config
```

This creates a `.config` directory with the correct layout.

Start the web instance:

```bash
nix run github:ibizaman/deluge-plugindev#deluge-web -- \
    --config .config
```

Go to http://localhost:8112/ to connect to it, the default password is
`deluge`.

Generate a plugin template:

```bash
nix run github:ibizaman/deluge-plugindev#createplugin -- \
    --config .config \
    --name MyPlugin \
    --basepath . \
    --author-name "Your Name" \
    --author-email "yourname@example.com"
```

Then restart the `deluged` instance so it picks up the plugin:

```bash
nix run nixpkgs#killall .deluged-wrapped

nix run github:ibizaman/deluge-plugindev#deluged -- \
    --config .config
```
