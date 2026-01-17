let
  flake-inputs = import (fetchTarball {
    url = "https://github.com/phanirithvij/flake-inputs/tarball/file-type"; # TODO tag
    sha256 = "sha256-4d2u5m8TOQMSt1uKlQiJ3zZgykQ+FiXn8VtyYaiAQfM=";
  });
  inherit (flake-inputs) import-flake;
in
{
  flake ? import-flake { src = ./nix/flake; },
  sources ? flake.inputs,
  nixpkgs ? sources.nixpkgs,
  overlays ? [ ],
  config ? { }, # allows --arg config from cli
  system ? builtins.currentSystem,
  pkgs ? import nixpkgs {
    inherit
      config
      overlays
      system
      ;
  },
  devshell ? import sources.devshell {
    nixpkgs = pkgs;
    inherit system;
  },
  # set to false when all outputs are needed
  # this is to avoid a root level shell.nix
  onlyShell ? true,
}:
let
  self = {
    shell = import ./nix/devshell.nix { inherit pkgs devshell; };
  };
in
if onlyShell then self.shell else self
