{ pkgs, lib, config, ... }:
let
  yazi-plugins = pkgs.fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "main";
    hash = "sha256-Cw5iMljJJkxOzAGjWGIlCa7gnItvBln60laFMf6PSPM=";
  };
in
{

  options = {
    homeModules.yazi.enable = lib.mkEnableOption "enable yazi";
  };
  config = lib.mkIf config.homeModules.yazi.enable {

    programs.yazi = {
      enable = true;
      enableZshIntegration = true;
      shellWrapperName = "y";

      settings = {
        manager = {
          show_hidden = true;
          sort_dir_first = true;
          ratio = [ 1 4 3 ];
          show_symlink = true;
          linemode = "size";
        };
        preview = {
          wrap = "yes";
          tab_size = 2;

          max_width = 1000;
          max_height = 1000;
        };
      };

      plugins = {
        full-border = "${yazi-plugins}/full-border.yazi";
        max-preview = "${yazi-plugins}/max-preview.yazi";
      };

      initLua = ''
        require("full-border"):setup()
      '';

      keymap = {
        manager.prepend_keymap = [
          {
            on = "i";
            run = "plugin max-preview";
            desc = "Maximize or restore the preview pane";
          }
        ];
      };
    };
  };
}
