{ buildGoModule
, Cocoa
, fetchFromGitHub
, lib
, libX11
, makeWrapper
, stdenv
}:

buildGoModule {
  pname = "clipboard-pluggo";
  version = "0.1.0";

  src = ./.;

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = lib.optional stdenv.isDarwin Cocoa ++ lib.optional (!stdenv.isDarwin) libX11;

  vendorSha256 = "OmtzQfirsDnR31vIy1nwrm0L3t83BvFyOJcCXsWroRw=";

  postInstall = lib.optional (!stdenv.isDarwin) ''
    wrapProgram $out/bin/clipboard \
      --prefix LD_LIBRARY_PATH : '${lib.makeLibraryPath [libX11]}'
  '';

  meta = with lib; {
    description = "Plugbench clipboard support";
    homepage = "https://github.com/plugbench/clipboard-pluggo";
    license = licenses.publicDomain;
    platforms = platforms.all;
    maintainers = [ maintainers.eraserhd ];
  };
}
