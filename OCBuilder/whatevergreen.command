#!/bin/bash

BUILD_DIR="${1}/OCBuilder_Clone"


buildrelease() {
  xcodebuild -configuration Release  >/dev/null || exit 1
}

cd "${BUILD_DIR}"

echo "Cloning WhateverGreen repo..."
git clone https://github.com/acidanthera/WhateverGreen.git >/dev/null || exit 1
cp -r "${BUILD_DIR}/Lilu/build/Debug/Lilu.kext" "${BUILD_DIR}/WhateverGreen"
cd "${BUILD_DIR}/WhateverGreen"
echo "Compiling the latest commited Release version of WhateverGreen..."
buildrelease
echo "WhateverGreen Release Completed..."

