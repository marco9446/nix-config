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