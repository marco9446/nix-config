{ ... }: {

  imports = [
    ../../homeManager/common.nix
    ../../homeManager/git.nix
    ../../homeManager/starship.nix
    ../../homeManager/xfce.nix
    ../../homeManager/zsh.nix
    ../../homeManager/vsCodium.nix
    ../../homeManager/bambu-studio.nix
    ../../homeManager/yt-dlp.nix
  ];

  xfce_scaligFactor = 2;

}
