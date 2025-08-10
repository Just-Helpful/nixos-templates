{
  description = "A development shell for python libraries";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
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
      rec {
        # packages wrapping cargo installation and building
        packages = {
          sync = pkgs.writeShellScriptBin ".sync" ''
            ${pkgs.uv}/bin/uv sync $@
          '';

          add = pkgs.writeShellScriptBin ".add" ''
            ${pkgs.uv}/bin/uv add $@
          '';

          rem = pkgs.writeShellScriptBin ".rem" ''
            ${pkgs.uv}/bin/uv remove $@
          '';

          build = pkgs.writeShellScriptBin ".build" ''
            ${pkgs.uv}/bin/uv build $@
          '';

          run = pkgs.writeShellScriptBin ".run" ''
            if [[ $# -eq 0 ]]; then
              ${pkgs.uv}/bin/uv run main
            else
              ${pkgs.uv}/bin/uv run $@
            fi
          '';

          test = pkgs.writeShellScriptBin ".test" ''
            ${pkgs.uv}/bin/uv run pytest $@
          '';

          lint = pkgs.writeShellScriptBin ".lint" ''
            ${pkgs.uv}/bin/uv run ruff check
          '';

          default =
            let
              manifest = (pkgs.lib.importTOML ./Cargo.toml).package;
            in
            pkgs.rustPlatform.buildRustPackage {
              pname = manifest.name;
              version = manifest.version;
              cargoLock.lockFile = ./Cargo.lock;
              src = pkgs.lib.cleanSource ./.;
            };
        };

        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.uv

            packages.sync
            packages.add
            packages.rem

            packages.build
            packages.run

            packages.test
            packages.lint
          ];

          shellHook = ''
            if [ ! -f ./pyproject.toml ]; then
              # Initialise and remove unused parts
              ${pkgs.uv}/bin/uv init
              rm ./.python-version

              # Pytest for testing
              .add pytest

              # Ruff for linting
              .add ruff
            fi
          '';
        };
      }
    );
}
