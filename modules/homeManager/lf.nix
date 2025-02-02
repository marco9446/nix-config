{ pkgs, config, lib, ... }:

{
  options = {
    homeModules.lf.enable = lib.mkEnableOption "enable lf";
  };
  config = lib.mkIf config.homeModules.lf.enable {

    xdg.configFile."lf/icons".source = ../../assets/lf_icons;
    xdg.configFile."lf/colors".source = ../../assets/lf_colors;

    # Documentation: https://github.com/gokcehan/lf/blob/master/doc.md
    programs.lf = {
      enable = true;

      commands = {
        mkdir = ''
          ''${{
            printf "Directory Name: "
            read DIR
            mkdir $DIR
          }}
        '';
      };

      keybindings = {
        gh = "cd ~";
        c = "mkdir";
        "<enter>" = "open";
        i = ''''$${pkgs.bat}/bin/bat --paging=always --theme="Monokai Extended" "$f"'';
      };

      settings = {
        number = false;
        mouse = true;
        preview = true;
        hidden = true;
        drawbox = true;
        dircounts = true;
        icons = true;
        ignorecase = true;
        ratios = [ 1 1 2 ];
        tabstop = 4;
        info = [ "size" ];
      };
    };
  };
}
