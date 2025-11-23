{ config, lib, ... }:

{
  options = {
    homeModules.hyprland.enable = lib.mkEnableOption "enable hyprland";
  };
  config = lib.mkIf config.homeModules.hyprland.enable {
    # basic configuration of hyprland
    home.file.".config/hypr".source = ../../config/hypr;
    home.file.".config/waybar".source = ../../config/waybar;
  };
}
