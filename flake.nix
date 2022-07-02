{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:

  {

      homeConfigurations.michal = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
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
        };
      };
}
