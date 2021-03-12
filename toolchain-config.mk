# Common configuration and rules go here

## Toolchain Configuration

# TODO: only use this for x86 targets
NASM = nasm
NASMFLAGS = -f elf32

LDFLAGS = -melf_i386

## Rules

# TODO: only use this for x86 targets
%.o : %.asm
	$(NASM) $(NASMFLAGS) $< -o $@
