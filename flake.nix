{
  description = "Zephyr OS application build environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = inputs@{ self, nixpkgs, flake-utils, ... }:
    let
      # The arm embedded toolchain is not available for i686-linux.
      systems = nixpkgs.lib.remove "i686-linux" flake-utils.lib.defaultSystems;
    in
      flake-utils.lib.eachSystem systems (
        system:
          let
            pkgs = import nixpkgs { inherit system; };
            unstable = import inputs.unstable { inherit system; };
            zephyr = (import ./zephyr.nix) { inherit pkgs; };
          in {
            devShell = pkgs.mkShell {
              buildInputs = with pkgs; [
                dtc
                gcc-arm-embedded
                ninja
                python39
                python39Packages.pyyaml
                python39Packages.pykwalify
                python39Packages.anytree
                python39Packages.pyelftools
                python39Packages.west
                # Current zephyr requires a minimum cmake version of v3.20.0
                unstable.cmake
                zephyr
              ];
              
              shellHook = ''
                export ZEPHYR_TOOLCHAIN_VARIANT=gnuarmemb
                export GNUARMEMB_TOOLCHAIN_PATH=${pkgs.gcc-arm-embedded}
                source ${zephyr}/zephyr/zephyr-env.sh
              '';
            };
          }
      );
}
