{ pkgs, lib, ... }: {
  /*
    you need to passthrough the GPU devices to the LXC container in proxmox ui
    to do so, add the following lines to the container's config file (e.g., /etc/pve/lxc/100.conf):
  
    lxc.cgroup2.devices.allow: c 226:128 rwm
    lxc.mount.entry: /dev/dri dev/dri none bind,optional,create=dir
    lxc.mount.entry: /dev/dri/renderD128 dev/dri/renderD128 none bind,optional,create=file
    lxc.cgroup2.devices.allow: c 510:0 rwm
    lxc.mount.entry: /dev/kfd dev/kfd none bind,optional,create=file
  */


  imports = [
    ../../modules/defaultPveLxcConfig.nix
  ];

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      rocmPackages.clr.icd
    ];
  };
  # Tools to verify GPU/ROCm functionality
  environment.systemPackages = with pkgs; [
    rocmPackages.rocm-smi
    rocmPackages.rocminfo
    htop
  ];
  # Define a group with GID 993 to match the host's /dev/kfd ownership
  users.groups.host-render = {
    gid = 993;
  };
  # Add ollama user to render/video groups for GPU access
  users.users.ollama = {
    extraGroups = [ "render" "video" "host-render" ];
  };

  services.ollama = {
    package = pkgs.ollama-rocm;
    enable = true;
    user = "ollama";
    # Optional: preload models, see https://ollama.com/library
    loadModels = [ ];
    # Radeon 890M is RDNA 3.5. 
    # 11.0.0 is the safest override.
    rocmOverrideGfx = "11.0.0";
    environmentVariables = {
      HSA_ENABLE_SDMA = "0"; # Fixes some APU/Container issues
      HSA_OVERRIDE_GFX_VERSION = "11.0.0"; # Force override in env as well
      HSA_AMD_SVM_SUPPORT = "0"; # Disable SVM, critical for some APUs in containers
      OLLAMA_KEEP_ALIVE = "10s"; # Unload model quickly to stop high idle GPU usage
      OLLAMA_DEBUG = "0"; 
    };
    openFirewall = true;
  };


  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "open-webui"
  ];
  services.open-webui = {
    enable = true;
    port = 80;
    host = "0.0.0.0";
    openFirewall = true;
    environment = {
      ANONYMIZED_TELEMETRY = "False";
      DO_NOT_TRACK = "True";
      SCARF_NO_ANALYTICS = "True";
      OLLAMA_API_BASE_URL = "http://127.0.0.1:11434";
      # Disable authentication
      WEBUI_AUTH = "False";
    };
  };

  # Allow open-webui to bind to privileged ports (like 80)
  systemd.services.open-webui.serviceConfig = {
    AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
    CapabilityBoundingSet = lib.mkForce [ "CAP_NET_BIND_SERVICE" ];
    # PrivateUsers often causes capability issues in unprivileged LXC containers
    PrivateUsers = lib.mkForce false;
  };
}
