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

	ISOLINUX_BIN_ORIG="$(find "syslinux-${SYSLINUX_VERSION}" -name 'isolinux.bin' || die "could not find isolinux.bin")"
	log "using ISOLINUX: ${ISOLINUX_BIN_ORIG}"

	log "Copying to ${CD_ROOT}/${ISOLINUX_BOOT_DIR}/isolinux.bin ..."
	mkdir -p "${CD_ROOT}/${ISOLINUX_BOOT_DIR}"

	install -m 755 "${ISOLINUX_BIN_ORIG}" "${CD_ROOT}/${ISOLINUX_BOOT_DIR}/isolinux.bin" || die "Could not copy isolinux.bin"
}

verify_prereq()
{
	[ -d "${CD_ROOT}" ] || die "Missing CD_ROOT"
	[ -d "${CD_ROOT}/${ISOLINUX_BOOT_DIR}" ] || die "Missing ISOLINUX boot directory"
	[ -e "${CD_ROOT}/${ISOLINUX_BOOT_DIR}/isolinux.bin" ] || die "Missing isolinux.bin"
	[ -e "${ISOLINUX_CFG_ORIG}" ] || die "Missing isolinux.cfg"
}

make_isofs()
{
	ISOLINUX_BIN="${ISOLINUX_BOOT_DIR}/isolinux.bin"

	log "Copying ISOLINUX config ..."
	install -m 644 "${ISOLINUX_CFG_ORIG}" "${CD_ROOT}/${ISOLINUX_BOOT_DIR}/isolinux.cfg" || die "Could not copy isolinux.cfg"

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

verify_prereq

make_isofs

make_isofs_hybrid

die "TODO: copy config file for ISOLINUX ... "

log "${OUTPUT_ISO}: done!"
