{
  description = "Nix templates for language development";

  outputs =
    { ... }:
    let
      cmds = ''
        Initialise the shell with `nix develop` or `direnv`\
        which will provide the following commands:

        - `.sync`: installs all dependencies of the project
        - `.add`: adds new dependencies for the project
        - `.rem`: removes dependencies from the project
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

          ${cmds}
        '';
      };

      templates.python = {
        path = ./templates/python;
        description = "A development shell for python libraries";
        welcomeText = ''
          # Python development shell

          Python library development with `uv`, `ruff` and `pytest`.

          ${cmds}
        '';
      };
    };
}
