#!/bin/bash

BUILD_DIR="${1}/OCBuilder_Clone"
FINAL_DIR="${2}/OCBuilder_Completed"

copyBuildProducts() {
  echo "Copying compiled products into EFI Structure folder in ${FINAL_DIR}..."
  cp "${BUILD_DIR}"/OpenCorePkg/Binaries/RELEASE/*.zip "${FINAL_DIR}/"
  cd "${FINAL_DIR}/"
  unzip *.zip  >/dev/null || exit 1
  rm -rf *.zip
  cp -r "${BUILD_DIR}/Lilu/build/Release/Lilu.kext" "${FINAL_DIR}"/EFI/OC/Kexts
  cp -r "${BUILD_DIR}/AppleALC/build/Release/AppleALC.kext" "${FINAL_DIR}"/EFI/OC/Kexts
  cp -r "${BUILD_DIR}"/VirtualSMC/build/Release/*.kext "${FINAL_DIR}"/EFI/OC/Kexts
  cp -r "${BUILD_DIR}/WhateverGreen/build/Release/WhateverGreen.kext" "${FINAL_DIR}"/EFI/OC/Kexts
  cp -r "${BUILD_DIR}/CPUFriend/build/Release/CPUFriend.kext" "${FINAL_DIR}"/EFI/OC/Kexts
  cp -r "${BUILD_DIR}/AirportBrcmFixup/build/Release/AirportBrcmFixup.kext" "${FINAL_DIR}"/EFI/OC/Kexts
  cp -r "${BUILD_DIR}/ATH9KFixup/build/Release/ATH9KFixup.kext" "${FINAL_DIR}"/EFI/OC/Kexts
  cp -r "${BUILD_DIR}/RTCMemoryFixup/build/Release/RTCMemoryFixup.kext" "${FINAL_DIR}"/EFI/OC/Kexts
  cp -r "${BUILD_DIR}/IntelMausiEthernet/build/Release/IntelMausiEthernet.kext" "${FINAL_DIR}"/EFI/OC/Kexts
  cp -r "${BUILD_DIR}/AtherosE2200Ethernet/build/Release/AtherosE2200Ethernet.kext" "${FINAL_DIR}"/EFI/OC/Kexts
  cp -r "${BUILD_DIR}/TSCAdjustReset/build/Release/TSCAdjustReset.kext" "${FINAL_DIR}"/EFI/OC/Kexts
  cp -r "${BUILD_DIR}/RTL8111_driver_for_OS_X/build/Release/RealtekRTL8111.kext" "${FINAL_DIR}"/EFI/OC/Kexts
  cp -r "${BUILD_DIR}/VirtualSMC/EfiDriver/VirtualSmc.efi" "${FINAL_DIR}"/EFI/OC/Drivers
  cp -r "${BUILD_DIR}/OpenCoreShell/Binaries/RELEASE/Shell.efi" "${FINAL_DIR}"/EFI/OC/Tools
  cd "${BUILD_DIR}"/AppleSupportPkg/Binaries/RELEASE
  rm -rf "${BUILD_DIR}"/AppleSupportPkg/Binaries/RELEASE/Drivers
  rm -rf "${BUILD_DIR}"/AppleSupportPkg/Binaries/RELEASE/Tools
  unzip *.zip  >/dev/null || exit 1
  cp -r "${BUILD_DIR}"/AppleSupportPkg/Binaries/RELEASE/Drivers/*.efi "${FINAL_DIR}"/EFI/OC/Drivers
  cp -r "${BUILD_DIR}"/AppleSupportPkg/Binaries/RELEASE/Tools/*.efi "${FINAL_DIR}"/EFI/OC/Tools
  echo "All Done!..."
}

if [ ! -d "${FINAL_DIR}" ]; then
  mkdir -p "${FINAL_DIR}"
  copyBuildProducts
#  rm -rf "${BUILD_DIR}/"
  open -a Safari https://pavo-im.github.io/Getting-Started-With-OpenCore/
else
  rm -rf "${FINAL_DIR}"/*
  copyBuildProducts
#  rm -rf "${BUILD_DIR}/"
  open -a Safari https://pavo-im.github.io/Getting-Started-With-OpenCore/
fi
