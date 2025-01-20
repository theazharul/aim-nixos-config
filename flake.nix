{
  description = "A very basic flake";

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

  };

  outputs = { self, nixpkgs }: {
	nixosConfigurations.nixos-powerhouse = nixpkgs.lib.nixosSystem {
	system = "x86_64-linux";
      		modules = [ ./configuration.nix ];
    	};

  };
}
