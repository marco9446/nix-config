{ modulesPath, lib, host, ... }:
{
  # Import the Proxmox LXC virtualization module
  imports = [ (modulesPath + "/virtualisation/proxmox-lxc.nix") ];

  # Disable Nix sandboxing for compatibility with LXC containers
  nix.settings = {
    sandbox = false; # Sandbox is broken in LXC
    auto-optimise-store = true; # Automatically optimize the Nix store to save space
    keep-derivations = false; # Do not keep .drv files after builds (reduces disk usage)
    keep-outputs = false; # Do not keep build outputs unless needed
    max-jobs = 1; # Limit parallel builds to 1 (resource constraints in LXC)
    experimental-features = [ "nix-command" "flakes" ];
    warn-dirty = false;
  };

  # Proxmox LXC-specific options
  proxmoxLXC = {
    manageNetwork = false; # Let Proxmox handle network setup
    privileged = lib.mkDefault false; # Run container in privileged mode (required for some features)
  };

  # Disable fstrim service inside the container; Proxmox host will handle it
  services.fstrim.enable = false;
  services.getty.enable = false; # Disable getty; Proxmox console provides access
  services.udisks2.enable = false; # Disable disk management service (not needed in LXC)
  services.timesyncd.enable = false; # Disable time sync; host handles time
  services.dbus.enable = false; # Disable D-Bus system bus (reduces overhead)
  services.nscd.enable = false; # Disable name service cache daemon (not needed)

  # Configure journald to store logs in RAM only to reduce disk usage
  services.journald.extraConfig = ''
    Storage=volatile
    Compress=no
    SystemMaxUse=16M
  '';

  # Cache DNS lookups to improve performance in the container
  services.resolved = {
    extraConfig = ''
      Cache=true
      CacheFromLocalhost=true
    '';
  };

  # Strip unneeded locales and documentation:
  i18n.supportedLocales = [ "en_US.UTF-8/UTF-8" ]; # Only include US English locale
  documentation.enable = false; # Disable system documentation
  programs.man.enable = false; # Disable man pages
  environment.noXlibs = true; # Do not include X11 libraries (minimal footprint)

  nix.daemon.enable = false; # Disable Nix daemon (not needed in container)
  boot.tmpOnTmpfs = true; # Mount /tmp as tmpfs (RAM-backed)
  systemd.tmpfiles.rules = [ "d /tmp 1777 root root 1d" ]; # Ensure /tmp exists with correct permissions and is cleaned daily

  networking = {
    hostName = host;
  };

  # Enable and configure OpenSSH server
  users.users.root.password = ""; # Set empty root password (allows null password login if permitted)
  security.pam.services.sshd.allowNullPassword = true;
  services.openssh = {
    enable = true; # Enable SSH service
    openFirewall = true; # Open firewall for SSH
    settings = {
      PermitRootLogin = "yes"; # Allow root login via SSH
      PasswordAuthentication = true; # Enable password authentication
      PermitEmptyPasswords = "yes"; # Allow empty passwords (not secure)
    };
  };

  # Set the NixOS state version for compatibility
  system.stateVersion = "25.05";
}
