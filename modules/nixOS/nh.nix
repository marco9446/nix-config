{ config, lib, username, host,  ... }:
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
      flake = if (host == "wsl" )then "/mnt/c/Users/marco.ravazzini/projects/nix-config" else "/home/${username}/nix-config";
    };
  };
}
