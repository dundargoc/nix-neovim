{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?rev=2f06be9f99f56275951d7b3a3f642608e2f90fe7";

    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay?rev=dad48e1edca040a68c51c1433606b57cfdf027dc";
  };

  outputs = { self, nixpkgs, neovim-nightly }:

    let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        config = { allowUnfree = true; };
        overlays = [ neovim-nightly.overlay ];
      };
    in rec {
      description = "Declaratively configure neovim with the magic of nix!";

      fromConfig = configuration:
        import ./default.nix { inherit pkgs configuration; };

      # For nix build
      defaultPackage."x86_64-linux" = fromConfig ./test.nix;

      # For nix run
      defaultApp."x86_64-linux" = {
        type = "app";
        program = "${self.defaultPackage."x86_64-linux"}/bin/nvim";
      };
    };
}
