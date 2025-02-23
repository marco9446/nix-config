{ lib, config, pkgs, ... }: {

  options = {
    modules.gnome.enable = lib.mkEnableOption "enable gnome module";
  };

  config = lib.mkIf config.modules.gnome.enable {

    services.xserver.enable = true;
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.desktopManager.gnome.enable = true;



    environment.systemPackages = with pkgs; [
      gnome-tweaks
      gnomeExtensions.blur-my-shell
      gnomeExtensions.pop-shell
      gnomeExtensions.arcmenu
    ];

    programs.dconf = {
      enable = true;
      profiles.user.databases = [
        {
          lockAll = false; # prevents overriding
          settings = {

            "org/gnome/shell" = {
              disable-user-extensions = false; # enables user extensions
              enabled-extensions = [
                pkgs.gnomeExtensions.blur-my-shell.extensionUuid
                pkgs.gnomeExtensions.pop-shell.extensionUuid
                pkgs.gnomeExtensions.arcmenu.extensionUuid
                "system-monitor@gnome-shell-extensions.gcampax.github.com"
              ];
            };

            "org/gnome/shell/extensions/arcmenu" = {
              show-activities-button = true;
              menu-layout = "Runner";
              runner-search-display-style = "Grid";
              runner-font-size = lib.gvariant.mkInt32 13;
              runner-show-frequent-apps = true;
            };

            "org/gnome/desktop/interface" = {
              clock-show-weekday = true;
            };
            "org/gnome/desktop/input-sources" = {
              xkb-options = [ "terminate:ctrl_alt_bksp" "lv3:ralt_switch" "caps:backspace" ];
            };

          };
        }
      ];
    };


    environment.gnome.excludePackages = with pkgs; [
      # adwaita-icon-theme
      # file-roller # Archive manager
      # glib # for gsettings program
      # gnome-bluetooth
      # gnome-clocks
      # gnome-color-manager
      # gnome-control-center
      # gnome-menus
      # gnome-shell-extensions
      # gnome-system-monitor
      # gtk3.out # for gtk-launch program
      # loupe
      # nautilus
      # nixos-background-info
      # seahorse # application for managing encryption keys and passwords in the GNOME Keyring
      # sushi # a quick previewer for Files (nautilus), the GNOME desktop file manager.
      # sysprof
      # xdg-user-dirs # Update user dirs as described in https://freedesktop.org/wiki/Software/xdg-user-dirs/
      # xdg-user-dirs-gtk # Used to create the default bookmarks
      baobab
      epiphany
      evince
      geary
      gnome-backgrounds
      gnome-calculator
      gnome-calendar
      gnome-characters
      gnome-connections
      # gnome-console
      gnome-contacts
      gnome-disk-utility
      gnome-font-viewer
      gnome-logs
      gnome-maps
      gnome-music
      gnome-software
      gnome-text-editor
      gnome-tour # GNOME Shell detects the .desktop file on first log-in.
      gnome-user-docs
      gnome-weather
      orca
      simple-scan
      snapshot
      totem
      yelp
    ];

  };
}
