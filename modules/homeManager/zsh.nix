{ pkgs, lib, config, ... }:

{

  options = {
    homeModules.zsh.enable = lib.mkEnableOption "enable zsh";
  };
  config = lib.mkIf config.homeModules.zsh.enable {
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
        share = true;
      };
      historySubstringSearch = {
        enable = true;
        searchDownKey = "$terminfo[kcud1]";
        searchUpKey = "$terminfo[kcuu1]";
      };

      shellAliases = {
        ll = "ls -alhF";
        update = "nh os switch";
        h = "${pkgs.htop}/bin/htop";
        disk = "df | grep  '/$' | awk '{print $1}' | xargs df -H";
        lb = "lsblk -o +LABEL,UUID";
        nd = "nix develop -c $SHELL";
      };

      initContent = ''
        autoload -Uz compinit && compinit

        autoload -z edit-command-line
        zle -N edit-command-line
        bindkey "^E" edit-command-line

        zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
        zstyle ':completion:*' menu no
        zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
        zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

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
  };
}
