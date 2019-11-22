#!/bin/bash

BUILD_DIR="${1}/OCBuilder_Clone"

buildrelease() {
  xcodebuild -configuration Release  >/dev/null || exit 1
}

builddebug() {
  xcodebuild -configuration Debug  >/dev/null || exit 1
}

cd "${BUILD_DIR}"

echo "Cloning Lilu repo..."
git clone https://github.com/acidanthera/Lilu.git >/dev/null || exit 1
cd "${BUILD_DIR}/Lilu"
echo "Compiling the latest commited Debug version of Lilu..."
builddebug
echo "Lilu Debug Completed..."
sleep 1
echo "Compiling the latest commited Release version of Lilu..."
buildrelease
echo "Lilu Release Completed..."
