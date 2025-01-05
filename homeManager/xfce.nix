{ config, pkgs, lib, ... }:

{

  home.packages = with pkgs; [
  ];


    # FIXXME: as of 2023-07-28 I had some issues with xfconf not
    # being able to set some options. While playing around and to my
    # astonishment, I found out that some xfce modules require a
    # leading slash for the options ("/saver/enabled" = true;) and
    # other modules don't require those leading slashes
    # ("general/workspace_count" = 4;). Therefore, I added "MUST
    # NOT" and "MUST" comments when a certain configuration did seem
    # to run through without causing this error message. This might
    # be considered as a bug and may change in future, I don't know
    # for now.

  xfconf.settings = {
    
    xfce4-session = {
    }; # xfce4-session

    xfwm4 = { # 2023-07-29: MUST NOT have leading slashes
        "general/workspace_count" = 3;
        "general/workspace_names" = [ "1" "2" "3" ];
        "general/borderless_maximize" = true;
        "general/click_to_focus" = false;
        "general/cycle_apps_only" = false;
        "general/cycle_draw_frame" = true;
        "general/cycle_hidden" = true;
        "general/cycle_minimized" = false;
        "general/cycle_minimum" = true;
        "general/cycle_preview" = true;
        "general/cycle_raise" = false;
        "general/cycle_tabwin_mode" = 0;
        "general/cycle_workspaces" = false;
        "general/double_click_action" = "maximize";  # Window Manager -> Advanced -> Double click action
        "general/double_click_distance" = 5;
        "general/double_click_time" = 250;
        "general/easy_click" = "Alt";
        "general/focus_delay" = 141;
        "general/focus_hint" = true;
        "general/focus_new" = true;
        "general/prevent_focus_stealing" = false;
        "general/raise_delay" = 250;
        "general/raise_on_click" = true;
        "general/raise_on_focus" = false;
        "general/raise_with_any_button" = true;
        "general/scroll_workspaces" = false;
        "general/snap_resist" = false;
        "general/snap_to_border" =   true;
        "general/snap_to_windows" = true;
        "general/snap_width" = 10;
        "general/theme" = "Adwaita-dark-Xfce";
        "general/tile_on_move" = true;
        "general/title_alignment" = "center";
        "general/title_font" = 9;
        "general/title_horizontal_offset" = 0;
        "general/title_shadow_active" = false;
        "general/title_shadow_inactive" = false;
        "general/toggle_workspaces" = false;
        "general/wrap_cycle" = false;
        "general/wrap_layout" = false;
        "general/wrap_resistance" = 10;
        "general/wrap_windows" = false;
        "general/wrap_workspaces" = false;
        "general/zoom_desktop" = true;
        "general/zoom_pointer" = true;
    }; # xfwm4
  };

}