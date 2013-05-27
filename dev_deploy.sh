#!/usr/bin/env sh

export WARCRAFT_ADDON_HOME="/Applications/World of Warcraft/Interface/AddOns"
export MONIKER_DIRECTORY=${WARCRAFT_ADDON_HOME}/Moniker

if [ ! -d "${MONIKER_DIRECTORY}" ]; then
  mkdir -v "${MONIKER_DIRECTORY}"
else
  echo "'${MONIKER_DIRECTORY}' exists, proceeding..."
fi

if [ -d "${MONIKER_DIRECTORY}" ]; then
  cp -v src/Moniker.lua "${MONIKER_DIRECTORY}"
  cp -v src/Moniker.toc "${MONIKER_DIRECTORY}"
  cp -v src/Moniker.xml "${MONIKER_DIRECTORY}"
  date
else
  echo "'${MONIKER_DIRECTORY}' doesn't seem to exist?"
fi
