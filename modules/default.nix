{ lib, ... }: {

  imports = [
    ./gui
    ./common.nix
    ./bluetooth.nix
    ./nixVim.nix
    ./user.nix
    ./nvidia.nix
  ];

  bluetoohModule.enable = lib.mkDefault true;
  nixVimModule.enable = lib.mkDefault true;
  nvidiaModule.enable = lib.mkDefault false;
}
