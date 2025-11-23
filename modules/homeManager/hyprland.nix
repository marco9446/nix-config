{ config, lib, ... }:

{
  options = {
    homeModules.hyprland.enable = lib.mkEnableOption "enable hyprland";
  };
  config = lib.mkIf config.homeModules.hyprland.enable {
    # basic configuration of hyprland
    home.file.".config/hypr".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/config/hypr";
    home.file.".config/waybar".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/config/waybar";
  };
}
