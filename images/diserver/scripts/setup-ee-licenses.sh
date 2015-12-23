#! /bin/bash

set -e

#export PENTAHO_INSTALLED_LICENSE_PATH=~/.installedLicenses.xml

cd ${PENTAHO_HOME}/licenses
${PENTAHO_HOME}/license-installer/install_license.sh install -q Pentaho\ PDI\ Enterprise\ Edition.lic
${PENTAHO_HOME}/license-installer/install_license.sh install -q Pentaho\ Hadoop\ Enterprise\ Edition.lic