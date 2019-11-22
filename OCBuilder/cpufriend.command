#!/bin/bash

BUILD_DIR="${1}/OCBuilder_Clone"


buildrelease() {
  xcodebuild -configuration Release  >/dev/null || exit 1
}

cd "${BUILD_DIR}"

echo "Cloning CPUFriend repo..."
git clone https://github.com/acidanthera/CPUFriend.git >/dev/null || exit 1
cp -r "${BUILD_DIR}/Lilu/build/Debug/Lilu.kext" "${BUILD_DIR}/CPUFriend"
cd "${BUILD_DIR}/CPUFriend"
echo "Compiling the latest commited Release version of CPUFriend..."
buildrelease
echo "CPUFriend Release Completed..."
