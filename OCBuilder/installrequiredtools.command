#!/bin/bash

#  installrequiredtools.command
#  OCBuilder
#
#  Created by Pavo on 7/30/19.
#  Copyright © 2019 Pavo. All rights reserved.
dialogTitle="OCBuilder"
# obtain the password from a dialog box
authPass=$(/usr/bin/osascript <<EOT
  tell application "System Events"
    activate
    repeat
      display dialog "This application requires administrator privileges. Please enter your administrator account password below to continue:" ¬
        default answer "" ¬
        with title "$dialogTitle" ¬
        with hidden answer ¬
        buttons {"Quit", "Continue"} default button 2
      if button returned of the result is "Quit" then
        return 1
        exit repeat
      else if the button returned of the result is "Continue" then
        set pswd to text returned of the result
        set usr to short user name of (system info)
        try
          do shell script "echo test" user name usr password pswd with administrator privileges
            return pswd
            exit repeat
        end try
      end if
    end repeat
  end tell
EOT
)
# Abort if the Quit button was pressed
if [ "$authPass" == 1 ]
then
  /bin/echo "User aborted. Exiting..."
  exit 0
fi
# function that replaces sudo command
sudo () {
    /bin/echo $authPass | /usr/bin/sudo -S "$@"
}

BUILD_DIR="${1}/OCBuilder_Clone"
FINAL_DIR="${2}/OCBuilder_Completed"

if [ ! -x /usr/local/bin/nasm ]; then
  echo "Installing Required NASM tool"
  sudo cp "${5}" /usr/local/bin
fi

if [ ! -x /usr/local/bin/ndisasm ]; then
  echo "Installing Required ndisasm tool"
  sudo cp "${8}" /usr/local/bin
fi

if [ ! -x /usr/local/bin/mtoc ]; then
  echo "Install Required MTOC tool"
  sudo cp "${6}" /usr/local/bin
fi

if [ ! -x /usr/local/bin/mtoc.NEW ]; then
  echo "Install Required MTOC.NEW tool"
  sudo cp "${9}" /usr/local/bin
fi

if [ ! -x "/Library/Frameworks/Python.framework/Versions/3.7/bin/python3" ]; then
  echo "Installing Required Python 3.7..."
  sudo cp "${7}" /tmp
  sudo installer -pkg /tmp/*.pkg -target /
fi

buildlilurelease() {
  echo "Compiling the latest commited Release version of Lilu..."
  xcodebuild -configuration Release  >/dev/null || exit 1
  echo "Lilu Release Completed..."
}

buildliludebug() {
  echo "Compiling the latest commited Debug version of Lilu..."
  xcodebuild -configuration Debug  >/dev/null || exit 1
  echo "Lilu Debug Completed..."
}

buildapplealcrelease() {
  echo "Compiling the latest commited Release version of AppleALC..."
  xcodebuild -configuration Release  >/dev/null || exit 1
  echo "AppleALC Release Completed..."
}

buildwegrelease() {
  echo "Compiling the latest commited Release version of WhateverGreen..."
  xcodebuild -configuration Release  >/dev/null || exit 1
  echo "WhateverGreen Release Completed..."
}

buildvirtualsmcrelease() {
  echo "Compiling the latest commited Release version of VirtualSMC..."
  xcodebuild -configuration Release  >/dev/null || exit 1
  echo "VirtualSMC Release Completed..."
}

buildcpufriendrelease() {
  echo "Compiling the latest commited Release version of CPUFriend..."
  xcodebuild -configuration Release  >/dev/null || exit 1
  echo "CPUFriend Release Completed..."
}

ocshellpackage() {
  pushd "$1" >/dev/null || exit 1
  rm -rf tmp >/dev/null || exit 1
  mkdir -p tmp/Tools >/dev/null || exit 1
  cp Shell.efi tmp/Tools/ >/dev/null || exit 1
  echo "$3" > tmp/UDK.hash >/dev/null || exit 1
  pushd tmp >/dev/null || exit 1
  zip -qry -FS ../"OpenCoreShell-${PKGVER}-${2}.zip" * >/dev/null || exit 1
  popd >/dev/null || exit 1
  rm -rf tmp >/dev/null || exit 1
  popd >/dev/null || exit 1
}

applesupportpackage() {
  local ver=$(cat Include/AppleSupportPkgVersion.h | grep APPLE_SUPPORT_VERSION | cut -f4 -d' ' | cut -f2 -d'"' | grep -E '^[0-9.]+$')
  if [ "$ver" = "" ]; then
    echo "Invalid version $ver..."
  fi

  pushd "$1" >/dev/null || exit 1
  rm -rf tmp >/dev/null || exit 1
  mkdir -p tmp/Drivers >/dev/null || exit 1
  mkdir -p tmp/Tools   || exit 1
  cp ApfsDriverLoader.efi tmp/Drivers/  || exit 1
  cp AppleGenericInput.efi tmp/Drivers/ || exit 1
  cp AppleUiSupport.efi tmp/Drivers/    || exit 1
  cp FwRuntimeServices.efi tmp/Drivers/ || exit 1
  cp UsbKbDxe.efi tmp/Drivers/          || exit 1
  cp VBoxHfs.efi tmp/Drivers/           || exit 1
  cp CleanNvram.efi tmp/Tools/          || exit 1
  cp VerifyMsrE2.efi tmp/Tools/         || exit 1
  pushd tmp >/dev/null || exit 1
  zip -qry -FS ../"AppleSupport-${ver}-${2}.zip" * >/dev/null || exit 1
  popd >/dev/null || exit 1
  rm -rf tmp >/dev/null || exit 1
  popd >/dev/null || exit 1
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
  cp -r "${selfdir}/UDK/OcSupportPkg/Utilities/Recovery" tmp/Utilities/ >/dev/null || exit 1
  pushd tmp >/dev/null || exit 1
  zip -qry -FS ../"OpenCore-${ver}-${2}.zip" * >/dev/null || exit 1
  popd >/dev/null || exit 1
  rm -rf tmp >/dev/null || exit 1
  popd >/dev/null || exit 1
}

ocshelludkclone() {
  echo "Cloning UDK Repo into OpenCoreShell..."
  git clone -q https://github.com/tianocore/edk2 UDK -b UDK2018 --depth=1
}

opencoreshellclone() {
  echo "Cloning OpenCoreShell Git repo..."
  git clone -q https://github.com/acidanthera/OpenCoreShell.git
}

applesupportpkgclone() {
  echo "Cloning AppleSupportPkg SupportPkgs into UDK..."
  git clone -q https://github.com/acidanthera/EfiPkg EfiPkg -b master --depth=1
  git clone -q https://github.com/acidanthera/OcSupportPkg OcSupportPkg -b master --depth=1
}

applesupportudkclone() {
  echo "Cloning UDK Repo into AppleSupportPkg..."
  git clone -q https://github.com/acidanthera/audk UDK -b master --depth=1
}

applesupportclone() {
  echo "Cloning AppleSupportPkg Git repo..."
  git clone -q https://github.com/acidanthera/AppleSupportPkg.git
}

opencorepkgclone() {
  echo "Cloning OpenCorePkg SupportPkgs into UDK..."
  git clone -q https://github.com/acidanthera/EfiPkg EfiPkg -b master --depth=1
  git clone -q https://github.com/acidanthera/OcSupportPkg OcSupportPkg -b master --depth=1
  git clone -q https://github.com/acidanthera/MacInfoPkg MacInfoPkg -b master --depth=1
}

opencoreudkclone() {
  echo "Cloning UDK Repo into OpenCorePkg..."
  git clone -q https://github.com/acidanthera/audk UDK -b master --depth=1
}

opencoreclone() {
  echo "Cloning OpenCorePkg Git repo..."
  git clone -q https://github.com/acidanthera/OpenCorePkg.git
}

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

if [ ! -d "${BUILD_DIR}" ]; then
  mkdir -p "${BUILD_DIR}"
else
  rm -rf "${BUILD_DIR}/"
  mkdir -p "${BUILD_DIR}"
fi

cd "${BUILD_DIR}"

echo "Cloning Lilu repo..."
git clone https://github.com/acidanthera/Lilu.git >/dev/null || exit 1
cd "${BUILD_DIR}/Lilu"
buildliludebug
buildlilurelease

cd "${BUILD_DIR}"

echo "Cloning AppleALC repo..."
git clone https://github.com/acidanthera/AppleALC.git >/dev/null || exit 1
cp -r "${BUILD_DIR}/Lilu/build/Debug/Lilu.kext" "${BUILD_DIR}/AppleALC"
cd "${BUILD_DIR}/AppleALC"
buildapplealcrelease

cd "${BUILD_DIR}"

echo "Cloning WhateverGreen repo..."
git clone https://github.com/acidanthera/WhateverGreen.git >/dev/null || exit 1
cp -r "${BUILD_DIR}/Lilu/build/Debug/Lilu.kext" "${BUILD_DIR}/WhateverGreen"
cd "${BUILD_DIR}/WhateverGreen"
buildwegrelease

cd "${BUILD_DIR}"

echo "Cloning VirtualSMC repo..."
git clone https://github.com/acidanthera/VirtualSMC.git >/dev/null || exit 1
cp -r "${BUILD_DIR}/Lilu/build/Debug/Lilu.kext" "${BUILD_DIR}/VirtualSMC"
cd "${BUILD_DIR}/VirtualSMC"
buildvirtualsmcrelease

cd "${BUILD_DIR}"

echo "Cloning CPUFriend repo..."
git clone https://github.com/acidanthera/CPUFriend.git >/dev/null || exit 1
cp -r "${BUILD_DIR}/Lilu/build/Debug/Lilu.kext" "${BUILD_DIR}/CPUFriend"
cd "${BUILD_DIR}/CPUFriend"
buildcpufriendrelease

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

cd "${BUILD_DIR}"

applesupportclone
cd "${BUILD_DIR}/AppleSupportPkg"
mkdir Binaries >/dev/null || exit 1
cd Binaries >/dev/null || exit 1
ln -s ../UDK/Build/AppleSupportPkg/RELEASE_XCODE5/X64 RELEASE >/dev/null || exit 1
cd .. >/dev/null || exit 1
applesupportudkclone
cd UDK
applesupportpkgclone
ln -s .. AppleSupportPkg >/dev/null || exit 1
make -C BaseTools >/dev/null || exit 1
sleep 1
unset WORKSPACE
unset EDK_TOOLS_PATH
export PATH=/Library/Frameworks/Python.framework/Versions/3.7/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Library/Apple/usr/bin:/Library/Apple/bin
export NASM_PREFIX=/usr/local/bin/
source edksetup.sh --reconfig >/dev/null || exit 1
sleep 1
echo "Compiling the latest commited Release version of AppleSupportPkg..."
build -a X64 -b RELEASE -t XCODE5 -p AppleSupportPkg/AppleSupportPkg.dsc >/dev/null || exit 1

cd .. >/dev/null || exit 1
applesupportpackage "Binaries/RELEASE" "RELEASE" >/dev/null || exit 1

cd "${BUILD_DIR}"

opencoreshellclone
cd "${BUILD_DIR}/OpenCoreShell"
mkdir Binaries >/dev/null || exit 1
cd Binaries >/dev/null || exit 1
ln -s ../UDK/Build/Shell/RELEASE_XCODE5/X64 RELEASE >/dev/null || exit 1
cd .. >/dev/null || exit 1
ocshelludkclone
cd UDK
HASH=$(git rev-parse origin/UDK2018)
ln -s .. AppleSupportPkg >/dev/null || exit 1
make -C BaseTools >/dev/null || exit 1
sleep 1
unset WORKSPACE
unset EDK_TOOLS_PATH
export PATH=/Library/Frameworks/Python.framework/Versions/3.7/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Library/Apple/usr/bin:/Library/Apple/bin
export NASM_PREFIX=/usr/local/bin/
source edksetup.sh --reconfig >/dev/null
sleep 1
for i in ../Patches/* ; do
    git apply "$i" >/dev/null || exit 1
    git add * >/dev/null || exit 1
    git commit -m "Applied patch $i" >/dev/null || exit 1
done
touch patches.ready
echo "Compiling the latest commited Release version of OpenCoreShellPkg..."
build -a X64 -b RELEASE -t XCODE5 -p ShellPkg/ShellPkg.dsc >/dev/null || exit 1
cd .. >/dev/null || exit 1
ocshellpackage "Binaries/RELEASE" "RELEASE" "$HASH" >/dev/null || exit 1

if [ ! -d "${FINAL_DIR}" ]; then
  mkdir -p "${FINAL_DIR}"
  copyBuildProducts
  rm -rf "${BUILD_DIR}/"
  open -a Safari https://insanelymacdiscord.github.io/Getting-Started-With-OpenCore/
else
  rm -rf "${FINAL_DIR}"/*
  copyBuildProducts
  rm -rf "${BUILD_DIR}/"
  open -a Safari https://insanelymacdiscord.github.io/Getting-Started-With-OpenCore/
fi
