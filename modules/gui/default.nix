{ lib, ... }: {

  imports = [
    ./cosmicDesktop.nix
    ./xfce.nix
  ];


  cosmicDesktopModule.enable = lib.mkDefault false;
  xfceModule.enable = lib.mkDefault false;
}
