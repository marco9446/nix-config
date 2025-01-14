{ pkgs, ... }:

{
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
      vim = "nvim";
      code = "codium";
    };

    initExtra = ''      
      autoload -Uz compinit && compinit
      # TODO find way to use just UP and DOWN arrorw instead of CTRL+UP/DOWN arrow
      bindkey ';5A' history-search-backward 
      bindkey ';5B' history-search-forward 

      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
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
      {
        name = "fzf-tab";
        file = "fzf-tab.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "Aloxaf";
          repo = "fzf-tab";
          rev = "v1.1.2";
          sha256 = "Qv8zAiMtrr67CbLRrFjGaPzFZcOiMVEFLg1Z+N6VMhg=";
        };
      }
    ];
  };
}
