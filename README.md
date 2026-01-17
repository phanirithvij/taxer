## Packages

- forex-python
  - the api it uses is dead
    https://github.com/MicroPyramid/forex-python/issues/158
- frankerfuter
  - selfhosted open-source currency data API

## Deploy

<!-- TODO make it work without sudo, allow configuring dataDir from cli -->

```console
# direnv or nix-shell or nix develop ./nix/flake
$ sudo mkdir -p /var/lib/frankerfuter/db
$ sudo chown -R $(whoami) /var/lib/frankerfuter

# currency exchange rate server
$ frankerfuter

# new terminal, print tax summary
$ tax
```
