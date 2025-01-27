{self, ...}: {
  imports = [self.nixosModules.virt];
  virt.vfio = {
    enable = true;
    blacklistNvidia = false;
    vfioDevices = ["10de:13ba" "10de:1097" "10de:0fbc"];
  };

  users.users.qemu-libvirtd.group = "qemu-libvirtd";
  users.groups.qemu-libvirtd = {};

  networking.bridges = {
    br0 = {
      interfaces = ["eno2"];
    };
  };

  # get address from dhcp
  networking.interfaces."br0".useDHCP = true;
}
