# ============================================
# NVIDIA HYBRID CONFIGURATION — MSI NixOS
# ============================================
# Hardware (confirmed):
#   GPU:  NVIDIA (NVreg, modesetting, PRIME offload)
#   iGPU: AMD Radeon (amdgpuBusId PCI:5:0:0)
#   dGPU: NVIDIA    (nvidiaBusId  PCI:1:0:0)
#
# Mode: AMD-primary with NVIDIA available on demand through PRIME offload.

{ config, pkgs, ... }:

{
  # ── Kernel modules ────────────────────────────────────────────────────────
  boot.kernelModules = [
    "nvidia"
    "nvidia_modeset"
    "nvidia_uvm"
    "nvidia_drm"
    "amdgpu"
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

  services.udev.extraRules = ''
    SUBSYSTEM=="drm", KERNEL=="card[0-9]*", ENV{ID_PATH_TAG}=="pci-0000_01_00_0", SYMLINK+="dri/nvidia-card"
    SUBSYSTEM=="drm", KERNEL=="card[0-9]*", ENV{ID_PATH_TAG}=="pci-0000_05_00_0", SYMLINK+="dri/amd-card"
  '';

  # ── NVIDIA driver ─────────────────────────────────────────────────────────
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    # Temporary proprietary-module fix for NVIDIA 610.57.04:
    # https://github.com/NVIDIA/open-gpu-kernel-modules/pull/1288
    package = config.boot.kernelPackages.nvidiaPackages.latest.overrideAttrs (_: {
      postPatch = ''
        substituteInPlace kernel/common/inc/nv-linux.h \
          --replace-fail \
            'static inline int __to_hwgpio(const struct gpio_device *gdev,' \
            'static inline int __to_hwgpio(struct gpio_device *gdev,'
      '';
    });

    modesetting.enable = true;
    open = false; # use proprietary driver (better perf + compatibility)
    nvidiaSettings = true; # install nvidia-settings GUI tool
    nvidiaPersistenced = false; # allow the offload GPU to suspend while idle

    powerManagement = {
      enable = true; # set true if you need suspend/resume on NVIDIA
      finegrained = true; # runtime-suspend the Turing+ GPU while unused
    };

    # ── Prime (hybrid graphics) ─────────────────────────────────────────────
    # AMD renders the desktop; use nvidia-offload for selected applications.
    prime = {
      sync.enable = false;
      amdgpuBusId = "PCI:5:0:0";
      nvidiaBusId = "PCI:1:0:0";

      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
    };
  };
}
