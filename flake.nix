{
  description = "fufexan's NixOS and Home-Manager flake";

  outputs = {nixpkgs, ...} @ inputs:
    inputs.flake-parts.lib.mkFlake {inherit (inputs) self;} {
      systems = ["x86_64-linux"];

      flake = {
        lib = import ./lib inputs;
        inherit (inputs.self.lib) pkgs;

        # standalone home-manager config
        inherit (import ./home/profiles inputs) homeConfigurations;

        # nixos-configs with home-manager
        nixosConfigurations = import ./hosts inputs;

        overlays.default = import ./pkgs inputs;
      };

      perSystem = {
        config,
        self',
        inputs',
        pkgs,
        system,
        ...
      }: {
        imports = [
          {
            _module.args.pkgs = inputs.self.pkgs.${system};
          }
        ];

        devShells.default = inputs'.devshell.legacyPackages.mkShell {
          packages = [
            pkgs.alejandra
            pkgs.git
            config.packages.repl
          ];
          name = "dots";
        };

        formatter = pkgs.alejandra;

        packages = inputs.self.overlays.default null pkgs;
      };
    };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    devshell.url = "github:numtide/devshell";

    eww = {
      url = "github:elkowar/eww";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rust-overlay.follows = "rust-overlay";
    };

    fu.url = "github:numtide/flake-utils";

    helix.url = "github:SoraTenshi/helix/experimental";

    hm = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    kmonad = {
      url = "github:kmonad/kmonad?dir=nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nil = {
      url = "github:oxalica/nil";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "fu";
      inputs.rust-overlay.follows = "rust-overlay";
    };

    nix-gaming.url = "github:fufexan/nix-gaming";

    nix-matlab = {
      url = "gitlab:doronbehar/nix-matlab";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-xilinx = {
      url = "gitlab:doronbehar/nix-xilinx";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "fu";
    };

    spicetify-nix = {
      url = "github:the-argus/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    waveforms-flake = {
      url = "github:liff/waveforms-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    webcord.url = "github:fufexan/webcord-flake";
  };
}
