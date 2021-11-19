{ pkgs }:
with pkgs;

# Using west here is probably considered impure by nix as no
# hashes are checked by nix after downloading zephyr and its
# modules.
runCommand "zephyr" rec {
  version = "2.7.0";
  revision = "v${version}";
  url = "https://github.com/zephyrproject-rtos/zephyr";

  nativeBuildInputs = [
    python39
    python39Packages.west
    git
    cacert
  ];
} ''
  mkdir $out
  west init -m $url --mr $revision $out
  (cd $out && west update)
''