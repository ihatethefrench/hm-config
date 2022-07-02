{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, home-manager, flake-utils, ... }:

  flake-utils.lib.eachDefaultSystem(system:
  let 
    pkgs = nixpkgsFor.${system};
  in 
  {
    devShells.${system}.default = pkgs.mkShell {
      buildInputs = with pkgs; [ nix-linter statix nixfmt ];
    };

    homeConfigurations.michal = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [ 
        ./michal/shell.nix 
        ./michal/dev.nix 
        ./michal/base.nix
        {
          home = {
            username = "michal";
            homeDirectory = "/home/michal";
          };
        }
      ];
    }
  );
}
