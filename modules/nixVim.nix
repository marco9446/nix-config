{ lib, config, inputs, ... }:

{
  imports = [
    inputs.nixvim.nixosModules.nixvim
  ];
  options = {
    modules.nixVim.enable = lib.mkEnableOption "enable nixVim";
  };
  config = lib.mkIf config.modules.nixVim.enable {

    programs.nixvim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;

      colorschemes.vscode.enable= true;
      plugins={
        lualine.enable = true;
        nvim-autopairs.enable = true;
        comment.enable = true;
        treesitter.enable = true;
      };
      opts = {
        number = true; # Show line numbers
        relativenumber = false;

        # Always show the signcolumn, otherwise text would be shifted when displaying error icons
        signcolumn = "yes";

        # Enable mouse
        mouse = "a";

        # Search
        ignorecase = true;
        smartcase = true;

        # Tab defaults (might get overwritten by an LSP server)
        tabstop = 4;
        shiftwidth = 4;
        softtabstop = 0;
        expandtab = true;
        smarttab = true;

        # Save undo history
        undofile = true;

        # Highlight the current line for cursor
        cursorline = true;

        # Show line and column when searching
        ruler = true;

        # Start scrolling when the cursor is X lines away from the top/bottom
        scrolloff = 5;

        # System clipboard support, needs xclip/wl-clipboard
        clipboard = {
          providers = {
            wl-copy.enable = true; # Wayland 
            xsel.enable = true; # For X11
          };
          register = "unnamedplus";
        };
      };
    };
  };
}
