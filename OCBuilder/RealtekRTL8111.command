#!/bin/bash

BUILD_DIR="${1}/OCBuilder_Clone"

buildrelease() {
  xcodebuild -configuration Release  >/dev/null || exit 1
}

cd "${BUILD_DIR}"

echo "Cloning RealtekRTL8111 repo..."
git clone https://github.com/Mieze/RTL8111_driver_for_OS_X.git >/dev/null || exit 1
cd "${BUILD_DIR}/RTL8111_driver_for_OS_X"
echo "Compiling the latest commited Release version of RealtekRTL8111..."
buildrelease
echo "RealtekRTL8111 Release Completed..."
