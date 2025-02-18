{ lib, config, ... }: {

  options = {
    homeModules.gtk.enable = lib.mkEnableOption "enable gtk";
  };
  config = lib.mkIf config.homeModules.gtk.enable {
    gtk = {
      enable = true;
      # gtk.theme = "Pop";
      cursorTheme.name = "Pop";
      cursorTheme.size = 22;
    };
  };
}
