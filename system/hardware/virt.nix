{ self, pkgs, ... }:
{
  imports = [ self.modules.virt ];
  virt.vfio = {
    enable = true;
    blacklistNvidia = false;
  };

  environment.systemPackages = [
    pkgs.spice-gtk
  ];

  security.wrappers.spice-client-glib-usb-acl-helper.source = "${pkgs.spice-gtk}/bin/spice-client-glib-usb-acl-helper";

  users.users.qemu-libvirtd.group = "qemu-libvirtd";
  users.groups.qemu-libvirtd = { };
  virtualisation.spiceUSBRedirection.enable = true;
}
