#!/bin/bash
# Shell script to apply patches necessary to build for Galaxy S devices

pushd $(dirname "${0}") > /dev/null
SCRIPTPATH=$(pwd -L)
# Use "pwd -P" for the path without links. man bash for more info.
popd > /dev/null

SCRIPTPATH=$SCRIPTPATH"/"

# Location of ANDROID_ROOT compared with $SCRIPTPATH
ROOT_LOCATION=../../../../

# PATCHFILE=name of patch to apply
# DIRECTORY=directory to apply patch to relative to ANDROID_ROOT

PATCHFILE[0]="android_art.patch"
DIRECTORY[0]="art"

PATCHFILE[1]="android_bionic.patch"
DIRECTORY[1]="bionic"

PATCHFILE[2]="android_bootable_recovery.patch"
DIRECTORY[2]="bootable/recovery"

PATCHFILE[3]="android_build.patch"
DIRECTORY[3]="build"

PATCHFILE[4]="android_external_busybox.patch"
DIRECTORY[4]="external/busybox"

PATCHFILE[5]="android_frameworks_base.patch"
DIRECTORY[5]="frameworks/base"

PATCHFILE[6]="android_system_bt.patch"
DIRECTORY[6]="system/bt"

PATCHFILE[7]="android_system_extras.patch"
DIRECTORY[7]="system/extras"

PATCHFILE[8]="android_packages_apps_OpenDelta.patch"
DIRECTORY[8]="packages/apps/OpenDelta"

PATCHFILE[9]="android_external_sepolicy.patch"
DIRECTORY[9]="external/sepolicy"

PATCHFILE[10]="android_frameworks_opt_telephony.patch"
DIRECTORY[10]="frameworks/opt/telephony"

ARRAY_LENGTH=${#PATCHFILE[@]}
COUNTER=0
while [  $COUNTER -lt $ARRAY_LENGTH ]; do
        cd $SCRIPTPATH$ROOT_LOCATION${DIRECTORY[$COUNTER]} || exit
	ABS_PATCHFILE=$SCRIPTPATH${PATCHFILE[$COUNTER]}

	CMD_OUTPUT=$(git am $ABS_PATCHFILE)

        echo $CMD_OUTPUT

	if [[ $CMD_OUTPUT =~ error.|fail. ]]; then
		git am --abort
		echo Ran git am --abort
	fi

	let COUNTER=COUNTER+1
done

if test -e $SCRIPTPATH$ROOT_LOCATION/vendor/omni/prebuilt/bootanimation/res/480x270.zip; then
	echo Bootanimation already created
else
	cd $SCRIPTPATH$ROOT_LOCATION/vendor/omni/prebuilt/bootanimation/res
	CMD_OUTPUT=$(git am $SCRIPTPATH/android_vendor_omni.patch)

	echo $CMD_OUTPUT

	if [[ $CMD_OUTPUT =~ error.|fail. ]]; then
		git am --abort
		echo Ran git am --abort
	fi

	$SCRIPTPATH$ROOT_LOCATION/vendor/omni/prebuilt/bootanimation/res/generate-packages.sh
fi
