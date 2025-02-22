# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{ inputs, username, ... }:

{
  imports = [
    inputs.nixos-wsl.nixosModules.default
    {
      system.stateVersion = "24.05";
      wsl.enable = true;
    }
    ../../modules/nixOS
  ];

  modules = {
    customConfig = {
      desktop = "none";
    };
    homeManager = {
      enable = true;
      path = ./home.nix;
    };
  };

  wsl.enable = true;
  wsl.defaultUser = username;

  # Disable systemd-resolved to avoid conflict with WSL's resolv.conf management
  services.resolved.enable = false;

  # It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  system.stateVersion = "24.05"; # Did you read the comment?
}
