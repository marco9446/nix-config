{ config, lib, ... }:

{
  options = {
    homeModules.git.enable = lib.mkEnableOption "enable git";
  };
  config = lib.mkIf config.homeModules.git.enable {
    # basic configuration of git
    programs.git = {
      enable = true;
      settings.user = {
        name = "marco";
        email = "marco@test.com";
      };
    };
  };
}
