{ lib, pkgs, ... }:

let
  enabledKernelOptions =
    lib.filter (option: option != null) (
      map
        (
          line:
          let
            match = builtins.match "CONFIG_([0-9A-Za-z_]+)=[ym]" line;
          in
          if match == null then null else builtins.head match
        )
        (lib.splitString "\n" (builtins.readFile pkgs.linux_latest.configfile))
    );

  deadKernelPrefixes = [
    # Wrong fixed platform vendors.
    "ACER"
    "ALIENWARE_"
    "ASUS_"
    "BACKLIGHT_"
    "BATTERY_"
    "BCMA"
    "CHARGER_"
    "CHROME_"
    "CRYPTO_DEV_"
    "CROS_"
    "DELL_"
    "DRM_"
    "DVB_"
    "EDAC_"
    "FUJITSU_"
    "GIGABYTE_"
    "GOOGLE_"
    "GPD_"
    "HP_"
    "HUAWEI_"
    "HW_RANDOM_"
    "IBM_"
    "IDEAPAD_"
    "IPMI_"
    "INTEL_"
    "JOYSTICK_"
    "KEYBOARD_"
    "LCD_"
    "LEDS_"
    "LENOVO_"
    "LG_"
    "MDIO_"
    "MOUSE_"
    "NVMEM_"
    "PANASONIC_"
    "REDMI_"
    "SAMSUNG_"
    "SERIO_"
    "SIEMENS_"
    "SONY"
    "SSB"
    "SURFACE_"
    "SYSTEM76_"
    "THINKPAD_"
    "TOUCHSCREEN_"
    "TOSHIBA_"
    "TUXEDO_"
    "UNIWILL_"
    "XIAOMI_"
    "YOGABOOK"

    # Chip farms behind shared frameworks that this MSI still needs.
    "DRM_BRIDGE_"
    "DRM_PANEL_"
    "GPIO_"
    "I2C_"
    "IIO_"
    "MEDIA_TUNER_"
    "MFD_"
    "NET_VENDOR_"
    "PHY_"
    "PINCTRL_"
    "PWM_"
    "RADIO_"
    "RC_"
    "REGULATOR_"
    "RTC_DRV_"
    "SENSORS_"
    "SND_AMD_"
    "SND_HDA_CODEC_"
    "SND_HDA_SCODEC_"
    "SND_SOC_"
    "SPI_"
    "VIDEO_"
  ];

  keptKernelPrefixes = [
    "DRM_AMD"
    "DRM_CLIENT"
    "DRM_DISPLAY_"
    "DRM_GEM_"
    "DRM_PANIC"
    "DRM_TTM"
    "LEDS_TRIGGER_"
    "TOUCHSCREEN_USB_"
  ];

  keptKernelOptions = [
    "BACKLIGHT_CLASS_DEVICE"
    "CRYPTO_DEV_CCP"
    "CRYPTO_DEV_CCP_CRYPTO"
    "CRYPTO_DEV_CCP_DD"
    "CRYPTO_DEV_SP_CCP"
    "CRYPTO_DEV_SP_PSP"
    "DRM_BUDDY"
    "DRM_DRAW"
    "DRM_EXEC"
    "DRM_FBDEV_EMULATION"
    "DRM_KMS_HELPER"
    "DRM_LOAD_EDID_FIRMWARE"
    "DRM_RAS"
    "DRM_SCHED"
    "DRM_SIMPLEDRM"
    "DRM_SUBALLOC_HELPER"
    "DRM_SYSFB_HELPER"
    "EDAC_AMD64"
    "EDAC_ATOMIC_SCRUB"
    "EDAC_DECODE_MCE"
    "EDAC_GHES"
    "EDAC_SUPPORT"
    "GPIO_ACPI"
    "GPIO_CDEV"
    "HW_RANDOM_AMD"
    "HW_RANDOM_TPM"
    "I2C_ALGOBIT"
    "I2C_BOARDINFO"
    "I2C_CHARDEV"
    "I2C_DESIGNWARE_CORE"
    "I2C_DESIGNWARE_PLATFORM"
    "I2C_HELPER_AUTO"
    "I2C_HID"
    "I2C_HID_ACPI"
    "I2C_HID_CORE"
    "I2C_PIIX4"
    "I2C_SMBUS"
    "INTEL_RAPL"
    "INTEL_RAPL_CORE"
    "JOYSTICK_IFORCE"
    "JOYSTICK_IFORCE_USB"
    "JOYSTICK_PXRC"
    "JOYSTICK_XPAD"
    "JOYSTICK_XPAD_FF"
    "JOYSTICK_XPAD_LEDS"
    "KEYBOARD_ATKBD"
    "KEYBOARD_GPIO"
    "LEDS_CLASS"
    "LEDS_CLASS_FLASH"
    "LEDS_CLASS_MULTICOLOR"
    "LEDS_GROUP_MULTICOLOR"
    "LEDS_TRIGGERS"
    "LEDS_USER"
    "MDIO_MVUSB"
    "MFD_CORE"
    "MOUSE_APPLETOUCH"
    "MOUSE_BCM5974"
    "MOUSE_SYNAPTICS_USB"
    "NET_VENDOR_REALTEK"
    "PHY_COMMON_PROPS"
    "PHY_PACKAGE"
    "PINCTRL_AMD"
    "RTC_DRV_CMOS"
    "SENSORS_K10TEMP"
    "SENSORS_SPD5118"
    "SERIO_I8042"
    "SERIO_LIBPS2"
    "SERIO_RAW"
    "SND_AMD_ACP_CONFIG"
    "SND_HDA_CODEC_ALC269"
    "SND_HDA_CODEC_GENERIC"
    "SND_HDA_CODEC_HDMI"
    "SND_HDA_CODEC_HDMI_ATI"
    "SND_HDA_CODEC_HDMI_GENERIC"
    "SND_HDA_CODEC_HDMI_NVIDIA"
    "SND_HDA_CODEC_HDMI_SIMPLE"
    "SND_HDA_CODEC_REALTEK"
    "SND_HDA_CODEC_REALTEK_LIB"
    "SND_HDA_SCODEC_COMPONENT"
    "SND_SOC_ACPI"
    "SND_SOC_AMD_ACP6x"
    "SND_SOC_AMD_YC_MACH"
    "SND_SOC_COMPRESS"
    "SND_SOC_DMIC"
    "SND_SOC_GENERIC_DMAENGINE_PCM"
    "TOUCHSCREEN_SUR40"
    "VIDEO_DEV"
  ];

  deadKernelOptions = [
    # Storage and buses absent from this chassis.
    "ATA"
    "ATA_OVER_ETH"
    "ACPI_NFIT"
    "DEV_DAX"
    "FS_DAX"
    "LIBNVDIMM"
    "MEMSTICK"
    "MMC"
    "MTD"
    "SCSI_FC_ATTRS"
    "SCSI_ISCSI_ATTRS"
    "SCSI_LOWLEVEL"
    "SCSI_SAS_ATTRS"
    "SCSI_SAS_LIBSAS"
    "SCSI_SPI_ATTRS"
    "SCSI_SRP_ATTRS"
    "SCSI_UFSHCD"

    "FPGA"
    "FSI"
    "GAMEPORT"
    "I3C"
    "IIO"
    "LCD2S"
    "NTB"
    "PLATFORM_MHU"
    "PWM"
    "SIOX"
    "SIOX_BUS_GPIO"
    "SPI"
    "STAGING"
    "TABLET_SERIAL_WACOM4"
    "W1"

    # Fixed controllers and test clients absent from this host.
    "PARPORT_PANEL"
    "PARPORT_PC"
    "PARPORT_SERIAL"
    "PPS_CLIENT_GPIO"
    "PPS_CLIENT_KTIMER"
    "PPS_CLIENT_PARPORT"
    "PPS_GENERATOR"
    "PPS_GENERATOR_DUMMY"
    "PPS_GENERATOR_TIO"
    "PTP_1588_CLOCK_FC3W"
    "PTP_1588_CLOCK_IDT82P33"
    "PTP_1588_CLOCK_IDTCM"
    "PTP_1588_CLOCK_MOCK"
    "PTP_1588_CLOCK_VMCLOCK"
    "PTP_NETC_V4_TIMER"

    # Keep the active AT/GPIO/HID paths and USB input devices.
    "INPUT_AD714X"
    "INPUT_AD714X_I2C"
    "INPUT_ADXL34X"
    "INPUT_ADXL34X_I2C"
    "INPUT_APANEL"
    "INPUT_ATLAS_BTNS"
    "INPUT_ATMEL_CAPTOUCH"
    "INPUT_AW86927"
    "INPUT_BMA150"
    "INPUT_CMA3000"
    "INPUT_CMA3000_I2C"
    "INPUT_DA7280_HAPTICS"
    "INPUT_DRV260X_HAPTICS"
    "INPUT_DRV2665_HAPTICS"
    "INPUT_DRV2667_HAPTICS"
    "INPUT_E3X0_BUTTON"
    "INPUT_GPIO_BEEPER"
    "INPUT_GPIO_DECODER"
    "INPUT_GPIO_ROTARY_ENCODER"
    "INPUT_GPIO_VIBRA"
    "INPUT_IDEAPAD_SLIDEBAR"
    "INPUT_IMS_PCU"
    "INPUT_IQS269A"
    "INPUT_IQS626A"
    "INPUT_IQS7222"
    "INPUT_KXTJ9"
    "INPUT_MMA8450"
    "INPUT_PCF8574"
    "INPUT_RAVE_SP_PWRBUTTON"
    "INPUT_REGULATOR_HAPTIC"

    # Preserve 8250 DesignWare for the firmware's AMDI0020 nodes.
    "SERIAL_8250_EXAR"
    "SERIAL_8250_KEBA"
    "SERIAL_8250_LPSS"
    "SERIAL_8250_MEN_MCB"
    "SERIAL_8250_MID"
    "SERIAL_8250_NI"
    "SERIAL_8250_PCI"
    "SERIAL_8250_PCI1XXXX"
    "SERIAL_8250_PCILIB"
    "SERIAL_8250_PERICOM"
    "SERIAL_ALTERA_JTAGUART"
    "SERIAL_ALTERA_UART"
    "SERIAL_ARC"
    "SERIAL_CONEXANT_DIGICOLOR"
    "SERIAL_FSL_LINFLEXUART"
    "SERIAL_FSL_LPUART"
    "SERIAL_IPOCTAL"
    "SERIAL_JSM"
    "SERIAL_LANTIQ"
    "SERIAL_LITEUART"
    "SERIAL_MEN_Z135"
    "SERIAL_MULTI_INSTANTIATE"
    "SERIAL_OF_PLATFORM"
    "SERIAL_RP2"
    "SERIAL_SC16IS7XX"
    "SERIAL_SC16IS7XX_I2C"
    "SERIAL_SCCNXP"
    "SERIAL_SIFIVE"
    "SERIAL_SPRD"
    "SERIAL_UARTLITE"
    "SERIAL_XILINX_PS_UART"

    "PCIE_CADENCE"
    "PCIE_CADENCE_HOST"
    "PCIE_CADENCE_PLAT"
    "PCIE_CADENCE_PLAT_HOST"
    "PCIE_MICROCHIP_HOST"
    "PCI_ENDPOINT_TEST"
    "PCI_HOST_GENERIC"
    "PCI_MESON"
    "PCI_PWRCTRL"
    "PCI_PWRCTRL_GENERIC"
    "PCI_PWRCTRL_TC9563"
    "PCI_SW_SWITCHTEC"

    "ALTERA_MSGDMA"
    "AMD_AE4DMA"
    "AMD_PTDMA"
    "AMD_QDMA"
    "DMABUF_SELFTESTS"
    "DMAPOOL_TEST"
    "DMATEST"
    "DW_AXI_DMAC"
    "DW_DMAC"
    "DW_DMAC_CORE"
    "DW_DMAC_PCI"
    "DW_EDMA"
    "DW_EDMA_PCIE"
    "FSL_EDMA"
    "HSU_DMA"
    "PLX_DMA"
    "QCOM_HIDMA"
    "QCOM_HIDMA_MGMT"
    "SF_PDMA"
    "SWITCHTEC_DMA"
    "XILINX_DMA"
    "XILINX_XDMA"
    "XILINX_ZYNQMP_DPDMA"

    # SP5100_TCO is the bound watchdog; retain software and USB watchdogs.
    "60XX_WDT"
    "ACQUIRE_WDT"
    "ADVANTECH_EC_WDT"
    "ADVANTECH_WDT"
    "ALIM1535_WDT"
    "ALIM7101_WDT"
    "CADENCE_WATCHDOG"
    "DW_WATCHDOG"
    "EBC_C384_WDT"
    "EUROTECH_WDT"
    "EXAR_WDT"
    "F71808E_WDT"
    "I6300ESB_WDT"
    "IB700_WDT"
    "IE6XX_WDT"
    "IT8712F_WDT"
    "IT87_WDT"
    "ITCO_WDT"
    "MACHZ_WDT"
    "MAX63XX_WATCHDOG"
    "MENZ069_WATCHDOG"
    "MEN_A21_WDT"
    "NIC7018_WDT"
    "NI903X_WDT"
    "PC87413_WDT"
    "PCIPCWATCHDOG"
    "RAVE_SP_WATCHDOG"
    "SBC_EPX_C3_WATCHDOG"
    "SBC_FITPC2_WATCHDOG"
    "SC1200_WDT"
    "SMSC37B787_WDT"
    "SMSC_SCH311X_WDT"
    "TQMX86_WDT"
    "VIA_WDT"
    "W83627HF_WDT"
    "W83877F_WDT"
    "W83977F_WDT"
    "WAFER_WDT"
    "WDAT_WDT"
    "XILINX_WATCHDOG"
    "ZIIRAVE_WATCHDOG"

    # Preserve AER, APEI, GHES and the ACPI paths bound on this MSI.
    "ACPI_APEI_EINJ"
    "ACPI_APEI_ERST_DEBUG"
    "ACPI_CMPC"
    "ACPI_CONFIGFS"
    "ACPI_IPMI"
    "ACPI_PFRUT"
    "ACPI_PROCESSOR_AGGREGATOR"
    "ACPI_QUICKSTART"
    "ACPI_SBS"

    # Production kernel: omit self-test and fault-injection modules.
    "KPROBE_EVENT_GEN_TEST"
    "MAILBOX_TEST"
    "PKCS7_TEST_KEY"
    "PREEMPTIRQ_DELAY_TEST"
    "RCU_REF_SCALE_TEST"
    "SCF_TORTURE_TEST"
    "SND_PCMTEST"
    "SND_TEST_COMPONENT"
    "TEST_LOCKUP"
    "TEST_POWER"
    "THERMAL_CORE_TESTING"
    "TORTURE_TEST"
    "TRACE_REMOTE_TEST"
    "USB_EHSET_TEST_FIXTURE"
    "USB_LINK_LAYER_TEST"
    "USB_TEST"
    "X86_AMD_PSTATE_UT"

    # This laptop is xHCI host-only; retain normal USB device classes.
    "THUNDERBOLT"
    "TPS6105X"
    "TYPEC_TBT_ALTMODE"
    "USB4"
    "USB_CDNS_SUPPORT"
    "USB_CHIPIDEA"
    "USB_DWC2"
    "USB_DWC3"
    "USB_EHCI_HCD"
    "USB_FOTG210_HCD"
    "USB_GADGET"
    "USB_HCD_BCMA"
    "USB_HCD_SSB"
    "USB_ISP116X_HCD"
    "USB_ISP1760"
    "USB_LGM_PHY"
    "USB_MUSB_HDRC"
    "USB_OHCI_HCD"
    "USB_R8A66597_HCD"
    "USB_SL811_HCD"
    "USB_UHCI_HCD"
    "USB_XHCI_PCI_RENESAS"
    "USB_XHCI_PLATFORM"

    # Keep UVC and CEC; remove broadcast, tuner, sensor and capture stacks.
    "DVB_CORE"
    "MEDIA_ANALOG_TV_SUPPORT"
    "MEDIA_CEC_RC"
    "MEDIA_DIGITAL_TV_SUPPORT"
    "MEDIA_PCI_SUPPORT"
    "MEDIA_PLATFORM_SUPPORT"
    "MEDIA_RADIO_SUPPORT"
    "MEDIA_SDR_SUPPORT"
    "MEDIA_TEST_SUPPORT"
    "RC_CORE"
    "V4L2_FLASH_LED_CLASS"
    "VIDEO_CAMERA_LENS"
    "VIDEO_CAMERA_SENSOR"
    "VIDEO_MAX96714"
    "VIDEO_MAX96717"

    # AMDGPU and the external NVIDIA driver are the only GPU paths.
    "DRM_ACCEL"
    "DRM_AST"
    "DRM_BOCHS"
    "DRM_BRIDGE"
    "DRM_CIRRUS_QEMU"
    "DRM_ETNAVIV"
    "DRM_GMA500"
    "DRM_GUD"
    "DRM_HISI_HIBMC"
    "DRM_KOMEDA"
    "DRM_LOGICVC"
    "DRM_MGAG200"
    "DRM_MIPI_DBI"
    "DRM_MIPI_DSI"
    "DRM_PANEL"
    "DRM_QXL"
    "DRM_SII902X"
    "DRM_UDL"
    "DRM_VGEM"
    "DRM_VIRTIO_GPU"
    "DRM_VKMS"
    "DRM_VMWGFX"

    # Fixed Ethernet is Realtek; preserve Wi-Fi, USB networking and VPNs.
    "6LOWPAN"
    "ARCNET"
    "ATALK"
    "BATMAN_ADV"
    "CAIF"
    "CAN"
    "FDDI"
    "HIPPI"
    "IEEE802154"
    "LAPB"
    "NET_DSA"
    "PHONET"
    "TIPC"
    "WAN"
    "X25"

    # KVM host support stays; physical-host guest drivers do not.
    "DRM_VBOXVIDEO"
    "HYPERVISOR_GUEST"
    "VBOXGUEST"
    "VBOXSF_FS"
    "VDPA"
    "VHOST_VDPA"
    "VIRTIO_MENU"
    "VMWARE_BALLOON"
    "VMWARE_PVSCSI"
    "VMWARE_VMCI"
    "VMWARE_VMCI_VSOCKETS"

    # The bound audio path is HDA plus AMD ACP6x/Yellow Carp.
    "SND_AC97_CODEC"
    "SND_AD1889"
    "SND_ALI5451"
    "SND_ALS300"
    "SND_ALS4000"
    "SND_ASIHPI"
    "SND_ATIIXP"
    "SND_ATIIXP_MODEM"
    "SND_AU8810"
    "SND_AU8820"
    "SND_AU8830"
    "SND_AW2"
    "SND_AZT3328"
    "SND_BT87X"
    "SND_CA0106"
    "SND_CMIPCI"
    "SND_CS4281"
    "SND_CS46XX"
    "SND_CS5530"
    "SND_CS5535AUDIO"
    "SND_CTXFI"
    "SND_DARLA20"
    "SND_DARLA24"
    "SND_ECHO3G"
    "SND_EMU10K1"
    "SND_EMU10K1X"
    "SND_ENS1370"
    "SND_ENS1371"
    "SND_ES1938"
    "SND_ES1968"
    "SND_FM801"
    "SND_GINA20"
    "SND_GINA24"
    "SND_HDSP"
    "SND_HDSPM"
    "SND_ICE1712"
    "SND_ICE1724"
    "SND_INDIGO"
    "SND_INDIGODJ"
    "SND_INDIGODJX"
    "SND_INDIGOIO"
    "SND_INDIGOIOX"
    "SND_INTEL8X0"
    "SND_INTEL8X0M"
    "SND_KORG1212"
    "SND_LAYLA20"
    "SND_LAYLA24"
    "SND_LOLA"
    "SND_LX6464ES"
    "SND_MAESTRO3"
    "SND_MIA"
    "SND_MIXART"
    "SND_MONA"
    "SND_NM256"
    "SND_OXYGEN"
    "SND_PCXHR"
    "SND_RIPTIDE"
    "SND_RME32"
    "SND_RME96"
    "SND_RME9652"
    "SND_SE6X"
    "SND_SIS7019"
    "SND_SOC_SOF_TOPLEVEL"
    "SND_SONICVIBES"
    "SND_TRIDENT"
    "SND_VIA82XX"
    "SND_VIA82XX_MODEM"
    "SND_VIRTUOSO"
    "SND_VX222"
    "SND_YMFPCI"
    "SOUNDWIRE"

    # Wrong fixed laptop/platform generations.
    "ADV_SWBUTTON"
    "AMD_3D_VCACHE"
    "AMD_HSMP"
    "AMD_HSMP_ACPI"
    "AMD_HSMP_PLAT"
    "AMD_ISP_PLATFORM"
    "APPLE_GMUX"
    "AYANEO_EC"
    "BARCO_P50_GPIO"
    "BITLAND_MIFS_WMI"
    "CHROME_PLATFORMS"
    "COMPAL_LAPTOP"
    "DASHARO_ACPI"
    "INSPUR_PLATFORM_PROFILE"
    "INT3406_THERMAL"
    "INT340X_THERMAL"
    "MEEGOPAD_ANX7428"
    "MERAKI_MX100"
    "MSI_LAPTOP"
    "MXM_WMI"
    "NVIDIA_WMI_EC_BACKLIGHT"
    "OXP_EC"
    "P2SB"
    "PCENGINES_APU2"
    "PORTWELL_EC"
    "SEL3350_PLATFORM"
    "SILICOM_PLATFORM"
    "SURFACE_PLATFORMS"
    "TC1100_WMI"
    "TOUCHSCREEN_DMI"
    "UV_SYSFS"
    "WINMATE_FM07_KEYS"
    "WIRELESS_HOTKEY"
    "X86_ANDROID_TABLETS"
    "XO15_EBOOK"
    "XO1_RFKILL"
    "YT2_1380"
    "X86_PMEM_LEGACY"

    # Legacy filesystems; retain common removable and recovery formats.
    "ADFS_FS"
    "AFFS_FS"
    "BEFS_FS"
    "BFS_FS"
    "CRAMFS"
    "EFS_FS"
    "EROFS_FS"
    "EXT2_FS"
    "F2FS_FS"
    "GFS2_FS"
    "JFS_FS"
    "MINIX_FS"
    "NILFS2_FS"
    "OCFS2_FS"
    "OMFS_FS"
    "QNX4FS_FS"
    "QNX6FS_FS"
    "SYSV_FS"
    "UFS_FS"
    "VXFS_FS"
    "ZONEFS_FS"

    # This host's zram is explicitly zstd-only.
    "ZRAM_BACKEND_842"
    "ZRAM_BACKEND_DEFLATE"
    "ZRAM_BACKEND_LZ4"
    "ZRAM_BACKEND_LZ4HC"
    "ZRAM_BACKEND_LZO"
    "ZRAM_MULTI_COMP"
    "ZRAM_WRITEBACK"
  ];

  deadKernelConfig =
    lib.genAttrs
      (
        lib.unique (
          deadKernelOptions
          ++ lib.filter
            (
              option:
              lib.any (prefix: lib.hasPrefix prefix option) deadKernelPrefixes
              && !(builtins.elem option keptKernelOptions)
              && !(lib.any (prefix: lib.hasPrefix prefix option) keptKernelPrefixes)
            )
            enabledKernelOptions
        )
      )
      (_: lib.mkForce lib.kernel.no);

  msiKernel = pkgs.linux_latest.override {
    # Parent cuts leave generic child options unused; verify requested symbols after updates.
    ignoreConfigErrors = true;
    structuredExtraConfig =
      (with lib.kernel; {
        NR_CPUS = lib.mkForce (freeform "12");

        DRM_I915 = lib.mkForce no;
        DRM_XE = lib.mkForce no;
        DRM_NOUVEAU = lib.mkForce no;
        DRM_RADEON = lib.mkForce no;
        FB_NVIDIA = lib.mkForce no;
        FB_RIVA = lib.mkForce no;
        DRM_AMDGPU_SI = lib.mkForce no;
        DRM_AMDGPU_CIK = lib.mkForce no;
        DRM_AMD_DC_SI = lib.mkForce no;

        KVM_INTEL = lib.mkForce no;
        HYPERV = lib.mkForce no;
        XEN = lib.mkForce no;
        MSI_EC = lib.mkForce no;

        ATM = lib.mkForce no;
        COMEDI = lib.mkForce no;
        CXL_BUS = lib.mkForce no;
        FIREWIRE = lib.mkForce no;
        FIREWIRE_NOSY = lib.mkForce no;
        GPIB = lib.mkForce no;
        INFINIBAND = lib.mkForce no;
        NFC = lib.mkForce no;
        NVME_TARGET = lib.mkForce no;
        PCCARD = lib.mkForce no;
        RAPIDIO = lib.mkForce no;

        BTRFS_FS = lib.mkForce no;
        CIFS = lib.mkForce no;
        NFS_FS = lib.mkForce no;
        XFS_FS = lib.mkForce no;

        WLAN_VENDOR_ADMTEK = lib.mkForce no;
        WLAN_VENDOR_ATH = lib.mkForce no;
        WLAN_VENDOR_ATMEL = lib.mkForce no;
        WLAN_VENDOR_BROADCOM = lib.mkForce no;
        WLAN_VENDOR_INTEL = lib.mkForce no;
        WLAN_VENDOR_INTERSIL = lib.mkForce no;
        WLAN_VENDOR_MARVELL = lib.mkForce no;
        WLAN_VENDOR_MICROCHIP = lib.mkForce no;
        WLAN_VENDOR_PURELIFI = lib.mkForce no;
        WLAN_VENDOR_QUANTENNA = lib.mkForce no;
        WLAN_VENDOR_RALINK = lib.mkForce no;
        WLAN_VENDOR_REALTEK = lib.mkForce no;
        WLAN_VENDOR_RSI = lib.mkForce no;
        WLAN_VENDOR_SILABS = lib.mkForce no;
        WLAN_VENDOR_ST = lib.mkForce no;
        WLAN_VENDOR_TI = lib.mkForce no;
        WLAN_VENDOR_ZYDAS = lib.mkForce no;
      })
      // deadKernelConfig;
  };
in
{
  boot.kernelPackages = pkgs.linuxPackagesFor msiKernel;

  # Temporary: expose the complete boot log while auditing this kernel.
  # Remove this block to restore the shared silent Plymouth boot unchanged.
  boot = {
    consoleLogLevel = lib.mkForce 7;
    initrd.availableKernelModules = lib.mkAfter [
      "atkbd"
      "hid_generic"
      "i8042"
      "usbhid"
    ];
    initrd.includeDefaultModules = false;
    initrd.verbose = lib.mkForce true;
    plymouth.enable = lib.mkForce false;
    kernelParams = lib.mkAfter [
      "loglevel=7"
      "ignore_loglevel"
      "rd.udev.log_level=info"
      "rd.systemd.show_status=true"
      "udev.log_priority=6"
      "systemd.show_status=true"
      "printk.devkmsg=on"
      "fbcon=vc:1-6"
    ];
  };
}
