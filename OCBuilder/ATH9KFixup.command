#!/bin/bash

BUILD_DIR="${1}/OCBuilder_Clone"


buildrelease() {
  xcodebuild -configuration Release  >/dev/null || exit 1
}

cd "${BUILD_DIR}"

echo "Cloning ATH9KFixup repo..."
git clone https://github.com/chunnann/ATH9KFixup.git >/dev/null || exit 1
cp -r "${BUILD_DIR}/Lilu/build/Debug/Lilu.kext" "${BUILD_DIR}/ATH9KFixup"
cd "${BUILD_DIR}/ATH9KFixup"
echo "Compiling the latest commited Release version of ATH9KFixup..."
buildrelease
echo "ATH9KFixup Release Completed..."
