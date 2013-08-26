#!/usr/bin/env sh

export WARCRAFT_ADDON_HOME="/Applications/World of Warcraft/Interface/AddOns"
export MONIKER_INSTALL_DIRECTORY="${WARCRAFT_ADDON_HOME}/Moniker"
export MONIKER_STAGING_DIRECTORY="Moniker"
export MONIKER_DEV_ARCHIVE_NAME="Moniker-SNAPSHOT.zip"

if [ -d "${MONIKER_INSTALL_DIRECTORY}" ]; then
  echo "'${MONIKER_INSTALL_DIRECTORY}' exists, removing for fresh deploy"
  rm -rfv "${MONIKER_INSTALL_DIRECTORY}"
  echo "\n"
fi

if [ -d "${MONIKER_STAGING_DIRECTORY}" ]; then
	echo "'${MONIKER_STAGING_DIRECTORY}' exists; left over from stale build?"
	rm -rfv "${MONIKER_STAGING_DIRECTORY}"
	echo "\n"
fi

echo "Creating staging directory '${MONIKER_STAGING_DIRECTORY}'"
mkdir -v "${MONIKER_STAGING_DIRECTORY}"
echo "\n"

if [ -d "${MONIKER_STAGING_DIRECTORY}" ]; then
  echo "Installing snapshot into staging directory '${MONIKER_STAGING_DIRECTORY}':"
  cp -v src/Moniker.* "${MONIKER_STAGING_DIRECTORY}"
  cp -v src/localization.* "${MONIKER_STAGING_DIRECTORY}"
  cp -v *.txt "${MONIKER_STAGING_DIRECTORY}"
  echo "\n"

  echo "Installing snapshot into installation directory '${MONIKER_INSTALL_DIRECTORY}':"
  cp -Rv ${MONIKER_STAGING_DIRECTORY} "${WARCRAFT_ADDON_HOME}"
  echo "\n"
else
  echo "'${MONIKER_STAGING_DIRECTORY}' doesn't seem to exist?"
  exit -1
fi

echo "Creating AddOn archive of snapshot"
zip -r ${MONIKER_DEV_ARCHIVE_NAME} ${MONIKER_STAGING_DIRECTORY}
echo "\n"

if [ -d "${MONIKER_STAGING_DIRECTORY}" ]; then
  echo "Cleaning up staging directory"
  rm -rfv ${MONIKER_STAGING_DIRECTORY}
  echo "\n"
fi

 echo "Deploy completed at `date +"%a, %d %b %Y %H:%M:%S %z"`."
