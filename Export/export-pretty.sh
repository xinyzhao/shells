#!/bin/sh
#sudo gem install xcpretty

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

# Cocoapods install
#pod install --repo-update

mkdir $ARCHIVES_PATH
mkdir $DATE_PATH

xcodebuild clean -workspace ${WORKSPACE} -scheme ${SCHEME} -configuration Release | xcpretty
xcodebuild archive -workspace ${WORKSPACE} -scheme ${SCHEME} -archivePath ${ARCHIVE_PATH} | xcpretty
xcodebuild -exportArchive -exportOptionsPlist ${OPTIONS_FILE} -archivePath ${ARCHIVE_PATH} -exportPath ${EXPORT_PATH} | xcpretty
