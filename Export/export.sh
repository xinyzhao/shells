#!/bin/sh

PATH=$PATH:/usr/local/bin

PROJECT="YOUR PROJECT NAME"
SCHEME="YOUR SCHEME NAME"

WORKSPACE="$PWD/${PROJECT}.xcworkspace"
echo WORKSPACE=$WORKSPACE

RELATIVE_PATH="Export"
ARCHIVES_PATH="${RELATIVE_PATH}/Archives"
echo ARCHIVES_PATH=$ARCHIVES_PATH

DATE="$(date +%Y-%m-%d_%H.%M.%S)"
DATE_PATH="${ARCHIVES_PATH}/${DATE}"
echo DATE_PATH=$DATE_PATH

OPTIONS_PATH="Options"
OPTIONS_FILE="$PWD/${RELATIVE_PATH}/${OPTIONS_PATH}/${SCHEME}.plist"
echo OPTIONS_FILE=$OPTIONS_FILE

EXPORT_PATH="$PWD/${DATE_PATH}"
echo EXPORT_PATH=$EXPORT_PATH

ARCHIVE_PATH="${EXPORT_PATH}/${SCHEME}.xcarchive"
echo ARCHIVE_PATH=$ARCHIVE_PATH

PLIST="$PWD/${PROJECT}/main/${SCHEME}.plist"
echo PLIST=$PLIST

BUILD=$(date +%Y.%m.%d.%H%M%S)
echo BUILD=$BUILD

/usr/libexec/PlistBuddy -c "Set CFBundleVersion $BUILD" "${PLIST}"

export LANG=en_US.UTF-8
pod deintegrate
pod install  --verbose --repo-update
#pod install --verbose

mkdir $ARCHIVES_PATH
mkdir $DATE_PATH

xcodebuild clean -workspace ${WORKSPACE} -scheme ${SCHEME} -configuration Release
xcodebuild archive -workspace ${WORKSPACE} -scheme ${SCHEME} -archivePath ${ARCHIVE_PATH}
xcodebuild -exportArchive -exportOptionsPlist ${OPTIONS_FILE} -archivePath ${ARCHIVE_PATH} -exportPath ${EXPORT_PATH}

open ${EXPORT_PATH}
