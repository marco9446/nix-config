{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nixd
    nixpkgs-fmt
  ];

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      yzhang.markdown-all-in-one
      jnoortheen.nix-ide
      christian-kohler.path-intellisense
      vscode-icons-team.vscode-icons
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
      "git.confirmSync" = false;
      "git.enableSmartCommit" = true;
      "markdown.extension.preview.autoShowPreviewToSide" = true;
      "markdown.extension.tableFormatter.normalizeIndentation" = true;
      "terminal.integrated.fontFamily" = "'JetBrainsMono Nerd Font', 'JetBrains Mono', 'Fira Code' ,'Cascadia Code'";
      "terminal.integrated.fontWeight" = "normal";
      "terminal.integrated.lineHeight" = 1.1;
      "workbench.iconTheme" = "vscode-icons";

      "nix.serverPath" = "nixd";
      "nix.enableLanguageServer" = true;
      "nix.serverSettings" = {
        "nixd" = {
          "formatting" = {
            "command" = [ "nixpkgs-fmt" ];
          };
        };
      };
    };
  };
}
