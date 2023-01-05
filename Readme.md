# Deluge create plugin

From deluge's [Getting Started documentation][1], creating a new plugin skeleton is as simple as:

```bash
python create_plugin.py \
    --name MyPlugin \
    --basepath . \
    --author-name "Your Name" \
    --author-email "yourname@example.com"
```

But this assumes you have a python environment configured correctly.

This repo contains a nix flake expression that provides a
self-contained app to create a deluge plugin. No need to fiddle with
python environments.

Using this repo, the example from the deluge documentation would be:

```bash
nix run github:ibizaman/deluge-createplugin -- \
    --name MyPlugin \
    --basepath . \
    --author-name "Your Name" \
    --author-email "yourname@example.com"
```

[1]: https://dev.deluge-torrent.org/wiki/Development/1.3/Plugin#GettingStarted
