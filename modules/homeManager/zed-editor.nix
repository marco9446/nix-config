{ lib, config, pkgs, ... }:

{
  options = {
    homeModules.zed-editor.enable = lib.mkEnableOption "enable zed-editor";
  };
  config = lib.mkIf config.homeModules.zed-editor.enable {
    programs.zed-editor = {
      enable = true;
      themes = { };
      extraPackages = [
        pkgs.nil
      ];

      userKeymaps = [
        {
          context = "Workspace";
          bindings = {
            ctrl-shift-t = "workspace::NewTerminal";
          };
        }
      ];
    };
  };
}
