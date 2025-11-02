{ pkgs, lib, ... }:

{
  imports = [
    pkgs.nixosModules.proxmox-image
    ./nixOS
    ./nixOS/proxmoxServices
  ];

  modules = {
    customConfig = {
      desktop = lib.mkDefault "none";
      userShell = lib.mkDefault pkgs.bash;
    };
    defaultPackages.enable = false;
    nvidia.enable = false;
    bluetooth.enable = false;
    nixVim.enable = true;
    tailscale.enable = lib.mkDefault false;
    homeManager.enable = false;
    ssh.enable = true;
    docker.enable = lib.mkDefault false;
    user.enable = true;
    nh.enable = true;
    adguard.enable = lib.mkDefault false;
  };

  # Enable mDNS for `hostname.local` addresses
  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;
  services.avahi.publish = {
    enable = true;
    addresses = true;
  };

  # Some sane packages we need on every system
  environment.systemPackages = with pkgs; [
    vim # for emergencies
    git # for pulling nix flakes
  ];

  # Don't ask for passwords
  security.sudo.wheelNeedsPassword = false;

  system.stateVersion = "25.05";
}
