#!/usr/bin/env sh

export WARCRAFT_ADDON_HOME="/Applications/World of Warcraft/Interface/AddOns"
export AKA_INSTALL_DIRECTORY="${WARCRAFT_ADDON_HOME}/AKA"
export AKA_STAGING_DIRECTORY="AKA"
export AKA_DEV_ARCHIVE_NAME="AKA-SNAPSHOT.zip"

if [ -d "${AKA_INSTALL_DIRECTORY}" ]; then
  echo "'${AKA_INSTALL_DIRECTORY}' exists, removing for fresh deploy"
  rm -rfv "${AKA_INSTALL_DIRECTORY}"
  echo "\n"
fi

if [ -d "${AKA_STAGING_DIRECTORY}" ]; then
	echo "'${AKA_STAGING_DIRECTORY}' exists; left over from stale build?"
	rm -rfv "${AKA_STAGING_DIRECTORY}"
	echo "\n"
fi

echo "Creating staging directory '${AKA_STAGING_DIRECTORY}'"
mkdir -v "${AKA_STAGING_DIRECTORY}"
echo "\n"

if [ -d "${AKA_STAGING_DIRECTORY}" ]; then
  echo "Installing snapshot into staging directory '${AKA_STAGING_DIRECTORY}':"
  cp -v src/AKA.* "${AKA_STAGING_DIRECTORY}"
  cp -v src/localization.* "${AKA_STAGING_DIRECTORY}"
  cp -v *.txt "${AKA_STAGING_DIRECTORY}"
  echo "\n"

  echo "Installing snapshot into installation directory '${AKA_INSTALL_DIRECTORY}':"
  cp -Rv ${AKA_STAGING_DIRECTORY} "${WARCRAFT_ADDON_HOME}"
  echo "\n"
else
  echo "'${AKA_STAGING_DIRECTORY}' doesn't seem to exist?"
  exit -1
fi

echo "Creating AddOn archive of snapshot"
zip -r ${AKA_DEV_ARCHIVE_NAME} ${AKA_STAGING_DIRECTORY}
echo "\n"

if [ -d "${AKA_STAGING_DIRECTORY}" ]; then
  echo "Cleaning up staging directory"
  rm -rfv ${AKA_STAGING_DIRECTORY}
  echo "\n"
fi

 echo "Deploy completed at `date +"%a, %d %b %Y %H:%M:%S %z"`."
