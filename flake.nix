{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:

    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
    in {
      devShell = forAllSystems (system:
        let pkgs = nixpkgsFor.${system};
        in pkgs.mkShell {
          buildInputs = with pkgs; [ nix-linter statix nixfmt ];
        });

      homeConfigurations.michal = forAllSystems (system:
        let pkgs = nixpkgsFor.${system};
        in home-manager.lib.homeManagerConfiguration {
          configuration = { pkgs, lib, ... }: {
            imports = [ ./michal/shell.nix ./michal/dev.nix ./michal/base.nix ];
            progam.home-manager.enable = true;
          };
          homeDirectory = "/home/michal";
          username = "michal";
          system = "${system}";
          
          inherit pkgs;
        });
      };
}
