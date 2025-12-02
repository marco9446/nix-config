{ config, lib, username, host, ... }:
{
  # Documentation: https://github.com/viperML/nh
  options = {
    modules.nh.enable = lib.mkEnableOption "enable nh module";
  };

  config = lib.mkIf config.modules.nh.enable {
    programs.nh = {
      enable = true;
      clean.enable = host != "wsl";
      clean.dates = "18:00";
      flake = if (host == "wsl") then "/mnt/c/Users/marco.ravazzini/projects_dev/nix-config" else "/home/${username}/nix-config";
    };
  };
}
