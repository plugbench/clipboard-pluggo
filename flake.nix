{
  description = "Plugbench clipboard support";
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils }:
    (flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        clipboard-pluggo = pkgs.callPackage ./derivation.nix {
          inherit (pkgs.darwin.apple_sdk.frameworks) Cocoa;
          inherit (pkgs.xorg) libX11;
        };
      in {
        packages = {
          default = clipboard-pluggo;
          inherit clipboard-pluggo;
        };
        checks = {
          test = pkgs.runCommandNoCC "clipboard-pluggo-test" {} ''
            mkdir -p $out
            : ${clipboard-pluggo}
          '';
        };
    })) // {
      overlays.default = final: prev: {
        clipboard-pluggo = prev.callPackage ./derivation.nix {};
      };
    };
}
