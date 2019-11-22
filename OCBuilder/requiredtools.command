#!/bin/bash

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

sudo rm -rf /usr/local/bin/mtoc*
sudo rm -rf /usr/local/bin/nasm*
sudo rm -rf /usr/local/bin/ndisasm*

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

if [ ! -d "${BUILD_DIR}" ]; then
  mkdir -p "${BUILD_DIR}"
else
  rm -rf "${BUILD_DIR}/"
  mkdir -p "${BUILD_DIR}"
fi
