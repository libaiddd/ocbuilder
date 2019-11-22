#!/bin/bash

BUILD_DIR="${1}/OCBuilder_Clone"


buildrelease() {
  xcodebuild -configuration Release  >/dev/null || exit 1
}

cd "${BUILD_DIR}"

echo "Cloning AppleALC repo..."
git clone https://github.com/acidanthera/AppleALC.git >/dev/null || exit 1
cp -r "${BUILD_DIR}/Lilu/build/Debug/Lilu.kext" "${BUILD_DIR}/AppleALC"
cd "${BUILD_DIR}/AppleALC"
echo "Compiling the latest commited Release version of AppleALC..."
buildrelease
echo "AppleALC Release Completed..."
