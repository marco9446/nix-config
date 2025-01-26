# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{ inputs, ... }:

{
  imports = [
    inputs.nixvim.nixosModules.nixvim
    ../../modules
  ];

  wsl.enable = true;
  wsl.defaultUser = "marco";

  networking = {
    hostName = "wsl";
    networkmanager.enable = true;
  };

  programs = {
    zsh.enable = true;
  };

  # It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  system.stateVersion = "24.05"; # Did you read the comment?
}
