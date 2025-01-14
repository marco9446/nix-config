{ pkgs, config, lib, ... }:


{
  options = {
    withWailand = lib.mkOption {
      default = false;
      type = lib.types.bool;
    };
  };

  config = {
    home.packages = with pkgs; [
      nixd
      nixpkgs-fmt
    ];

    programs.vscode = {
      enable = true;
      package =
        if (config.withWailand) then
          pkgs.vscodium.override
            {
              commandLineArgs = "--enable-ozone --ozone-platform=wayland";
            }
        else pkgs.vscodium;
      extensions = with pkgs.vscode-extensions; [
        christian-kohler.path-intellisense
        jnoortheen.nix-ide
        vscode-icons-team.vscode-icons
        yzhang.markdown-all-in-one
      ];

      keybindings = [
        {
          key = "shift+alt+down";
          command = "editor.action.copyLinesDownAction";
          when = "editorTextFocus && !editorReadonly";
        }
        {
          key = "shift+alt+up";
          command = "editor.action.copyLinesUpAction";
          when = "editorTextFocus && !editorReadonly";
        }
        {
          key = "ctrl+s";
          command = "saveAll";
        }
      ];
      userSettings = {
        "diffEditor.ignoreTrimWhitespace" = false;
        "editor.fontFamily" = "'JetBrainsMono Nerd Font', 'JetBrains Mono', Consolas, 'Courier New', monospace";
        "editor.fontLigatures" = false;
        "editor.fontSize" = 12.5;
        "editor.fontWeight" = "400";
        "editor.formatOnSave" = true;
        "editor.lineHeight" = 1.5;
        "editor.linkedEditing" = true;
        "editor.minimap.enabled" = false;
        "editor.mouseWheelZoom" = true;
        "editor.renderWhitespace" = "trailing";
        "editor.stickyScroll.enabled" = true;
        "editor.suggestSelection" = "first";
        "editor.tabSize" = 2;
        "errorLens.fontStyleItalic" = true;
        "extensions.ignoreRecommendations" = true;
        "git.autofetch" = true;
        "git.confirmSync" = false;
        "git.enableSmartCommit" = true;
        "git.postCommitCommand" = "push";
        "markdown.extension.preview.autoShowPreviewToSide" = true;
        "markdown.extension.tableFormatter.normalizeIndentation" = true;
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nixd";
        "nix.serverSettings" = {
          "nixd" = {
            "formatting" = {
              "command" = [ "nixpkgs-fmt" ];
            };
            # FIXME it doesn't work, probably the path is wrong
            # "options" = {
            # // By default, this entriy will be read from `import <nixpkgs> { }`.
            # // You can write arbitary Nix expressions here, to produce valid "options" declaration result.
            # // Tip: for flake-based configuration, utilize `builtins.getFlake`
            # "nixos" = {
            #   "expr" = "(builtins.getFlake \"/home/marco/nix-config/flake.nix\").nixosConfigurations.lenovo-x1.options";
            # };
            # "home-manager" = {
            #   "expr" = "(builtins.getFlake \"/home/marco/nix-config/flake.nix\").homeConfigurations.marco.options";
            # };
            # };
          };
        };
        "terminal.integrated.fontFamily" = "'JetBrainsMono Nerd Font', 'JetBrains Mono', 'Fira Code' ,'Cascadia Code'";
        "terminal.integrated.fontWeight" = "normal";
        "terminal.integrated.lineHeight" = 1.1;
        "workbench.iconTheme" = "vscode-icons";
        "workbench.startupEditor" = "none";
      };
    };
  };
}
