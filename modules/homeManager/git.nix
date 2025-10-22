{ config, lib, ... }:

{
  options = {
    homeModules.git.enable = lib.mkEnableOption "enable git";
  };
  config = lib.mkIf config.homeModules.git.enable {
    # basic configuration of git
    programs.git = {
      enable = true;
      settings = {
  userName = "marco";
      userEmail = "marco@test.com";
      };
    
    };
  };
}
