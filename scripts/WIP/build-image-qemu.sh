#!/bin/sh
##
# Environment Parameters:
#  DISK_SIZE
#
##

set -e

die() {
	echo "Fatal: $@"
	exit 1
}

########################################################################

TEMP_IMG=_tmp_disk_image
OUT_IMG=_disk_image.qcow2

########################################################################

create_blank_image_raw()
{
	echo "setting up disk image..."
	qemu-img create "${TEMP_IMG}" "${DISK_SIZE:-600}"m || die "could not create disk image"
}

convert_image_qemu()
{
	echo "setting up disk image..."
	qemu-img convert "${TEMP_IMG}" -O qcow2 "${OUT_IMG}" || die "could not compress disk image"
}

detect_utils()
{
	case "$(uname -s)" in
		"Linux")
			if [ -x "/sbin/mke2fs" ]; then
				MKE2FS="/sbin/mke2fs"
			else
				MKE2FS="mke2fs"
			fi
			;;
	esac
}

make_e2fs()
{
	case "$(uname -s)" in
		"OpenBSD")
			die "TODO: OpenBSD"
			;;
		"FreeBSD")
			die "TODO: FreeBSD"
			;;
		"Linux")
			"${MKE2FS}" -q -I 128 ${TEMP_IMG} || die "could not create filesystem"
			;;
	esac
}

########################################################################

detect_utils

create_blank_image_raw
make_e2fs

convert_image_qemu
