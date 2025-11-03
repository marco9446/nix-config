{ modulesPath, ... }:

{
  imports = [
    (modulesPath + "/virtualisation/proxmox-image.nix")
  ];

  # Enable mDNS for `hostname.local` addresses
  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;
  services.avahi.publish = {
    enable = true;
    addresses = true;
  };

  # Some sane packages we need on every system
  # environment.systemPackages = with pkgs; [
  #   vim # for emergencies
  #   git # for pulling nix flakes
  # ];

  # Don't ask for passwords
  security.sudo.wheelNeedsPassword = false;

  system.stateVersion = "25.05";
}
