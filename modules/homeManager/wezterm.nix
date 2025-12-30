{ lib
, username
, config
, pkgs
, ...
}:
{

  options = {
    homeModules.wezterm.enable = lib.mkEnableOption "enable wezterm";
  };

  config = lib.mkIf config.homeModules.wezterm.enable {
    home.packages = with pkgs; [ wezterm ];

    # apply dotfile
    xdg.configFile."wezterm" = {
      source = config.lib.file.mkOutOfStoreSymlink "/home/${username}/nix-config/dotfiles/wezterm";
      recursive = true;
    };
  };
}
