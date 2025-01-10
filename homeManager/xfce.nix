{ pkgs, ... }:

{

  home.packages = with pkgs; [
    xfce.xfce4-docklike-plugin
    xfce.xfce4-systemload-plugin
    nerd-fonts.jetbrains-mono
  ];

  gtk = {
    enable = true;
    # theme = {
    #   name = "Materia-dark-compact";
    #   package = pkgs.materia-theme;
    # };
    iconTheme = {
      name = "Flat-Remix-Blue-Dark";
      package = pkgs.flat-remix-icon-theme;
    };
    font = {
      name = "Noto Sans";
      package = pkgs.noto-fonts;
      size = 12;
    };
  };

  xfconf.settings = {
    xsettings = {
      "Net/ThemeName" = "Adwaita-dark";
      "Net/IconThemeName" = "Flat-Remix-Blue-Dark";
      "Gtk/CursorThemeName" = "elementary";
      "Gtk/CursorThemeSize" = 56;
      "Gtk/FontName" = "Noto Sans Regular 10";
      "Gtk/MonospaceFontName" = "NotoSansM Nerd Font 11";
      "Gtk/WindowScalingFactor" = 2;
    };

    xfce4-session = { }; # xfce4-session

    pointers = {
      "SynPS2_Synaptics_TouchPad/Acceleration" = 7.5;
      "SynPS2_Synaptics_TouchPad/ReverseScrolling" = true;
    };

    xfwm4 = {
      "general/button_layout" = "O|HMC"; # disable "shade"(S) button
      "general/theme" = "Default";
      "general/title_font" = "Noto Sans Bold 11";
      "general/mousewheel_rollup" = false;
      "general/move_opacity" = 80;
      "general/resize_opacity" = 80;
      "general/workspace_count" = 3;
      "general/workspace_names" = [ "1" "2" "3" ];
    };

    xfce4-panel = {
      "panels/dark-mode" = true;
      "panels" = [ 1 ];
      "panels/panel-1/icon-size" = 16;
      "panels/panel-1/size" = 36;
      "panels/panel-1/length" = 100.0;
      "panels/panel-1/position" = "p=4;x=0;y=0";
      "panels/panel-1/enable-struts" = true;
      "panels/panel-1/position-locked" = true;
      "panels/panel-1/plugin-ids" = [ 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15];
      # Application menu
      "plugins/plugin-1" = "applicationsmenu";
      "plugins/plugin-1/button-icon" = "start-here";
      "plugins/plugin-1/button-title" = "Start";
      "plugins/plugin-1/show-button-title" = true;
      "plugins/plugin-1/show-menu-icons" = true;
      # Separator
      "plugins/plugin-2" = "separator";
      "plugins/plugin-2/style" = 0; # transparent
      # Windows
      "plugins/plugin-3" = "docklike";
      # Separator
      "plugins/plugin-4" = "separator";
      "plugins/plugin-4/style" = 0; # transparent
      "plugins/plugin-4/expand" = true;

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
      "plugins/plugin-7/style" = 0; # transparent
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
      "plugins/plugin-12/mode" = 2; # digital
      "plugins/plugin-12/digital-time-font" = "Sans Bold 9";

      # Separator
      "plugins/plugin-13" = "separator";
      "plugins/plugin-13/style" = 0; # transparent
      # Show desktop
      "plugins/plugin-14" = "showdesktop";
      # Separator
      "plugins/plugin-15" = "separator";
      "plugins/plugin-15/style" = 0; # transparent
    };


    xfce4-desktop = {
      "desktop-icons/file-icons/show-filesystem" = true;
      "desktop-icons/file-icons/show-home" = false;
      "desktop-icons/file-icons/show-removable" = true;
      "desktop-icons/file-icons/show-trash" = true;
      "desktop-icons/icon-size" = 42;
      "desktop-menu/show" = false;
      "backdrop/single-workspace-mode" = false;
      "backdrop/single-workspace-number" = 3;
    };


    xfce4-keyboard-shortcuts = {
      # apps
      "commands/custom/override" = true; # allow custom commands
      "commands/custom/Super_L" = "xfce4-appfinder";
    };

    xfce4-terminal = {
      "font-name" = "JetBrainsMono Nerd Font 11";
    };

  };

}
