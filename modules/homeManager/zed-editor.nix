{
  lib,
  username,
  config,
  pkgs,
  ...
}:

{
  options = {
    homeModules.zed-editor.enable = lib.mkEnableOption "enable zed-editor";
  };
  config = lib.mkIf config.homeModules.zed-editor.enable {
    programs.zed-editor = {
      enable = true;

      extraPackages = [
        pkgs.nil
      ];
    };

    xdg.configFile."zed" = {
      source = config.lib.file.mkOutOfStoreSymlink "/home/${username}/nix-config/dotfiles/zed";
      recursive = true;
    };
  };
}
