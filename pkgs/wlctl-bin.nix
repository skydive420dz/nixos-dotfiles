{
  fetchurl,
  lib,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation rec {
  pname = "wlctl";
  version = "0.1.6";

  src = fetchurl {
    url = "https://github.com/aashish-thapa/wlctl/releases/download/v${version}/wlctl-x86_64-unknown-linux-musl";
    hash = "sha256-7gJ2QqLXauP7GRAU7/Euw4O3HRWw3T8bx7I/otTf4aA=";
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 "$src" "$out/bin/wlctl"
    runHook postInstall
  '';

  meta = {
    description = "TUI wireless manager";
    homepage = "https://github.com/aashish-thapa/wlctl";
    license = lib.licenses.mit;
    mainProgram = "wlctl";
    platforms = [ "x86_64-linux" ];
  };
}
