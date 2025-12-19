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
    enable32Bit = true;
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

  services.llama-cpp = {
    enable = true;
    # if this doesn't work, try llama-cpp-rocm
    package = pkgs.llama-cpp-rocm;
    port = 8080;
    model = "/var/lib/llama/models/OpenAI-20B-NEO-CODE-DI-Uncensored-Q5_1.gguf";
    openFirewall = true;
    host = "0.0.0.0";
    extraFlags = [
      # CPU
      "-t"
      "20" # leave headroom for ROCm runtime
      "--threads-batch"
      "20"

      # Context
      "-c"
      "4096"

      # GPU offload
      "-ngl"
      "35" # push close to full GPU residency
      "--batch-size"
      "512" # ROCm scales well with larger batches

      # Memory
      "--no-mmap" # critical in LXC + ROCm
      "--mlock" # avoid UMA eviction
      "--cont-batching"

      # Scheduling
      "--prio"
      "2"
    ];
  };

  systemd.services.llama-cpp = {
    # 1. Environment Variables for RDNA 3.5 Support
    environment = {
      # RDNA 3.5 → force RDNA 3
      HSA_OVERRIDE_GFX_VERSION = "11.0.0";

      # SDMA is unstable on APUs
      HSA_ENABLE_SDMA = "0";

      # Prevent UMA oversubscription stalls
      ROC_ENABLE_PRE_VEGA = "1";
      HSA_FORCE_FINE_GRAIN_PCIE = "1";

      # Explicit GPU selection
      HIP_VISIBLE_DEVICES = "0";

      # Reduce ROCm JIT latency
      AMD_COMGR_CACHE_DIR = "/var/cache/rocm";
    };

    serviceConfig = {
      DynamicUser = lib.mkForce false;
      User = "root";

      MemoryDenyWriteExecute = lib.mkForce false;
      PrivateDevices = lib.mkForce false;

      ProtectKernelTunables = lib.mkForce false;
      ProtectKernelModules = lib.mkForce false;
      ProtectControlGroups = lib.mkForce false;

      SystemCallFilter = lib.mkForce [ ];
    };
  };
}
