#!/bin/sh
##
# Environment Parameters:
#  DISK_SIZE
#
##

set -e
# DEBUG: set -x

die() {
	printf -- "\033[0;1;35mFatal: $*\033[0m\n"
	exit 1
}

log() {
	printf -- "\033[1m$*\033[0m\n"
}

########################################################################

OUTPUT_ISO="install.iso"

SYSLINUX_BASE_URL="https://mirrors.edge.kernel.org/pub/linux/utils/boot/syslinux"
SYSLINUX_VERSION=${SYSLINUX_VERSION:-"6.03"}
# Set to the signer of the syslinux tar
SYSLINUX_PUBLIC_KEYID="88AE647D58F7ABFE"

# directory containing filesystem
CD_ROOT="CD_root"

# path in CD_ROOT to install isolinux.bin and isolinux.cfg
ISOLINUX_BOOT_DIR="boot/isolinux"

# path to the configuration for ISOLINUX
ISOLINUX_CFG_ORIG="config/isolinux.cfg"

# path to a splash.png file for ISOLINUX
ISOLINUX_BOOT_SPLASH="assets/mars.png"

########################################################################

get_syslinux()
{
	# Skip if it appears syslinux has already been decompressed
	log "Checking if syslinux ${SYSLINUX_VERSION} is downloaded ..."
	if [ -d "syslinux-${SYSLINUX_VERSION}" ]; then
		return
	fi

	SYSLINUX_TAR_GZ="syslinux-${SYSLINUX_VERSION}.tar.gz"
	SYSLINUX_TAR_SIGN="syslinux-${SYSLINUX_VERSION}.tar.sign"

	if [ ! -e "${SYSLINUX_TAR_GZ}" -o ! -e "${SYSLINUX_TAR_SIGN}" ]; then
		curl -O "${SYSLINUX_BASE_URL}/${SYSLINUX_TAR_GZ}" -O "${SYSLINUX_BASE_URL}/${SYSLINUX_TAR_SIGN}" || die "could not download SYSLINUX"
	fi

	if ! gpg --list-keys "${SYSLINUX_PUBLIC_KEYID}" 2>/dev/null ; then
		log "Receiving public key ..."
		gpg --recv-keys "${SYSLINUX_PUBLIC_KEYID}" || die "could not find signing keyID for SYSLINUX"
	fi

	log "Checking signature ..."
	zcat "${SYSLINUX_TAR_GZ}" | gpg --verify  "${SYSLINUX_TAR_SIGN}" - || die "could not verify signature for SYSLINUX"

	log "Decompressing SYSLINUX ..."
	tar zxf "${SYSLINUX_TAR_GZ}" || die "could not decompress SYSLINUX"
}

install_isolinux()
{
	log "using ISOLINUX ${SYSLINUX_VERSION}"

	SYSLINUX_DIR="syslinux-${SYSLINUX_VERSION}"

	[ -d "${SYSLINUX_DIR}" ] || die "SYSLINUX not found"

	mkdir -p "${CD_ROOT}/${ISOLINUX_BOOT_DIR}"

	for f in "bios/core/isolinux.bin" "bios/com32/elflink/ldlinux/ldlinux.c32" "bios/com32/libutil/libutil.c32" "bios/com32/menu/menu.c32" "bios/com32/lib/libcom32.c32" "bios/com32/menu/vesamenu.c32" ; do
		b="$(basename "${f}")"
		log "Copying to ${CD_ROOT}/${ISOLINUX_BOOT_DIR}/${b} ..."
		install -m 644 "${SYSLINUX_DIR}/${f}" "${CD_ROOT}/${ISOLINUX_BOOT_DIR}/${b}" || die "Could not copy ${b}"
	done
}

verify_prereq()
{
	[ -d "${CD_ROOT}" ] || die "Missing CD_ROOT"
	[ -d "${CD_ROOT}/${ISOLINUX_BOOT_DIR}" ] || die "Missing ISOLINUX boot directory"
	[ -e "${CD_ROOT}/${ISOLINUX_BOOT_DIR}/isolinux.bin" ] || die "Missing isolinux.bin"
	[ -e "${ISOLINUX_CFG_ORIG}" ] || die "Missing isolinux.cfg"
	if [ -n "${ISOLINUX_BOOT_SPLASH}" ]; then
		[ -e "${ISOLINUX_BOOT_SPLASH}" ] || die "Missing splash.png"
	fi
}

copy_isolinux_config()
{
	log "Copying ISOLINUX config to ${CD_ROOT}/${ISOLINUX_BOOT_DIR}/isolinux.cfg ..."
	install -m 644 "${ISOLINUX_CFG_ORIG}" "${CD_ROOT}/${ISOLINUX_BOOT_DIR}/isolinux.cfg" || die "Could not copy isolinux.cfg"

	if [ -e "${ISOLINUX_BOOT_SPLASH}" ]; then
		log "Copying ISOLINUX boot splash graphic ..."
		install -m 644 "${ISOLINUX_BOOT_SPLASH}" "${CD_ROOT}/${ISOLINUX_BOOT_DIR}/splash.png" || die "Could not copy splash.png"
	fi
}

make_isofs()
{
	ISOLINUX_BIN="${ISOLINUX_BOOT_DIR}/isolinux.bin"

	case "$(uname -s)" in
		"Darwin")
			die "TODO: macOS untested"
			log "Creating CD/DVD bootable ISO image with ISOLINUX ..."
			# maybe Mac users would be better off using `homebrew` to install xorrisofs ?
			hdiutil makehybrid -o "${OUTPUT_ISO}" -iso -default-volume-name cidata -eltorito-boot "${ISOLINUX_BIN}" "${CD_ROOT}" || die "could not create ISO disk image"
			;;
		"Linux"|"FreeBSD"|"OpenBSD")
			log "Creating CD/DVD bootable ISO image with ISOLINUX ..."
			mkisofs -o "${OUTPUT_ISO}" -eltorito-boot "${ISOLINUX_BIN}" -c "boot/boot.cat" -no-emul-boot -boot-load-size 4 -boot-info-table -input-charset iso8859-1 -iso-level 1 "${CD_ROOT}" || die "could not create ISO disk image"
			;;
		*)
			die "Unsupported operating system"
			;;
	esac
}

make_isofs_hybrid()
{
	log "Creating USB bootable hybrid ISO ..."
	perl "syslinux-${SYSLINUX_VERSION}/bios/utils/isohybrid.pl" "${OUTPUT_ISO}" || die "could not isohybrid"
}

########################################################################

mkdir -p "${CD_ROOT}"

log "TODO: copy operating system files to ${CD_ROOT}"

get_syslinux

install_isolinux

verify_prereq

copy_isolinux_config

make_isofs

make_isofs_hybrid

log "${OUTPUT_ISO}: done!"
