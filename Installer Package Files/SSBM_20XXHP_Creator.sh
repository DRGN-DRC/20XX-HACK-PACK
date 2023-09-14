
#!/bin/sh
# This script created by shuall, phonos, DRGN, and Mage
# Script version 3.0

version=5.0.2
sourceMd5="0e63d4223b01d9aba596259dc155a174"
modmd5="d926ba5b39551f5245fd655bc1dfeb3f"

infile="$1"
outfile="SSBM, 20XXHP ${version}.iso"
delta="SSBM, 20XXHP ${version} patch.xdelta"


# make sure you have these binaries installed somewhere
xdelta=xdelta3
md5sum=md5sum

# Package managers for auto installing dependencies
APT_GET_CMD=$(which apt-get 2>/dev/null)  # Debian/Ubuntu
DNF_CMD=$(which dnf 2>/dev/null)          # Fedora/RHEL
PACMAN_CMD=$(which pacman 2>/dev/null)    # Arch

checkhash () {
	printf "    This will take a few moments.... "
	filehash=$(${md5sum} -b "$1" |cut -d' ' -f1)
	if [ "$filehash" != "$2" ]; then
		return 1
	fi
	return 0
}

build () {
	# Confirm that xdelta is installed
	if [ ! -n "`command -v $xdelta 2>/dev/null`" ] ; then
		echo >&2 "xdelta does not appear to be installed. Attempting to install now."
		# apt-get
		if [[ ! -z $APT_GET_CMD ]]; then
			echo >&2 "apt-get detected."
			echo -n "Run sudo apt-get install $xdelta? (y/N): "
			read check;
			if [ "$check" = "y" ]; then
				echo >&2 "Running sudo apt-get install $xdelta..."
				sudo apt-get -y -qq install $xdelta 2>/dev/null
			else
				echo >&2 "xdelta not installed. Exiting..."
				exit 1;
			fi
		# dnf
 		elif [[ ! -z $DNF_CMD ]]; then
 			echo >&2 "dnf detected."
			echo -n "Run sudo dnf install xdelta? (y/N): "
			read check;
			if [ "$check" = "y" ]; then
				echo >&2 "Running sudo dnf install xdelta..."
 				sudo dnf install -y -q xdelta 2>/dev/null # note: package name is xdelta, not xdelta3
			else
				echo >&2 "xdelta not installed. Exiting..."
				exit 1;
			fi
		# pacman
 		elif [[ ! -z $PACMAN_CMD ]]; then
 			echo >&2 "pacman detected."
			echo -n "Run sudo pacman -S $xdelta (y/N): "
			read check;
			if [ "$check" = "y" ]; then
				echo >&2 "Running sudo pacman -S $xdelta..."
 				yes | sudo pacman -S --noconfirm $xdelta 2>/dev/null
			else
				echo >&2 "xdelta not installed. Exiting..."
				exit 1;
			fi
		fi
	fi

	# Check if there's an existing file, and whether the user wants to overwrite it
	if [ -f "$outfile" ]; then
		printf "File $outfile already exists. Overwrite? (y/N) "
		read overwrite
		if [ "$overwrite" != "y" ]; then
			exit
		fi
	fi

	# Build the new ISO
	printf "Constructing 20XXHP ${version}.\n"
	printf "    Please stand by.... "

	xdelta -f -d -s "$infile" "$delta" "$outfile" 2>/dev/null
}

if [ "$infile" = "" ]; then
	printf "usage: 20xx-${version}-convert.sh FILE\n"
	exit
fi
if test -f "$infile"; then
	printf ""
else
	printf "usage: 20xx-${version}-convert.sh FILE\n"
	exit
fi

printf "\nVerifying that the given file is a vanilla NTSC v1.02 copy of SSBM. This will take a few moments...\n"

filehash=$(${md5sum} -b "$infile" |cut -d' ' -f1) 

if [ "$filehash" = "$sourceMd5" ]; then
	printf "The ISO has been verified!\n\n"
else
	printf "Unable to verify the source file ISO Hash. Please make sure you are providing a vanilla NTSC 1.02 copy of the game. Would you like to continue anyways? (y/N)"
	read cont;
	if [ "$cont" != "y" ]; then
		exit
	fi
fi

if build; then # Checks the exit code of build
	printf "SUCCESS\n\nConversion complete!\n\n"
else
	printf "FAIL\n\nThere was an error during the build process.\n\n"
	exit
fi

printf "Would you like to check the hash of your new 20XX copy? (y/N): "
read check;
if [ "$check" = "y" ]; then
	if checkhash "$outfile" "$modmd5"; then
		printf "SUCCESS\n\n"
	else
		printf "WARNING: The hash for the output file does NOT match the expected hash for the current version of the mod. It is very unlikely that this script was successful. Please use the output disc at your own risk."
	fi
fi
