{ stdenv, lib, ... }:

stdenv.mkDerivation rec {
  pname = "clipboard-pluggo";
  version = "0.1.0";

  src = ./.;

  meta = with lib; {
    description = "TODO: fill me in";
    homepage = "https://github.com/eraserhd/clipboard-pluggo";
    license = licenses.publicDomain;
    platforms = platforms.all;
    maintainers = [ maintainers.eraserhd ];
  };
}
