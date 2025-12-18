{ lib, config, inputs, pkgs, ... }:
# cSpell:disable
{
  imports = [
    inputs.nixvim.nixosModules.nixvim
  ];
  options = {
    modules.nixVim.enable = lib.mkEnableOption "enable nixVim";
  };
  config = lib.mkIf config.modules.nixVim.enable {
    # plugin dependencies
    environment.systemPackages = with pkgs; [
      ripgrep
      nixpkgs-fmt # formats .nix
      prettier # js/ts/html/css
    ];

    programs.nixvim = {
      ############################################################
      # GENERAL Configuration
      ############################################################
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      termguicolors = true;
      globals.mapleader = " ";
      colorschemes.monokai-pro = {
        enable = true;
        settings = {
          filter = "octagon";
        };
      };
      completeopt = [ "menuone" "noselect" "noinsert" ];
      updatetime = 300;

      ############################################################
      # OPTIONS Configuration
      ############################################################
      opts = {
        # General settings
        encoding = "utf-8";
        fileencoding = "utf-8";
        mouse = "a";
        splitbelow = true;
        splitright = true;

        # Tabs
        tabstop = 2;
        shiftwidth = 2;
        softtabstop = 2;
        expandtab = true;
        shiftround = true;
        smartindent = true;

        # Line numbers
        number = true;
        relativenumber = false;
        wrap = false;
        cursorline = true;
        signcolumn = "yes";
        colorcolumn = "120";
        scrolloff = 5;
        sidescrolloff = 5;

        # Search
        ignorecase = true;
        smartcase = true;
        incsearch = true; # show matches as you type
        hlsearch = true; # keep search highlights

        # Swap and backup files
        swapfile = false;
        backup = false;
        writebackup = false;
        undofile = true;
        ruler = true; # Show line and column when searching

        # White space characters
        list = true;
        listchars = {
          tab = "▸ ";
          trail = "·";
          extends = "»";
          precedes = "«";
        };

        # Folding settings
        foldmethod = "indent";
        foldlevel = 99;
        foldenable = false;


        # System clipboard support, needs xclip/wl-clipboard
        clipboard = {
          providers = {
            wl-copy.enable = true; # Wayland 
            xsel.enable = true; # For X11
          };
          register = "unnamedplus";
        };
      };

      ############################################################
      # PLUGINS Configuration
      ############################################################
      plugins = {
        lsp = {
          enable = true;
          format.enable = true;
          servers = {
            ts_ls.enable = true;
            html.enable = true;
            cssls.enable = true;
            nixd = {
              enable = true;
              settings = {
                formatting = { command = [ "nixpkgs-fmt" ]; };
              };
            };
            yamlls.enable = true;
          };
        };
        gitsigns = {
          enable = true;
          settings = {
            attach_to_untracked = true;
            current_line_blame = false;
          };
        };
        telescope = {
          enable = true;
          settings = {
            defaults = {
              layout_config = { prompt_position = "top"; };
              sorting_strategy = "ascending";
            };
            pickers.find_files.hidden = true;
          };
          extensions."fzf-native" = {
            enable = true;
            settings = {
              fuzzy = true;
              override_file_sorter = true;
              override_generic_sorter = true;
              case_mode = "smart_case";
            };
          };
        };
        "indent-blankline" = {
          enable = true;
          settings = {
            indent = { char = "▏"; tab_char = "▏"; };
            scope = {
              enabled = true;
              show_start = true;
              show_end = false;
            };
          };
        };
        lualine.enable = true;
        nvim-autopairs.enable = true;
        comment.enable = true;
        web-devicons.enable = true;
      };

      ############################################################
      # KEY-MAPS Configuration
      ############################################################
      keymaps = [
        {
          key = ";";
          action = ":";
        }
        {
          mode = "n";
          key = "<leader>w";
          action = ":w<CR>";
          options.silent = true;
        }
        {
          mode = "n";
          key = "<leader>f";
          action = "<cmd>lua vim.lsp.buf.format({ async = true })<CR>";
          options.silent = true;
        }
        {
          mode = "n";
          key = "<leader>ff";
          action = "<cmd>Telescope find_files<CR>";
          options.silent = true;
        }
        {
          mode = "n";
          key = "<leader>fg";
          action = "<cmd>Telescope live_grep<CR>";
          options.silent = true;
        }
      ];
    };
  };
}
