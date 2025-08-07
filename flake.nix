{
  description = "Nix templates for language development";

  outputs =
    { ... }:
    let
      cmds = ''
        - `.init`: re-initialise the project

        - `.sync`: installs all dependencies of the project
        - `.add`: adds new dependencies for the project
        - `.del`: deletes dependencies from the project

        - `.build`: build an executable version of the project
        - `.run`: runs the executable for the project

        - `.test`: tests the project code
        - `.lint`: performs static linting on the project, such as:
          - linting
          - formatting
          - code coverage
          - dependency analysis
      '';
    in
    {
      templates.rust = {
        path = ./templates/rust;
        description = "A development shell for rust libraries";
        welcomeText = ''
          # Rust development shell

          Rust library development with `cargo`.

          This provides the following commands:
          ${cmds}
        '';
      };
    };
}
