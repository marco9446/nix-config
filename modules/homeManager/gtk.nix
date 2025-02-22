{ lib, config, pkgs, ... }: {

  options = {
    homeModules.gtk.enable = lib.mkEnableOption "enable gtk";
  };
  config = lib.mkIf config.homeModules.gtk.enable {
    gtk = {
      enable = true;
      cursorTheme.size = config.homeModules.xfce.cursorSize;
      cursorTheme.name = "elementary";
      iconTheme = {
        name = "Flat-Remix-Blue-Dark";
        package = pkgs.flat-remix-icon-theme;
      };
      font = {
        name = "Noto Sans";
        package = pkgs.noto-fonts;
        size = config.homeModules.xfce.fontSize;
      };
    };
  };
}
