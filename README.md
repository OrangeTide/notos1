# NotOS/1: Niv & OrangeTide OS

## Introduction

Operating system for security research on lightweight hardware and minimal environments.

## Dedication

This project is dedicated to the memory of [Jonathan Stuart 1983-2019](https://restincode.com/memorial.html?name=jonathanstuart).

## Prerequisites

This programs must be installed on your system before proceeding:
 * GNU make, bash, curl
 * a compiler configured for cross-compiling: GCC or LLVM/clang ([crosstool-ng](http://crosstool-ng.github.io/) or [doit](https://github.com/travisg/toolchains))
 * QEMU: specifically `qemu-system-x86_64`

### Setup: Ubuntu/Debian

TODO: describe how to get started

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

### Troubleshooting ISO Image Build

A few diagnostic utilities are freely available to aid in the troubleshooting of the ISO image.

Dump ISO details:
```sh
isoinfo -i install.iso -d
```

List ISO file contents:
```sh
isoinfo -i install.iso -f
```

### Configuring Continous Integration (CI)

[Web tool](https://config.travis-ci.com/explore) for linting `.travis.yml` file.

# Research

## References

 * [Multiboot 2 Specification](https://www.gnu.org/software/grub/manual/multiboot2/multiboot.html) and [Multiboot 1 Specification](https://www.gnu.org/software/grub/manual/multiboot/multiboot.html)
 * [El Torito Boot](https://wiki.osdev.org/El-Torito)
 * [iBCS User Space Emulation](https://ibcs-us.sourceforge.io/)
 * [The Heirloom Project](http://heirloom.sourceforge.net/)
 * [Graphical User Interface Gallery](http://toastytech.com/guis/index.html)
 * [GCC Cross-Compiler Build Guide](https://wiki.osdev.org/GCC_Cross-Compiler#The_Build)

## Design Papers

 * [Lexical File Names in Plan 9 or Getting Dot-Dot Right](https://9p.io/sys/doc/lexnames.html)
 * [The Use of Name Spaces in Plan 9](https://9p.io/sys/doc/names.html)

## Other Operating Systems

 * [xv6](https://pdos.csail.mit.edu/6.828/2020/xv6.html) - Unix-like teaching operating system
 * [LittleKernel/LK](https://github.com/littlekernel/lk)
 * [ToaruOS](https://toaruos.org/)
 * [SerenityOS](http://serenityos.org/)
 * [Contiki](https://github.com/contiki-os/contiki)
 * [FUZIX](http://fuzix.org/)
 * [COHERENT](http://www.nesssoftware.com/home/mwc/) - Unix clone produced by Mark Williams Company in the 1980's and 1990's.
 * [NewOS](http://newos.org/)
 * [VSTa / Valencia Simple Tasker](http://sources.vsta.org:7100/vsta/index)
 * [Plan 9 from Bell Labs](https://9p.io/plan9/)
 * [Inferno](http://www.vitanuova.com/inferno/)
 * [TempleOS](https://templeos.org/)
 * [Collapse OS](https://collapseos.org/)
 * [codezero microkernel](https://github.com/jserv/codezero)
 * [LμKOS](https://jacobncalvert.com/2020/06/02/kernel-series-introducing-l%CE%BCkos-the-learning-microkernel-operating-system/)
 * [Horizon Microkernel](https://github.com/wquist/Horizon-Microkernel)
 * [Qubes OS](https://www.qubes-os.org/) - VM based OS with a focus on secure architecture

### Hobby Operating Systems

 * [ChaiOS](https://github.com/ChaiSoft/ChaiOS)
 * [jatos](https://github.com/0x1C1B/jatos)
 * [GRUB invaders](http://www.erikyyy.de/invaders/) ([alternate](https://www.coreboot.org/GRUB_invaders))
 * [Multiboot Basic Graphics](https://github.com/Slapparoo/MultibootBasicGraphics)
 * [mOS](https://github.com/MQuy/mos)
 * [JehanneOS](https://github.com/JehanneOS/jehanne)
 * [YayOS](https://github.com/notYuriy/YayOS)
 * [CPL-1](https://github.com/CPL-1/CPL-1)
 * [Desparity](https://github.com/avcado/desparity)
 * [boros](https://github.com/zid/boros)
 * [gramado](https://github.com/frednora/gramado)
 * [Cyjon](https://github.com/Blackend/Cyjon/)
 * [MollenOS](https://github.com/meulengracht/mollenos)
 * [bedrock-os](https://github.com/AkosMaster/bedrock-os)
 * [Skeles](https://github.com/RMuskovets/Skeles)
 * [BeeOs](https://github.com/davxy/beeos)
 * [Odyssey](https://github.com/aweeraman/odyssey)
 * [LearnOS](https://github.com/dhavalhirdhav/LearnOS)
 * [LF OS](https://praios.lf-net.org/littlefox/lf-os_amd64)
 * [MushOS](https://github.com/pseusys/MushOS)

## Interesting Tools and Environments

 * [The MGR Window System](https://hack.org/mc/mgr/)
 * [OpenGEM](http://www.opendawn.com/opengem/) and [OpenGEM SDK](https://sourceforge.net/projects/opengem/)
 * [FreeGEM distribution](https://www.owenrudge.net/GEM/)
 * [Xynth Windowing System](https://github.com/alperakcan/xynth)
 * [BOOTBOOT](https://wiki.osdev.org/BOOTBOOT) - Alternative to GRUB and SYSLINUX
 * [Raspberry Pi Vulkan Driver for Pi3 and earlier](https://github.com/Yours3lf/rpi-vk-driver) - NVIDIA engineer made a proof-of-concept Vulkan implementation as a hobby project
 * [YAMS](https://github.com/Sporesirius/YAMS) - Yet Another Multiboot System

## Learning, Tutorials, and Guides

 * [Lions Commentary on the Sixth Edition UNIX Operating System](http://www.lemis.com/grog/Documentation/Lions/)
 * [OS Dev wiki](https://wiki.osdev.org/Main_Page)
 * [Creating a 64-bit kernel](https://wiki.osdev.org/Creating_a_64-bit_kernel)
 * [Simple multiboot compliant kernel](https://github.com/dzeban/hello-kernel)
 * [Rendezvous (Plan 9)](https://en.wikipedia.org/wiki/Rendezvous_(Plan_9))
   * [Process Sleep and Wakeup on Shared-memory Multiprocessor](http://doc.cat-v.org/plan_9/4th_edition/papers/sleep)
 * [Slide presentation for Microkernel Design](https://www.slideshare.net/microkerneldude/microkernel-design-39740042)
 * [Multiboot on OSDev Wiki](https://wiki.osdev.org/Multiboot)
 * [Bare Bones](https://wiki.osdev.org/Bare_Bones)
 * [Developing an Operating System](http://learnitonweb.com/tag/operating-system/)
 * [x86 Bare Metal Examples](https://github.com/cirosantilli/x86-bare-metal-examples)
