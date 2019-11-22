#!/bin/bash

BUILD_DIR="${1}/OCBuilder_Clone"


buildrelease() {
  xcodebuild -configuration Release  >/dev/null || exit 1
}

cd "${BUILD_DIR}"

echo "Cloning RTCMemoryFixup repo..."
git clone https://github.com/acidanthera/RTCMemoryFixup.git >/dev/null || exit 1
cp -r "${BUILD_DIR}/Lilu/build/Debug/Lilu.kext" "${BUILD_DIR}/RTCMemoryFixup"
cd "${BUILD_DIR}/RTCMemoryFixup"
echo "Compiling the latest commited Release version of RTCMemoryFixup..."
buildrelease
echo "RTCMemoryFixup Release Completed..."
