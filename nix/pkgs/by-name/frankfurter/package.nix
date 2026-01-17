{
  lib,
  stdenv,
  makeWrapper,
  replaceVars,
  fetchFromGitHub,
  bundlerEnv,
  ruby_3_4,
  dataDir ? "/var/lib/frankfurter",
}:

# TODO bundix or whatever; ruby package
stdenv.mkDerivation (finalAttrs: {
  pname = "frankfurter";
  version = "1.0.0-unstable-2025-12-22";

  src = fetchFromGitHub {
    owner = "lineofflight";
    repo = "frankfurter";
    rev = "890e7e6adb7c05ada42fa18724d3d95f85d73ab8";
    hash = "sha256-FcTaAvqv+hs+TLcVnD9Wzn/RLjz+lYsLladWwqoJRP4=";
  };

  patches = [
    # sqlite otherwise tries to open a DB in read-only nix store path
    (replaceVars ./0001-change-sqlite-path.patch {
      inherit dataDir;
    })
  ];

  gems = bundlerEnv {
    name = "frankfurter-gems";
    ruby = ruby_3_4;
    gemdir = ./.;
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/share
    cp -r . $out/share/src
    makeWrapper ${finalAttrs.gems}/bin/bundle $out/bin/frankfurter \
      --add-flags "exec ${finalAttrs.gems}/bin/unicorn -c config/unicorn.rb" \
      --set PATH '"${finalAttrs.gems}/bin:$PATH"' \
      --chdir "$out/share/src"
    runHook postInstall
  '';

  # TODO experimental combinator or some update.sh is fine
  # remove junk in src Gemfile before lock and bundix
  # then nixfmt gemset.nix
  passthru.updateScript = { };

  meta = {
    description = "Currency data API";
    homepage = "https://github.com/lineofflight/frankfurter";
    changelog = "https://github.com/lineofflight/frankfurter/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "frankfurter";
    maintainers = with lib.maintainers; [ phanirithvij ];
    platforms = lib.platforms.unix;
  };
})
