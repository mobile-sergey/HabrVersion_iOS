#!/bin/sh

#  version.sh
#  Version
#
#  Created by Sergey Lavrov on 07.08.2023.
#  

# 1.In Build Phases add "New Run Script Phase" with "$SRCROOT/version.sh"
# 2.Add this script to folder Scripts of project
# 3.Add version.sh to main Target
# 4.Change permission of version.sh in Terminal: sudo chmod 770 version.sh

# 5.Set variables
git=/usr/local/bin/git
git_tag=$(git describe --tags --always --abbrev=0)
git_version=$(git rev-list HEAD --count --grep='^Merge .*$' --invert-grep)

# 6.Rewrite versions in Info.plist
if [ "${Build}" = "" ]; then
  /usr/libexec/PlistBuddy -c "Set :CFBundleVersion ${git_version}" "$INFOPLIST_FILE"
else
  Build=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "$INFOPLIST_FILE")
  Build=$(echo "scale=0; $Build + ${git_version}" | bc)
  /usr/libexec/PlistBuddy -c "Set :CFBundleVersion $Build" "$INFOPLIST_FILE"
fi
if [ "${Version}" = "" ]; then
  /usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString ${git_tag}" "$INFOPLIST_FILE"
else
  Version=$(/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" "$INFOPLIST_FILE")
  Version=$(echo "scale=2; $Version + ${git_tag}" | bc)
  if [ "${CONFIGURATION}" = "Release" ]; then
    /usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString $Version" "$INFOPLIST_FILE"
  fi
fi

# 7.Rewrite label with that has user name "APP_VERSION" in LaunchScreen.storyboard with version from git
sourceFilePath="$PROJECT_DIR/$PROJECT_NAME/Storyboards/LaunchScreen.storyboard"
sed -i .bak -e "/userLabel=\"APP_VERSION\"/s/text=\"[^\"]*\"/text=\"$git_tag ($git_version)\"/" "$sourceFilePath"
