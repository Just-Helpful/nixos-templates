# NixOS Templates

NixOS templates for development shells using a consistent set of commands.\
In all development shells the following commands are available:

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
