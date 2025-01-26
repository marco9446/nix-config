{ lib, ... }: {

  imports = [
    ./cosmicDesktop.nix
    ./xfce.nix
    ./nvidia.nix
  ];

  modules = {
    nvidia.enable = lib.mkDefault false;
    cosmicDesktop.enable = lib.mkDefault false;
    xfce.enable = lib.mkDefault false;
  };
}
