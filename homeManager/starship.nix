{ pkgs, ... }:

{
  # starship - an customizable prompt for any shell
  programs.starship = {
    enable = true;
    # custom settings
    settings = {
      add_newline = false;
      aws.disabled = true;
      gcloud.disabled = true;
      sudo.disabled = false;
      line_break.disabled = true;
    };
  };
}