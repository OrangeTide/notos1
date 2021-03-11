#!/bin/sh

qemu-system-x86_64 -m 128M -cdrom install.iso -boot order=d
