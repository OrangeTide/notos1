# NOTOS/1: Niv & OrangeTide OS

## Introduction

TODO - There is nothing here! So far it is only a build system for kernel development.

## Prerequisites

This programs must be installed on your system before proceeding:
 * GNU make
 * QEMU: specifically `qemu-system-x86_64`
 * curl

## Tools We Download & Use

These programs are automatically downloaded by the build and test scripts.

 * [SYSLINUX](https://wiki.syslinux.org/)

## Building

Possible build targets (output from `make help`):
```
Usage:
  make all              Build everything.
  make clean            Clean built files.
  make clean-all        Clean intermediate files and built files.
  make dist-clean       Clean downloaded files, and all artifacts above.
  make run              Start the emulator
  make test             Run the test suite
```

Easiest way to start is to launch the emulator:
```sh
make run
```

## Contributing

TODO: add guidelines for contributing:
 * Sending merge requests.
 * Filing bugs and feature requests.
 * Community chat and forum access.

## Development Notes

### References

 * [El Torito Boot](https://wiki.osdev.org/El-Torito)
 * [iBCS User Space Emulation](https://ibcs-us.sourceforge.io/)
 * [The Heirloom Project](http://heirloom.sourceforge.net/)
