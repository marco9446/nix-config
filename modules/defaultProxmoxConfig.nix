{ pkgs, modulesPath, lib, ... }:

{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
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
    tailscale.enable = false;
    homeManager.enable = false;
    ssh.enable = true;
    docker.enable = false;
    user.enable = true;
    nh.enable = true;
    adguard.enable = lib.mkDefault false;
  };

  # Enable QEMU Guest for Proxmox
  services.qemuGuest.enable = lib.mkDefault true;

  # Use the boot drive for grub
  boot.loader.grub.enable = lib.mkDefault true;
  boot.loader.grub.devices = [ "nodev" ];

  boot.growPartition = lib.mkDefault true;

  # Allow remote updates with flakes and non-root users
  nix.settings.trusted-users = [ "root" "@wheel" ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

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

  # Default filesystem
  fileSystems."/" = lib.mkDefault {
    device = "/dev/disk/by-label/nixos";
    autoResize = true;
    fsType = "ext4";
  };

  system.stateVersion = "25.05";
}
