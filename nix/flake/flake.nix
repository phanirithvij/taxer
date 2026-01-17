{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  inputs.devshell.url = "github:numtide/devshell";
  inputs.devshell.inputs.nixpkgs.follows = "nixpkgs";

  outputs =
    inputs:
    let
      # TODO some code to iterate systems
      system = "x86_64-linux";
      default = import ./../.. {
        flake = inputs.self;
        inherit system;
        onlyShell = false;
      };
    in
    {
      devShells.${system}.default = default.shell;
    };
}
