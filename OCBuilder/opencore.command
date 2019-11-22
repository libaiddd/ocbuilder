#!/bin/bash

BUILD_DIR="${1}/OCBuilder_Clone"

opencoreclone() {
  echo "Cloning OpenCorePkg Git repo..."
  git clone -q https://github.com/acidanthera/OpenCorePkg.git
}

opencoreudkclone() {
  echo "Cloning UDK Repo into OpenCorePkg..."
  git clone -q https://github.com/acidanthera/audk UDK -b master --depth=1
}

opencorepkgclone() {
  echo "Cloning OpenCorePkg SupportPkgs into UDK..."
  git clone -q https://github.com/acidanthera/EfiPkg EfiPkg -b master --depth=1
  git clone -q https://github.com/acidanthera/OcSupportPkg OcSupportPkg -b master --depth=1
  git clone -q https://github.com/acidanthera/MacInfoPkg MacInfoPkg -b master --depth=1
}

opencorepackage() {
  local ver=$(cat Include/OpenCore.h | grep OPEN_CORE_VERSION | sed 's/.*"\(.*\)".*/\1/' | grep -E '^[0-9.]+$')
  if [ "$ver" = "" ]; then
    echo "Invalid version $ver..."
  fi

  selfdir=$(pwd)
  pushd "$1" >/dev/null || exit 1
  rm -rf tmp >/dev/null || exit 1
  mkdir -p tmp/EFI >/dev/null || exit 1
  mkdir -p tmp/EFI/OC >/dev/null || exit 1
  mkdir -p tmp/EFI/OC/ACPI >/dev/null || exit 1
  mkdir -p tmp/EFI/OC/Drivers >/dev/null || exit 1
  mkdir -p tmp/EFI/OC/Kexts >/dev/null || exit 1
  mkdir -p tmp/EFI/OC/Tools >/dev/null || exit 1
  mkdir -p tmp/EFI/BOOT >/dev/null || exit 1
  mkdir -p tmp/Docs/AcpiSamples >/dev/null || exit 1
  mkdir -p tmp/Utilities >/dev/null || exit 1
  cp OpenCore.efi tmp/EFI/OC/ >/dev/null || exit 1
  cp BOOTx64.efi tmp/EFI/BOOT/ >/dev/null || exit 1
  cp "${selfdir}/Docs/Configuration.pdf" tmp/Docs/ >/dev/null || exit 1
  cp "${selfdir}/Docs/Differences/Differences.pdf" tmp/Docs/ >/dev/null || exit 1
  cp "${selfdir}/Docs/Sample.plist" tmp/Docs/ >/dev/null || exit 1
  cp "${selfdir}/Docs/SampleFull.plist" tmp/Docs/ >/dev/null || exit 1
  cp "${selfdir}/Changelog.md" tmp/Docs/ >/dev/null || exit 1
  cp -r "${selfdir}/Docs/AcpiSamples/" tmp/Docs/AcpiSamples/ >/dev/null || exit 1
  cp -r "${selfdir}/UDK/OcSupportPkg/Utilities/BootInstall" tmp/Utilities/ >/dev/null || exit 1
  cp -r "${selfdir}/UDK/OcSupportPkg/Utilities/CreateVault" tmp/Utilities/ >/dev/null || exit 1
  cp -r "${selfdir}/UDK/OcSupportPkg/Utilities/LogoutHook" tmp/Utilities/ >/dev/null || exit 1
  pushd tmp >/dev/null || exit 1
  zip -qry -FS ../"OpenCore-${ver}-${2}.zip" * >/dev/null || exit 1
  popd >/dev/null || exit 1
  rm -rf tmp >/dev/null || exit 1
  popd >/dev/null || exit 1
}

cd "${BUILD_DIR}"

opencoreclone
cd "${BUILD_DIR}/OpenCorePkg"
mkdir Binaries
cd Binaries
ln -s ../UDK/Build/OpenCorePkg/RELEASE_XCODE5/X64 RELEASE
cd ..
opencoreudkclone
cd UDK
opencorepkgclone
ln -s .. OpenCorePkg
make -C BaseTools >/dev/null || exit 1
sleep 1
export PATH=/Library/Frameworks/Python.framework/Versions/3.7/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Library/Apple/usr/bin:/Library/Apple/bin
export NASM_PREFIX=/usr/local/bin/
source edksetup.sh --reconfig >/dev/null
sleep 1
echo "Compiling the latest commited Release version of OpenCorePkg..."
build -a X64 -b RELEASE -t XCODE5 -p OpenCorePkg/OpenCorePkg.dsc >/dev/null || exit 1

cd .. >/dev/null || exit 1
opencorepackage "Binaries/RELEASE" "RELEASE" >/dev/null || exit 1
