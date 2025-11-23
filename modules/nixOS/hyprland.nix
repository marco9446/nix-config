{ config, lib, pkgs, ... }:
{
  # Documentation: https://github.com/viperML/nh
  options = {
    modules.hyprland.enable = lib.mkEnableOption "enable hyprland module";
  };

  config = lib.mkIf config.modules.hyprland.enable {

    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
      withUWSM = true;
    };

    environment.systemPackages = with pkgs; [
      kitty
      hyprpaper
      waybar
      wofi
    ];
  };
}
