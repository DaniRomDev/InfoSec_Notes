#!/bin/bash

source "../Scripts/whichOperatingSystem.sh"
source "../Scripts/whichPackageManager.sh"

echo -e "Giving user execution permissions on installation scripts...\n"

chmod -R u+x ../Scripts/
chmod u+x ./vim/vim.sh

operating_system=$(whichOS)
package_manager=$(whichPM)

# SETUP VIM EDITOR WITH BASIC PLUGINS AND CONFIGURATION
echo -e "<< Starting VIM preparation on target system >>"
$SHELL -c "./vim/vim.sh $operating_system $package_manager"
