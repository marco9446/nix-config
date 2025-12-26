{lib, config, ...}:

{
  options = {
    homeModules.zed-editor.enable = lib.mkEnableOption "enable zed-editor";
  };
  config = lib.mkIf config.homeModules.zed-editor.enable {
    programs.zed-editor = {
      enable = true;
      themes = {};

      userKeymaps = [
        {context = "Workspace";
          bindings = {
            ctrl-shift-t = "workspace::NewTerminal";
        };}
      ];
    };
  };
}
