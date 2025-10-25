{ lib, config, pkgs, ... }: {

  options = {
    homeModules.wezterm.enable = lib.mkEnableOption "enable wezterm";
  };

  config = lib.mkIf config.homeModules.wezterm.enable {
    home.packages = with pkgs; [ wezterm ];

    home.file.".config/wezterm/wezterm.lua".text = ''
      local wezterm = require 'wezterm'
      return {
        color_scheme = 'Monokai Pro (Gogh)',
        keys = {
          -- Copy if selection is active, otherwise send Ctrl+C to the process
          {
            key = 'c',
            mods = 'CTRL',
            action = wezterm.action_callback(function(window, pane)
              local has_selection = window:get_selection_text_for_pane(pane) ~= '''
              if has_selection then
                window:perform_action(wezterm.action.CopyTo 'Clipboard', pane)
                window:perform_action(wezterm.action.ClearSelection, pane)
              else
                window:perform_action(wezterm.action.SendKey { key = 'c', mods = 'CTRL' }, pane)
              end
            end),
          },
          -- Similarly for Ctrl+V (paste)
          {
            key = 'v',
            mods = 'CTRL',
            action = wezterm.action.PasteFrom 'Clipboard',
          },
          {
            key = 'h',
            mods = 'CTRL|SHIFT',
            action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
          },
          {
            key = 'v',
            mods = 'CTRL|SHIFT',
            action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
          },
        },
      }
    '';
  };
}
