#!/bin/bash

BUILD_DIR="${1}/OCBuilder_Clone"

buildrelease() {
  xcodebuild -configuration Release  >/dev/null || exit 1
}

cd "${BUILD_DIR}"

echo "Cloning TSCAdjustReset repo..."
git clone https://github.com/interferenc/TSCAdjustReset.git >/dev/null || exit 1
cd "${BUILD_DIR}/TSCAdjustReset"
echo "Compiling the latest commited Release version of TSCAdjustReset..."
buildrelease
echo "TSCAdjustReset Release Completed..."
