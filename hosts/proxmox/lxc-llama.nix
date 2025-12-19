{ pkgs, lib, ... }: {

  /* ------------------------------------------------------------------
   * 1️⃣  LXC container – GPU passthrough
   * ------------------------------------------------------------------
   *
   * In Proxmox’s LXC UI you must expose the GPU device(s) you want to use
   * inside the container.  The following lines are inserted into
   * /etc/pve/lxc/100.conf (or wherever your container is defined).
   *
   *   lxc.cgroup2.devices.allow:  c 226:128 rwm
   *   lxc.mount.entry:          /dev/dri dev/dri none bind,optional,create=dir
   *   lxc.mount.entry:          /dev/dri/renderD128 dev/dri/renderD128 none bind,optional,create=file
   *   lxc.cgroup2.devices.allow:  c 510:0   rwm
   *   lxc.mount.entry:          /dev/kfd dev/kfd none bind,optional,create=file
   *
   * 226:128 and 510:0 are the PCIe‑bus/slot numbers you found when
   * probing your GPU.  If you’re not sure, run `lspci` and look for
   * “GPU” in the output – the bus numbers are the two numbers after the
   * colon.  Feel free to tweak them to match your hardware.
   *
   * ------------------------------------------------------------------
   */

  imports = [
    ../../modules/defaultPveLxcConfig.nix
  ];

  # ------------------------------------------------------------------
  # 2️⃣  Hardware/Graphics
  # ------------------------------------------------------------------
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      rocmPackages.clr.icd
    ];
  };

  # ------------------------------------------------------------------
  # 3️⃣  System packages to test the GPU/ROCm stack
  # ------------------------------------------------------------------
  environment.systemPackages = with pkgs; [
    rocmPackages.rocm-smi #  GPU runtime
    rocmPackages.rocminfo #  Diagnostics
    htop #  Top‑level monitor
  ];


  # ------------------------------------------------------------------
  # 4️⃣  LXC‑container service – Llama‑CPP
  # ------------------------------------------------------------------
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
