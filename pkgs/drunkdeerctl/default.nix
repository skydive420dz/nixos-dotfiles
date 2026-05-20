{ writeShellApplication, python3 }:

writeShellApplication {
  name = "drunkdeerctl";
  runtimeInputs = [ python3 ];
  text = ''
    exec python3 ${./drunkdeerctl.py} "$@"
  '';
}
