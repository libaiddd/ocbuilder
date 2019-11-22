#!/bin/bash

BUILD_DIR="${1}/OCBuilder_Clone"


buildrelease() {
  xcodebuild -configuration Release  >/dev/null || exit 1
}

cd "${BUILD_DIR}"

echo "Cloning VirtualSMC repo..."
git clone https://github.com/acidanthera/VirtualSMC.git >/dev/null || exit 1
cp -r "${BUILD_DIR}/Lilu/build/Debug/Lilu.kext" "${BUILD_DIR}/VirtualSMC"
cd "${BUILD_DIR}/VirtualSMC"
echo "Compiling the latest commited Release version of VirtualSMC..."
buildrelease
echo "VirtualSMC Release Completed..."
