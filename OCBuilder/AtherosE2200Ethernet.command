#!/bin/bash

BUILD_DIR="${1}/OCBuilder_Clone"

buildrelease() {
  xcodebuild -configuration Release  >/dev/null || exit 1
}

cd "${BUILD_DIR}"

echo "Cloning AtherosE2200Ethernet repo..."
git clone https://github.com/Mieze/AtherosE2200Ethernet.git >/dev/null || exit 1
cd "${BUILD_DIR}/AtherosE2200Ethernet"
echo "Compiling the latest commited Release version of AtherosE2200Ethernet..."
buildrelease
echo "AtherosE2200Ethernet Release Completed..."
