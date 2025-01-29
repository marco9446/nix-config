{ config, lib, ... }:

{
  options = {
    homeModules.eza.enable = lib.mkEnableOption "enable eza";
  };
  config = lib.mkIf config.homeModules.eza.enable {
    # basic configuration of eza
    programs.eza = {
      enable = true;
      enableZshIntegration= true;
      git = false;
      icons = "auto";
      extraOptions = [ "--group-directories-first" ];
    };
  };
}
