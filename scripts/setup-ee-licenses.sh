#! /bin/bash

set -e

#export PENTAHO_INSTALLED_LICENSE_PATH=~/.installedLicenses.xml

cd ${PENTAHO_HOME}/licenses
${PENTAHO_HOME}/server/license-installer/install_license.sh install -q Pentaho\ Analysis\ Enterprise\ Edition.lic
${PENTAHO_HOME}/server/license-installer/install_license.sh install -q Pentaho\ BI\ Platform\ Enterprise\ Edition.lic
${PENTAHO_HOME}/server/license-installer/install_license.sh install -q Pentaho\ Dashboard\ Designer.lic
${PENTAHO_HOME}/server/license-installer/install_license.sh install -q Pentaho\ Mobile.lic
${PENTAHO_HOME}/server/license-installer/install_license.sh install -q Pentaho\ PDI\ Enterprise\ Edition.lic
${PENTAHO_HOME}/server/license-installer/install_license.sh install -q Pentaho\ Reporting\ Enterprise\ Edition.lic