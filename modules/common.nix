{ pkgs, inputs, ... }:

{

  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    wget
    git
    gparted
  ];
}
