{
  pkgs,
  lib,
  ...
}: {
  imports = [./hardware-configuration.nix];

  boot = {
    kernelPackages = lib.mkForce pkgs.linuxPackages_xanmod;
    kernelParams = [
      "quiet"
      "loglevel=3"
      "systemd.show_status=auto"
      "rd.udev.log_level=3"
      "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
    ];
    blacklistedKernelModules = ["nouveau"];
  };

  services.xserver.videoDrivers = ["nvidia"];

  hardware = {
    cpu.intel.updateMicrocode = true;

    enableRedistributableFirmware = true;
  };

  programs.hyprland.settings = {
    cursor = {
      no_hardware_cursors = true;
    };
    monitor = [
      "DP-3, preferred, 1920x0, 1"
      "DP-1, 1920x1080@240, 0x0, 1"
      "HDMI-A-1, preferred, -1080x0, 1, transform, 1"
    ];
  };

  networking.hostName = "desktopm";
  virtualisation.docker.enable = true;

  security.tpm2.enable = true;

  services = {
    pcscd.enable = true;

    # for SSD/NVME
    fstrim.enable = true;
  };

  fileSystems."/mnt/more" = {
    device = "/dev/disk/by-uuid/df92131a-70a2-46b4-a3f5-34953b2c321e";
    fsType = "ext4";
    options = [
      # If you don't have this options attribute, it'll default to "defaults"
      # boot options for fstab. Search up fstab mount options you can use
      "users" # Allows any user to mount and unmount
      "nofail" # Prevent system from failing if this drive doesn't mount
    ];
  };
}
