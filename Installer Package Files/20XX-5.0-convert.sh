
#!/bin/sh
# This script created by shuall and DRGN
# Script version 1.2

version=5.0.0
sourceMd5="0e63d4223b01d9aba596259dc155a174"
modmd5="b67c7f8c107107b9db7e6d00a2b40817"

infile="$1"
outfile="SSBM, 20XXHP ${version}.iso"
delta="SSBM, 20XXHP ${version} patch (NTSC 1.02 base).xdelta"

# make sure you have these binaries installed somewhere
xdelta=xdelta3
md5sum=md5sum


checkhash () {
	printf "    This will take a few moments.... "
	filehash=$(${md5sum} -b "$1" |cut -d' ' -f1)
	if [ "$filehash" != "$2" ]; then
		printf "FAIL\n\n"
		printf "Hashes don't match. Continue? (y/n) "
		read cont;
		if [ "$cont" != "y" ]; then
			exit
		fi
	fi
	printf "SUCCESS\n\n"
}

build () {
	# Confirm that xdelta is installed
	if [ ! -n "`command -v $xdelta 2>/dev/null`" ] ; then
		echo >&2 "xdelta does not appear to be installed. Exiting script."
		exit 1
	fi

	# Check if there's an existing file, and whether the user wants to overwrite it
	if [ -f "$outfile" ]; then
		printf "File $outfile already exists. Overwrite? (y/n) "
		read overwrite
		if [ "$overwrite" != "y" ]; then
			exit
		fi
	fi

	# Build the new ISO
	printf "Constructing 20XXHP ${version}.\n"
	printf "    Please stand by.... "

	$xdelta -f -d -s "$infile" "$delta" "$outfile" 2>/dev/null
}

if [ "$infile" = "" ]; then
	printf "usage: 20xx-${version}-convert.sh FILE\n"
	exit
fi

printf "\nVerifying that the given file is a vanilla NTSC v1.02 copy of SSBM.\n"
checkhash "$infile" "$sourceMd5"
printf "The ISO has been verified!\n\n"


if build; then # Checks the exit code of build
	printf "SUCCESS\n\nConversion complete!\n\n"
else
	printf "FAIL\n\nThere was an error during the build process.\n\n"
	exit
fi

printf "Would you like to check the hash of your new 20XX copy? (y/n): "
read check;
if [ "$check" = "y" ]; then
	checkhash "$outfile" "$modmd5"
fi
