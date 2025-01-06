{ pkgs, ... }:

{

  home.packages = with pkgs; [];

  programs.fzf.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      # Number of entries that are saved
      save = 100000;
      # Number of entries that are loaded
      size = 100000;
      ignoreAllDups = true;
      expireDuplicatesFirst = true;
    };

    shellAliases = {
      ll = "ls -l";
      update = "sudo nixos-rebuild switch";
    };

    initExtra = ''      
      autoload -U edit-command-line
      bindkey '^[[A' history-search-backward 
      bindkey '^[[B' history-search-forward 
    '';

    plugins = [
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.8.0";
          sha256 = "1lzrn0n4fxfcgg65v0qhnj7wnybybqzs4adz7xsrkgmcsr0ii8b7";
        };
      }
    ];
  };
}