# nix-config

Configuration for nixOS

### Create symbolic link

```shell
# Backup the original configuration
sudo mv /etc/nixos /etc/nixos.bak
sudo ln -s ~/nix-config /etc/nixos

# Deploy the flake.nix located at the default location (/etc/nixos)
sudo nixos-rebuild switch
```

## Theme

The theme should be `Monokay pro`

### Windows terminal

```json
{
  "name": "Monokai Pro",
  "black": "#403e41",
  "red": "#ff6188",
  "green": "#a9dc76",
  "yellow": "#ffd866",
  "blue": "#fc9867",
  "purple": "#ab9df2",
  "cyan": "#78dce8",
  "white": "#fcfcfa",
  "brightBlack": "#727072",
  "brightRed": "#ff6188",
  "brightGreen": "#a9dc76",
  "brightYellow": "#ffd866",
  "brightBlue": "#fc9867",
  "brightPurple": "#ab9df2",
  "brightCyan": "#78dce8",
  "brightWhite": "#fcfcfa",
  "background": "#403e41",
  "foreground": "#fcfcfa",
  "selectionBackground": "#fcfcfa",
  "cursorColor": "#fcfcfa"
}
```
