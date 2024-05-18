{
  config,
  pkgs,
  self,
  ...
}: {
  imports = [self.nixosModules.virt];
  virt.vfio = {
    enable = true;
    blacklistNvidia = false;
    vfioDevices = [];
  };

  users.users.qemu-libvirtd.group = "qemu-libvirtd";
  users.groups.qemu-libvirtd = {};
}
