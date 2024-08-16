{self, ...}: {
  imports = [self.nixosModules.virt];
  virt.vfio = {
    enable = false;
    blacklistNvidia = false;
    vfioDevices = ["10de:13ba" "10de:1097" "10de:0fbc"];
  };

  users.users.qemu-libvirtd.group = "qemu-libvirtd";
  users.groups.qemu-libvirtd = {};
}
