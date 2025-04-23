{
  description = "Declarative audio plugins on NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {nixpkgs, ...} @ inputs: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    packages.${system}.zebralette3-beta = pkgs.callPackage ./pkgs/zebralette3-beta.nix {};

    homeModules.default = import ./modules/configure-audio-plugins.nix;
  };
}
