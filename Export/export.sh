#!/bin/sh

PATH=$PATH:/usr/local/bin

GIT_REMOTE_URL="YOUR GIT REMOTE URL"
echo GIT_REMOTE_URL=${GIT_REMOTE_URL}
GIT_BRANCH="YOUR GIT BRANCH"
echo GIT_BRANCH=${GIT_BRANCH}

IS_INSIDE_WORK_TREE=`git rev-parse --is-inside-work-tree`
echo "Is inside work tree=${IS_INSIDE_WORK_TREE}"

git config remote.origin.url "${GIT_REMOTE_URL}"
git fetch --tags --force --progress
GIT_COMMIT=`git rev-parse refs/remotes/origin/${GIT_BRANCH}^{commit}`
GIT_COMMIT_AUTHOR=`git log --pretty=format:"%an" ${GIT_COMMIT} -1`
GIT_COMMIT_MESSAGE=`git log --pretty=format:"%s" ${GIT_COMMIT} -1`
GIT_COMMIT_SUMMARY=${GIT_COMMIT: 0: 8}
GIT_COMMIT_TIME=`git log --pretty=format:"%ci" ${GIT_COMMIT} -1`
echo "Commit: ${GIT_COMMIT}"
echo "Commit by ${GIT_COMMIT_AUTHOR} at ${GIT_COMMIT_TIME}"
echo "Commit message: ${GIT_COMMIT_MESSAGE}"
echo "Commit summary: ${GIT_COMMIT_SUMMARY}"
git config core.sparsecheckout
git checkout -f ${GIT_COMMIT}

PROJECT_NAME="YOUR PROJECT NAME"
echo PROJECT_NAME=${PROJECT_NAME}
SCHEME_NAME="YOUR SCHEME NAME"
echo SCHEME_NAME=${SCHEME_NAME}

WORKSPACE="$PWD/${PROJECT_NAME}.xcworkspace"
echo WORKSPACE=$WORKSPACE

RELATIVE_PATH="Export"
ARCHIVES_PATH="${RELATIVE_PATH}/Archives"
echo ARCHIVES_PATH=$ARCHIVES_PATH
mkdir $ARCHIVES_PATH

DATE="$(date +%Y-%m-%d_%H.%M.%S)"
DATE_PATH="${ARCHIVES_PATH}/${DATE}"
echo DATE_PATH=$DATE_PATH
mkdir $DATE_PATH

OPTIONS_PATH="Options"
OPTIONS_FILE="$PWD/${RELATIVE_PATH}/${OPTIONS_PATH}/${SCHEME_NAME}.plist"
echo OPTIONS_FILE=$OPTIONS_FILE

EXPORT_PATH="$PWD/${DATE_PATH}"
echo EXPORT_PATH=$EXPORT_PATH

ARCHIVE_PATH="${EXPORT_PATH}/${SCHEME_NAME}.xcarchive"
echo ARCHIVE_PATH=$ARCHIVE_PATH

PLIST="$PWD/${PROJECT_NAME}/main/${SCHEME_NAME}.plist"
echo PLIST=$PLIST

/usr/libexec/PlistBuddy -c "Set CFBundleVersion $GIT_COMMIT_SUMMARY" "${PLIST}"

POD_REPO_UPDATE=false
echo POD_REPO_UPDATE=$POD_REPO_UPDATE

rm Podfile.lock
export LANG=en_US.UTF-8
if [[ "$POD_REPO_UPDATE" == true ]]
then
pod install  --verbose --repo-update
else
pod install  --verbose
fi

xcodebuild clean -workspace ${WORKSPACE} -scheme ${SCHEME_NAME} -configuration Release
xcodebuild archive -workspace ${WORKSPACE} -scheme ${SCHEME_NAME} -archivePath ${ARCHIVE_PATH}
xcodebuild -exportArchive -exportOptionsPlist ${OPTIONS_FILE} -archivePath ${ARCHIVE_PATH} -exportPath ${EXPORT_PATH}

open ${EXPORT_PATH}
