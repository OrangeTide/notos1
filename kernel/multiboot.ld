OUTPUT_FORMAT(elf32-i386)
ENTRY(_multiboot_start)
SECTIONS
{
. = 0x00100000; /* 1M */

.text : ALIGN(4096) {
	KEEP(*(.text.multiboot))
	*(.text*)
	*(.rodata)
	}

.data : ALIGN(4096) {
	/* constructors ... */
	start_ctors = .;
	KEEP(*(.init_array));
	KEEP(*(SORT_BY_INIT_PRIORITY(.init_array.*)));
	end_ctors = .;

	*(.data)
}

.bss : ALIGN(4096) { *(.bss) }

/DISCARD/ : {
	*(.fini_array*)		/* destructors are never called */
	*(.comment)
	*(.eh_frame)
	*(.note.gnu.build-id)
	}
}
