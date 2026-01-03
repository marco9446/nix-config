local wezterm = require 'wezterm'

-- wezterm.gui is not available to the mux server, so take care to
-- do something reasonable when this config is evaluated by the mux
function get_appearance()
  if wezterm.gui then
    return wezterm.gui.get_appearance()
  end
  return 'Dark'
end

function scheme_for_appearance(appearance)
  if appearance:find 'Dark' then
    return 'One Dark (Gogh)'
  else
    return 'One Light (base16)'
  end
end


return {
  -- -----------------------------------------------
  -- GENERAL
  -- -----------------------------------------------
  window_decorations = "NONE",
  window_close_confirmation = "NeverPrompt",
  hide_tab_bar_if_only_one_tab = true,
  font = wezterm.font("JetBrainsMono Nerd Font", {stretch="Normal", style="Normal"}),
  window_padding = {
    bottom = "1.5cell",
  },

  -- -----------------------------------------------
  -- COLORS
  -- -----------------------------------------------
  color_scheme = scheme_for_appearance(get_appearance()),

  -- -----------------------------------------------
  -- SHORTCUTS
  -- -----------------------------------------------
  keys = {
    -- Copy if selection is active, otherwise send Ctrl+C to the process
    {
      key = 'c',
      mods = 'CTRL',
      action = wezterm.action_callback(function(window, pane)
        local has_selection = window:get_selection_text_for_pane(pane) ~= ""
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
      action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
    },
    {
      key = 'v',
      mods = 'CTRL|SHIFT',
      action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
    }
  },
}
