{
  description = "A development shell for rust libraries";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    naersk.url = "github:nixos-community/naersk/master";
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
        # packages wrapping cargo installation and building
        packages = {
          init = pkgs.writeShellScriptBin ".init" ''
            ${pkgs.rustup}/bin/rustup run stable cargo init --lib $@
          '';

          sync = pkgs.writeShellScriptBin ".sync" ''
            ${pkgs.rustup}/bin/rustup run stable cargo install $@
          '';

          add = pkgs.writeShellScriptBin ".add" ''
            ${pkgs.rustup}/bin/rustup run stable cargo add $@
          '';

          del = pkgs.writeShellScriptBin ".del" ''
            ${pkgs.rustup}/bin/rustup run stable cargo remove $@
          '';

          build = pkgs.writeShellScriptBin ".build" ''
            ${pkgs.rustup}/bin/rustup run stable cargo build $@
          '';

          run = pkgs.writeShellScriptBin ".run" ''
            ${pkgs.rustup}/bin/rustup run stable cargo run $@
          '';

          test = pkgs.writeShellScriptBin ".test" ''
            ${pkgs.rustup}/bin/rustup run stable cargo test $@
          '';

          lint = pkgs.writeShellScriptBin ".lint" ''
            ${pkgs.rustup}/bin/rustup run stable cargo check
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

        devShells.default =
          let
            inherit (self) packages;
          in
          pkgs.mkShell {
            packages = [
              packages.init
              packages.sync
              packages.add
              packages.del
              packages.build
              packages.run
              packages.test
              packages.lint
            ];

            shellHook = ''
              if [ ! -f ./Cargo.toml ]; then
                ${packages.init}/bin/.init
                ${packages.sync}/bin/.sync
              fi
            '';
          };
      }
    );
}
