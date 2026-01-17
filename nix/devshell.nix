{ pkgs, devshell }:
let
  python = pkgs.python3.withPackages (
    pp: with pp; [
      #(pkgs.callPackage ./pkgs/by-name/forex-python/package.nix { })
      requests
    ]
  );
  frankfurter = pkgs.callPackage ./pkgs/by-name/frankfurter/package.nix { };
in
devshell.mkShell {
  name = "tax-devshell";
  motd = ''

    {202}🔨 Welcome to tax-devshell{reset}

    See the Readme for instructions
    $(type -p menu &>/dev/null && menu)
  '';
  packages = [ python ];
  commands = [
    {
      package = frankfurter;
      category = "main";
    }
    {
      name = "tax";
      command = "python src/tax.py \"$@\"";
      help = "prints tax summary breakdown";
      category = "main";
    }
    {
      name = "update-flake";
      package = pkgs.writeShellScriptBin "update-flake" ''
        pushd nix/flake 1>/dev/null
        nix flake update --commit-lock-file --refresh
        popd 1>/dev/null
      '';
      help = "updates the flake and commit";
      category = "utilities";
    }
    {
      package = pkgs.gitnr;
      category = "utilities";
    }
    {
      package = pkgs.black;
      category = "formatter";
    }
    {
      package = pkgs.nixfmt;
      category = "formatter";
    }
  ];
}
