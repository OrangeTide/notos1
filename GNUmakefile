#=============================================================================

GENEXT2FS:=genext2fs
CP:=cp -v
MKDIR:=mkdir -v
GRUB_INSTALL:=grub-install

#=============================================================================

DISK_SZ:=16384
ROOTFS_SZ:=8192
ROOTFS_SECTOR_OFS:=16065
GRUB_SECTOR_OFS:=0 	# TODO: put grub on first FAT partition instead

#=============================================================================
all : disk.bin

check :
	@[ -x `which $(GENEXT2FS)` ]

clean :
	$(RM) rootfs.img disk.bin

clean-all : clean
	$(RM) -r rootfs/

.PHONY : all clean clean-all check

#=============================================================================

disk.bin : rootfs.img part-info.txt grub-bin/stage1 grub-bin/stage2
	dd if=/dev/zero of=$@ bs=1K count=$(DISK_SZ)
	dd if=grub-bin/stage1 of=$@ bs=512 conv=notrunc seek=$(GRUB_SECTOR_OFS)
	dd if=grub-bin/stage2 of=$@ bs=512 conv=notrunc seek=$$(($(GRUB_SECTOR_OFS)+1)) 
	sfdisk -H 255 -S 63 $@ <part-info.txt
	dd if=rootfs.img of=$@ bs=512 conv=notrunc seek=$(ROOTFS_SECTOR_OFS)

rootfs.img : rootfs/
	$(GENEXT2FS) -b $(ROOTFS_SZ) -d $< $@ 

rootfs/ : grub-bin/stage1 grub-bin/stage2
	$(MKDIR) -p $@/boot/grub/
	$(CP) $^ $@/boot/grub/

#=============================================================================
