{
  description = "Nix templates for language development";

  outputs =
    { ... }:
    let
      cmds = ''
        - `.init`: initialise the project
        - `.sync`: installs all dependencies of the project
        - `.add`: adds new dependencies for the project
        - `.del`: deletes dependencies from the project
        - `.build`: build an executable version of the project
        - `.run`: runs the executable for the project
        - `.test`: tests the project code
        - `.lint`: performs static checks on the project,\
          such as linting, formatting and dependency analyses
      '';
    in
    {
      templates.rust = {
        path = ./templates/rust;
        description = "A development shell for rust libraries";
        welcomeText = ''
          # Rust development shell

          Rust library development with `cargo`.

          Initialise the shell with `nix develop`\
          which will provide the following commands:

          ${cmds}
        '';
      };
    };
}
