{ pkgs, ... }:

{
  # basic configuration of git
  programs.git = {
    enable = true;
    userName = "marco";
    userEmail = "marco@test.com";
    extraConfig = {
      credential.helper = "${
          pkgs.git.override { withLibsecret = true; }
        }/bin/git-credential-libsecret";
    };
  };

}
