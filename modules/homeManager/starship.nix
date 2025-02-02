{ lib, config, ... }:

{
  options = {
    homeModules.starship.enable = lib.mkEnableOption "enable starship";
  };
  config = lib.mkIf config.homeModules.starship.enable {
    # starship - an customizable prompt for any shell
    programs.starship = {
      enable = true;
      # custom settings
      settings = {
        add_newline = false;
        aws.disabled = true;
        gcloud.disabled = true;
        sudo.disabled = false;
        line_break.disabled = true;
      };
    };
  };
}
