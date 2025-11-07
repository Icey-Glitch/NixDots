{
  self,
  inputs,
  ...
}:
{
  nixpkgs = {
    config.allowUnfree = true;
    config.permittedInsecurePackages = [
      "electron-25.9.0"
      "qtwebengine-5.15.19"
    ];

    overlays = [
      inputs.nur.overlays.default
      (_final: prev: {
        lib = prev.lib // {
          colors = import "${self}/lib/colors" prev.lib;
        };
      })
    ];
  };
}
