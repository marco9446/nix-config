{ pkgs, ... }: {

  imports = [
    ../../homeManager/common.nix
    ../../homeManager/git.nix
    ../../homeManager/starship.nix
    # ../../homeManager/_xfce.nix
    ../../homeManager/zsh.nix
    ../../homeManager/vsCodium.nix
    ../../homeManager/yt-dlp.nix
  ];

  home.packages = with pkgs; [
    bambu-studio
  ];

  withWailand = true;

  # xfce_scaligFactor = 2;
  # xfce_cursorSize = 56;
  # xfce_dpi = 110;
}
