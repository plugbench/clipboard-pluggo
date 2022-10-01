{
  description = "TODO: fill me in";
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils }:
    (flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        clipboard-pluggo = pkgs.callPackage ./derivation.nix {};
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
