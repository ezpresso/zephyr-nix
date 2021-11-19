# Zephyr OS nix shell

A simple nix shell for building firmware on Zephyr OS on ARM controllers.
The shell comes with Zephyr OS, west, ARM GCC toolchain, cmake, ninja, etc.

# Usage

Download Zephyr and all the requirements by entering a shell with flakes:

```console
$ nix develop
```

Or alternatively you can use the `nix.shell`:

```console
$ nix-shell
```

Now you can build the firmware for your board. For example the blinky sample
on the lpc55s69:

```console
west build -b lpcxpresso55s69_cpu0
west flash --runner pyocd
```

Note that `pyocd` is not installed in the nix shell.