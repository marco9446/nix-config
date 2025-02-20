{ config, lib, username, ... }:
{
  # Documentation: https://github.com/viperML/nh
  options = {
    modules.nh.enable = lib.mkEnableOption "enable nh module";
  };

  config = lib.mkIf config.modules.nh.enable {
    programs.nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep 3";
      flake = "/home/${username}/nix-config";
    };
  };
}
