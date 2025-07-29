{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      utils,
    }:
    utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShell = pkgs.mkShell {
          packages = with pkgs; [ rustup ];

          shellHook = ''
            rustup default stable &> /dev/null

            if [ ! -f ./Cargo.toml ]; then
              cargo init --lib
            fi
          '';
        };
      }
    );
}
