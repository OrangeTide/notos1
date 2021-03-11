## Makefile for NOTOS/1
# NOTE: sorry, you will need to use GNU make.

help :
	@echo "Usage:"
	@echo "  make all              Build everything."
	@echo "  make clean            Clean built files."
	@echo "  make clean-all        Clean intermediate files and built files."
	@echo "  make dist-clean       Clean downloaded files, and all artifacts above."
	@echo "  make run              Start the emulator (TODO)"
	@echo "  make test             Run the test suite"

all :: install.iso

.PHONY : all clean clean-all dist-clean test run help

install.iso :
	scripts/build-image-iso.sh

clean ::
	$(RM) install.iso

# TODO: share these version numbers between the makefile and script
clean-all :: clean
	$(RM) -r CD_root
	$(RM) -r syslinux-6.03

dist-clean :: clean-all
	$(RM) syslinux-6.03.tar.gz  syslinux-6.03.tar.sign
