{ buildGoModule
, Cocoa
, fetchFromGitHub
, lib
, libX11
, stdenv
}:

buildGoModule {
  pname = "clipboard-pluggo";
  version = "0.1.0";

  src = ./.;

  buildInputs = lib.optional stdenv.isDarwin Cocoa ++ lib.optional (!stdenv.isDarwin) libX11;

  vendorSha256 = "OmtzQfirsDnR31vIy1nwrm0L3t83BvFyOJcCXsWroRw=";

  meta = with lib; {
    description = "Plugbench clipboard support";
    homepage = "https://github.com/plugbench/clipboard-pluggo";
    license = licenses.publicDomain;
    platforms = platforms.all;
    maintainers = [ maintainers.eraserhd ];
  };
}
