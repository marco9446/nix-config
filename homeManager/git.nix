{ pkgs, ... }:

{

  home.packages = with pkgs; [];

   # basic configuration of git
  programs.git = {
    enable = true;
    userName = "marco";
    userEmail = "marco@test.com";
  };

}