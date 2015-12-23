#!/bin/sh
#echo $LD_LIBRARY_PATH | egrep "/opt2/pentaho/pentaho-6.0.0/common" > /dev/null
#if [ $? -ne 0 ] ; then
#PATH="/opt2/pentaho/pentaho-6.0.0/java/bin:/opt2/pentaho/pentaho-6.0.0/postgresql/bin:/opt2/pentaho/pentaho-6.0.0/common/bin:$PATH"
#export PATH
#LD_LIBRARY_PATH="/opt2/pentaho/pentaho-6.0.0/postgresql/lib:/opt2/pentaho/pentaho-6.0.0/common/lib:$LD_LIBRARY_PATH"
#export LD_LIBRARY_PATH
#fi

#TERMINFO=/opt2/pentaho/pentaho-6.0.0/common/share/terminfo
#export TERMINFO
##### JAVA ENV #####
JAVA_HOME=/opt2/pentaho/pentaho-6.0.0/java
export JAVA_HOME

##### POSTGRES ENV #####


PENTAHO_JAVA_HOME=/opt2/pentaho/pentaho-6.0.0/java
export PENTAHO_JAVA_HOME
PENTAHO_HOME=/opt2/pentaho/pentaho-6.0.0
export PENTAHO_HOME
PENTAHO_INSTALLED_LICENSE_PATH=/opt2/pentaho/pentaho-6.0.0/.installedLicenses.xml
export PENTAHO_INSTALLED_LICENSE_PATH


. /opt2/pentaho/pentaho-6.0.0/scripts/build-setenv.sh
