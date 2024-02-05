{inputs, ...}: {
  imports = [
    inputs.hm.nixosModules.default
    inputs.nur.hmModules.nur
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };
}
