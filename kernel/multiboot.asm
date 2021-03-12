bits 32

MULTIBOOT_PAGE_ALIGN equ (1<<0) ; align modules on page boundries
MULTIBOOT_MEMORY_INFO equ (1<<1) ; provide memory map
MULTIBOOT_VIDEO_MODE equ (1<<2) ; setup graphics mode

MULTIBOOT_MAGIC equ 0x1BADB002
HEADER_FLAGS equ (MULTIBOOT_PAGE_ALIGN | MULTIBOOT_MEMORY_INFO | MULTIBOOT_VIDEO_MODE) ; multiboot flags
; no graphics: HEADER_FLAGS equ (MULTIBOOT_PAGE_ALIGN | MULTIBOOT_MEMORY_INFO)
HEADER_CHECKSUM equ -(MULTIBOOT_MAGIC + HEADER_FLAGS)

MODE_TYPE equ 0 ; linear graphics = 0
WIDTH equ 320 ; 1024
HEIGHT equ 200 ; 768
DEPTH equ 32

align 8
section .text.multiboot:
	dd MULTIBOOT_MAGIC
	dd HEADER_FLAGS
	dd HEADER_CHECKSUM
	; ignored if MULTIBOOT_AOUT_KLUDGE not set ...
	dd 0 ; header_addr
	dd 0 ; load_addr
	dd 0 ; load_end_addr
	dd 0 ; bss_end_addr
	dd 0 ; entry_addr
	; used if MULTIBOOT_AOUT_KLUDGE set
	dd MODE_TYPE ; linear mode = 0
	dd WIDTH ; graphics width
	dd HEIGHT ; graphics height
	dd DEPTH ; 32bpp graphics mode

section .text:
extern kmain_multiboot

global _multiboot_start
_multiboot_start:
	; create a stack
	mov esp, stack_top

	; machine state:
	; EAX = 0x2BADB002
	; EBX = address of multiboot struct

	push ebx	; multiboot structure pointer
	push eax	; magic = 0x2BADB002

	cli
	call kmain_multiboot

	add esp, 8

; hang the system
	cli
.loop:
	hlt
	jmp .loop

; allocate stack in BSS
section .bss

scratch:
	resb 65536	; 64KB

global stack_start
global stack_top
stack_start:
	resb 16384	; 16KB stack
stack_top:
