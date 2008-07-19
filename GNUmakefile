#=============================================================================


#=============================================================================
# Utilities
#=============================================================================

GENEXT2FS:=genext2fs
CP:=cp -v
MKDIR:=mkdir -v
GRUB_INSTALL:=grub-install
MKISOFS:=mkisofs
MKDOSFS:=mkdosfs

#=============================================================================
# Settings
#=============================================================================

DISK_SZ:=16384
FAT32_SZ:=8192
ROOTFS_SZ:=8192
FAT32_SECTOR_OFS:=1
ROOTFS_SECTOR_OFS:=16065

#=============================================================================
all : check disk.bin grub.iso

check :
	@[ -x "`which $(GENEXT2FS)`" ] || ( echo failed to find $(GENEXT2FS) ; false )
	@[ -x "`which $(MKISOFS)`" ] || ( echo failed to find $(MKISOFS) ; false )

clean :
	$(RM) fat32.img rootfs.img disk.bin grub.iso

clean-all : clean
	$(RM) -r rootfs/ grub-iso/

.PHONY : all clean clean-all check

#=============================================================================

disk.bin : fat32.img rootfs.img part-info.txt grub-bin/stage1 grub-bin/stage2
	dd if=/dev/zero of=$@ bs=1K count=$(DISK_SZ)
	sfdisk -H 255 -S 63 $@ <part-info.txt
	dd if=fat32.img of=$@ bs=512 conv=notrunc seek=$(FAT32_SECTOR_OFS)
	dd if=rootfs.img of=$@ bs=512 conv=notrunc seek=$(ROOTFS_SECTOR_OFS)

fat32.img :
	dd if=/dev/zero of=$@ bs=1K count=$(FAT32_SZ)
	$(MKDOSFS) -F 32 $@

rootfs.img : rootfs/
	$(GENEXT2FS) -b $(ROOTFS_SZ) -d $< $@ 

rootfs/ : 
	$(MKDIR) -p $@/
	touch $@/Files_go_here

grub.iso : grub-iso/ grub-iso/boot/grub/stage2_eltorito grub-bin/copyright.txt grub-bin/version.txt
	$(MKISOFS) -R -b boot/grub/stage2_eltorito -no-emul-boot -boot-load-size 4 -boot-info-table -copyright grub-bin/copyright.txt -V "$(shell cat grub-bin/version.txt)" -o $@ $<

grub-iso/ : grub-bin/stage2_eltorito menu.lst grub-bin/mars.xpm.gz
	$(MKDIR) -p $@/boot/grub/
	$(CP) $^ $@/boot/grub/

#=============================================================================
