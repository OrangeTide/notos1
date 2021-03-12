## Makefile for kernel

# build output

KERNEL_BIN = kernel.img
KERNEL_ELF = kernel.elf
KERNEL_OBJ = multiboot.o main.o

include ../toolchain-config.mk

CPPFLAGS += -Iinclude
CFLAGS += -m32 -fno-pie -ffreestanding -nostdinc -static
LDFLAGS += -static -nostdlib -T multiboot.ld

all :: $(KERNEL_BIN)
clean :: ; $(RM) $(KERNEL_BIN) $(KERNEL_ELF)
clean-all :: clean ; $(RM) $(KERNEL_OBJ)

$(KERNEL_ELF) : $(KERNEL_OBJ)
	$(LD) $(LDFLAGS) $^ $(LDLIBS) -o $@

$(KERNEL_BIN) : $(KERNEL_ELF)
	cp $< $@
	strip -s $@

check : $(KERNEL_BIN)
	grub-file --is-x86-multiboot $(KERNEL_BIN)
	objdump -h $(KERNEL_BIN)

dump : $(KERNEL_ELF)
	objdump -s $<
