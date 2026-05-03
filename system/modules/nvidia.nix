# ============================================
# NVIDIA CONFIGURATION — NixOS
# ============================================
# Hardware (confirmed):
#   GPU:  NVIDIA (NVreg, modesetting, Prime sync)
#   iGPU: AMD Radeon (amdgpuBusId PCI:5:0:0)
#   dGPU: NVIDIA    (nvidiaBusId  PCI:1:0:0)
#
# Mode: Prime Sync (both GPUs active, NVIDIA drives all outputs)
# Offload mode is disabled — sync gives better performance on this setup.

{ config, pkgs, ... }:

{
  # ── Kernel modules ────────────────────────────────────────────────────────
  boot.kernelModules = [
    "nvidia"
    "nvidia_modeset"
    "nvidia_uvm"
    "nvidia_drm"
  ];

  # ── Kernel parameters ─────────────────────────────────────────────────────
  boot.kernelParams = [
    "nvidia-drm.modeset=1"
    "nvidia-drm.fbdev=1" # eliminates boot flicker
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1" # suspend/resume stability
  ];

  # ── Graphics ──────────────────────────────────────────────────────────────
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # Steam / Wine / 32-bit Vulkan
  };

  # ── NVIDIA driver ─────────────────────────────────────────────────────────
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.latest;

    modesetting.enable = true;
    open = false; # use proprietary driver (better perf + compatibility)
    nvidiaSettings = true; # install nvidia-settings GUI tool
    nvidiaPersistenced = true; # keep GPU initialized — avoids cold-start latency

    powerManagement = {
      enable = false; # set true if you need suspend/resume on NVIDIA
      finegrained = false; # fine-grained power management (Turing+ only)
    };

    # ── Prime (hybrid graphics) ─────────────────────────────────────────────
    # Sync mode: NVIDIA drives all displays, AMD handles internal rendering bus.
    # Both GPUs are always on — best for a desktop-replacement / gaming laptop.
    # Switch to offload mode if you need battery life over performance.
    prime = {
      sync.enable = true;
      amdgpuBusId = "PCI:5:0:0";
      nvidiaBusId = "PCI:1:0:0";

      offload = {
        enable = false; # flip to true + sync.enable = false for offload mode
        enableOffloadCmd = false;
      };
    };
  };
}
