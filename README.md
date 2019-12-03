# OCBuilder
MacOS App to compile Opencore, common drivers and kexts that are used with OpenCore from source.

## This app will git clone from the following sources:
- [Lilu](https://github.com/acidanthera/Lilu.git)
- [WhateverGreen](https://github.com/acidanthera/WhateverGreen.git)
- [AppleALC](https://github.com/acidanthera/AppleALC.git)
- [VirtualSMC](https://github.com/acidanthera/VirtualSMC.git)
- [CPUFriend](https://github.com/acidanthera/CPUFriend.git)
- [AirportBrcmFixup](https://github.com/acidanthera/AirportBrcmFixup.git)
- [ATH9KFixup](https://github.com/chunnann/ATH9KFixup.git)
- [RTCMemoryFixup](https://github.com/acidanthera/RTCMemoryFixup.git)
- [IntelMausiEthernet](https://github.com/Mieze/IntelMausiEthernet.git)
- [AtherosE2200Ethernet](https://github.com/Mieze/AtherosE2200Ethernet.git)
- [RealtekRTL8111](https://github.com/Mieze/RTL8111_driver_for_OS_X.git)
- [TSCAdjustReset](https://github.com/interferenc/TSCAdjustReset.git)
- [OpenCorePkg](https://github.com/acidanthera/OpenCorePkg.git)
- [AppleSupportPkg](https://github.com/acidanthera/AppleSupportPkg.git)
- [OpenCoreShell](https://github.com/acidanthera/OpenCoreShell.git)

## This app requires the full Xcode app installed in order to compile the source. You also must agree to the User Agreement after installing Xcode app.
You can install Xcode directly from the following link
- [Xcode](https://apps.apple.com/us/app/xcode/id497799835?mt=12)

This app will check to see if you have all the required tools installed in order to compile these sources. If the required tools are not installed, it will install them for you, except for the full application of Xcode. It will give you an alert warning you that you do not have Xcode installed and give you the download link. This app gives you choice for selection on where you want to save the completed builds folder(for when everything has been compiled). When you click the Build button it will compile the latest commits to the sources using xcodebuild, nasm, and mtoc. Once compile has completed a OCBuilder_Completed folder with the Opencore EFI structure will be produced with all the Drivers, kexts and tools will be placed in the OCBuilder_Completed folder on the location of your selection. You may not need all of them, so make sure you remove any Drivers or Kext you do not need. "They are examples only. You have been WARNED!!!!" 

## Discord To chat with Devs and help with Opencore
- [Insanelymac Discord](https://discord.gg/sWxNTSx)

## This app will create the following folder structure on the location that you have selected for Completed Builds folder.:
```
|--CompletedBuilds
|   |--Docs
|   |   |--AcpiSamples
|   |   |   |--SSDT-AWAC.dsl
|   |   |   |--SSDT-EC-USBX.dsl
|   |   |   |--SSDT-EC.dsl
|   |   |   |--SSDT-EHCx_OFF.dsl
|   |   |   |--SSDT-PLUG.dsl
|   |   |   |--SSDT-SBUS-MCHC.dsl
|   |   |--Changelog.md
|   |   |--Configuration.pdf
|   |   |--Differences.pdf
|   |   |--Sample.plist
|   |   |--SampleFull.plist
|   |--EFI
|   |   |--BOOT
|   |   |   |--BOOTx64.efi
|   |   |--OC
|   |   |   |--ACPI
|   |   |   |--Drivers
|   |   |   |   |--ApfsDriverLoader.efi
|   |   |   |   |--AppleGenericInput.efi
|   |   |   |   |--AppleUiSupport.efi
|   |   |   |   |--FwRuntimeService.efi
|   |   |   |   |--UsbKbDxe.efi
|   |   |   |   |--VBoxHfs.efi
|   |   |   |   |--VirtualSmc.efi
|   |   |   |--Kexts
|   |   |   |   |--AppleALC.kext
|   |   |   |   |--CPUFriend.kext
|   |   |   |   |--Lilu.kext
|   |   |   |   |--SMCBatteryManager.kext
|   |   |   |   |--SMCLightSensor.kext
|   |   |   |   |--SMCProcessor.kext
|   |   |   |   |--SMCSuperIO.kext
|   |   |   |   |--VirtualSMC.kext
|   |   |   |   |--WhateverGreen.kext
|   |   |   |--OpenCore.efi
|   |   |   |--Tools
|   |   |   |   |--CleanNvram.efi
|   |   |   |   |--Shell.efi
|   |   |   |   |--VerifyMsrE2.efi
|   |--Utilities
|   |   |--BootInstall
|   |   |   |--boot
|   |   |   |--boot0af
|   |   |   |--boot1f32
|   |   |   |--BootInstall.command
|   |   |   |--README.md
|   |   |--CreateVault
|   |   |   |--create_vault.sh
|   |   |   |--RsaTool
|   |   |   |--sign.command
|   |   |--LogoutHook
|   |   |   |--LogoutHook.command
|   |   |   |--nvram.mojave
|   |   |   |--README.md
|   |   |--Recovery
|   |   |   |--obtain_recovery.php
|   |   |   |--recovery_urls.txt
```
