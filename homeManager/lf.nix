{ config, lib, ... }:

{
  options = {
    homeModules.lf.enable = lib.mkEnableOption "enable lf";
  };
  config = lib.mkIf config.homeModules.lf.enable {
    # basic configuration of git
    programs.lf = {
      enable = true;

      keybindings= {
        gh = "cd ~";
      };

      settings={
        number = true;
        preview= true;
        hidden= true;
        drawbox= true;
        icons= true;
        ignorecase= true;
        ratios = [ 1 1 2 ];
        tabstop = 4;
      };
    };
  };
}
