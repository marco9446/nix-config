{ pkgs, lib, config, nixOsConfig, ... }:

{
  options = {
    homeModules.xfce = {
      enable = lib.mkEnableOption "enable xfce";
      scalingFactor = lib.mkOption {
        default = 1;
        type = lib.types.int;
      };
      cursorSize = lib.mkOption {
        default = nixOsConfig.modules.customConfig.xcursorSize;
        type = lib.types.int;
      };
      fontSize = lib.mkOption {
        default = 11;
        type = lib.types.int;
      };
      dpi = lib.mkOption {
        default = -1;
        type = lib.types.int;
      };
    };
  };
  config = lib.mkIf config.homeModules.xfce.enable {

    home.packages = with pkgs; [
      xfce.xfce4-docklike-plugin
      xfce.xfce4-systemload-plugin
      nerd-fonts.jetbrains-mono
    ];

    xfconf.settings = {
      xsettings = {
        "Gtk/CursorThemeName" = "elementary";
        "Gtk/CursorThemeSize" = config.homeModules.xfce.cursorSize;
        "Gtk/FontName" = "Noto Sans Regular ${toString (config.homeModules.xfce.fontSize + 1)}";
        "Gtk/MonospaceFontName" = "JetBrainsMono Nerd Font ${toString (config.homeModules.xfce.fontSize + 1)}";
        "Gdk/WindowScalingFactor" = config.homeModules.xfce.scalingFactor;
        "Gtk/WindowScalingFactor" = config.homeModules.xfce.scalingFactor;
        "Net/IconThemeName" = "Flat-Remix-Blue-Dark";
        "Net/ThemeName" = "Adwaita-dark";
        "Xft/DPI" = config.homeModules.xfce.dpi;
      };

      xfce4-session = { }; # xfce4-session

      pointers = {
        "SynPS2_Synaptics_TouchPad/Acceleration" = 7.5;
        "SynPS2_Synaptics_TouchPad/ReverseScrolling" = true;
      };

      xfwm4 = {
        "general/button_layout" = "O|HMC"; # disable "shade"(S) button
        "general/mousewheel_rollup" = false;
        "general/move_opacity" = 80;
        "general/resize_opacity" = 80;
        "general/theme" = "Default";
        "general/title_font" = "Noto Sans Bold ${toString config.homeModules.xfce.fontSize}";
        "general/workspace_count" = 3;
        "general/workspace_names" = [ "1" "2" "3" ];
        "general/raise_with_any_button" = false;
      };

      xfce4-panel = {
        "panels" = [ 1 ];
        "panels/dark-mode" = true;
        "panels/panel-1/enable-struts" = true;
        "panels/panel-1/icon-size" = 16;
        "panels/panel-1/length" = 100.0;
        "panels/panel-1/plugin-ids" = [ 1 2 3 4 5 6 7 8 9 10 11 12 13 14 ];
        "panels/panel-1/position-locked" = true;
        "panels/panel-1/position" = "p=4;x=0;y=0";
        "panels/panel-1/size" = 36;

        # Application menu
        "plugins/plugin-1" = "applicationsmenu";
        "plugins/plugin-1/button-icon" = "start-here";
        "plugins/plugin-1/button-title" = "Start";
        "plugins/plugin-1/show-button-title" = true;
        "plugins/plugin-1/show-menu-icons" = true;

        # Separator
        "plugins/plugin-2" = "separator";
        "plugins/plugin-2/style" = 0;

        # Windows
        "plugins/plugin-3" = "docklike";

        # Separator
        "plugins/plugin-4" = "separator";
        "plugins/plugin-4/expand" = true;
        "plugins/plugin-4/style" = 0;

        # systemload
        "plugins/plugin-5" = "systemload";
        "plugins/plugin-5/swap/enabled" = false;
        "plugins/plugin-5/timeout-seconds" = 3;
        "plugins/plugin-5/uptime/enabled" = false;

        # Workspaces
        "plugins/plugin-6" = "pager";
        "plugins/plugin-6/miniature-view" = true;
        "plugins/plugin-6/rows" = 1;

        # Separator
        "plugins/plugin-7" = "separator";
        "plugins/plugin-7/style" = 0;

        # Pulse audio
        "plugins/plugin-8" = "pulseaudio";
        "plugins/plugin-8/enable-keyboard-shortcuts" = true;

        # Sys tray
        "plugins/plugin-9" = "systray";

        # Power manager
        "plugins/plugin-10" = "power-manager-plugin";

        # Notification
        "plugins/plugin-11" = "notification-plugin";

        # Clock
        "plugins/plugin-12" = "clock";
        "plugins/plugin-12/digital-layout" = 3; # time only
        "plugins/plugin-12/digital-time-font" = "Noto Sans Bold ${toString config.homeModules.xfce.fontSize}";
        "plugins/plugin-12/mode" = 2; # digital

        # Separator
        "plugins/plugin-13" = "separator";
        "plugins/plugin-13/style" = 0;

        # Show desktop
        "plugins/plugin-14" = "showdesktop";

      };


      xfce4-desktop = {
        "backdrop/single-workspace-mode" = false;
        "backdrop/single-workspace-number" = 3;
        "desktop-icons/file-icons/show-filesystem" = true;
        "desktop-icons/file-icons/show-home" = false;
        "desktop-icons/file-icons/show-removable" = true;
        "desktop-icons/file-icons/show-trash" = true;
        "desktop-icons/icon-size" = 42;
        "desktop-menu/show" = false;
      };


      xfce4-keyboard-shortcuts = {
        # apps
        "commands/custom/override" = true; # allow custom commands
        "commands/custom/Super_L" = "xfce4-appfinder";
      };

      xfce4-terminal = {
        "font-name" = "JetBrainsMono Nerd Font ${toString config.homeModules.xfce.fontSize}";
      };

    };

  };
}
