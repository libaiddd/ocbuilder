#!/bin/bash

BUILD_DIR="${1}/OCBuilder_Clone"

buildrelease() {
  xcodebuild -configuration Release  >/dev/null || exit 1
}

cd "${BUILD_DIR}"

echo "Cloning IntelMausiEthernet repo..."
git clone https://github.com/Mieze/IntelMausiEthernet.git >/dev/null || exit 1
cd "${BUILD_DIR}/IntelMausiEthernet"
echo "Compiling the latest commited Release version of IntelMausiEthernet..."
buildrelease
echo "IntelMausiEthernet Release Completed..."
