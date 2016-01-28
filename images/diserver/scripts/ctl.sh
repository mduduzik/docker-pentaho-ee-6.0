#!/bin/sh

TOMCAT_BINDIR=$CATALINA_HOME/bin
JRE_HOME=$JAVA_HOME
TOMCAT_STATUS=""
ERROR=0

#unset DYLD_LIBRARY_PATH


start_tomcat() {
    export DI_HOME="$PENTAHO_HOME/server/data-integration-server/pentaho-solutions/system/kettle"
    export KETTLE_HOME="$PENTAHO_HOME"

    export JAVA_OPTS="-Dpentaho.installed.licenses.file=$PENTAHO_INSTALLED_LICENSE_PATH -DKETTLE_HOME=$KETTLE_HOME -DDI_HOME=$DI_HOME -Xms1024m -Xmx2048m -XX:MaxPermSize=256m -Dsun.rmi.dgc.client.gcInterval=3600000 -Dsun.rmi.dgc.server.gcInterval=3600000 -Djava.awt.headless=true"

    if [ "${TOMCAT_DEBUG}" = "true" ]; then
        echo
        echo "==== Tomcat Debug ENABLED ===="
        export JAVA_OPTS="${JAVA_OPTS} -Xdebug -Xrunjdwp:transport=dt_socket,address=8001,server=y,suspend=n"
        echo "==== Tomcat JAVA_OPTS: $JAVA_OPTS"
      else
        echo
        echo "==== Tomcat Debug DISABLED ===="
        echo "==== Tomcat JAVA_OPTS: $JAVA_OPTS"
    fi
    export JAVA_HOME=$JRE_HOME
    $TOMCAT_BINDIR/catalina.sh run

    if [ $? -eq 0 ];  then
        echo "$0 $ARG: data-integration-server started"
    else
        echo "$0 $ARG: data-integration-server could not be started"
        ERROR=1
    fi
}

stop_tomcat() {
    $TOMCAT_BINDIR/catalina.sh stop
    if [ $? -eq 0 ]; then
        echo "$0 $ARG: data-integration-server stopped"
        sleep 3
    else
        echo "$0 $ARG: data-integration-server could not be stopped"
        ERROR=2
    fi
}

if [ "x$1" = "xstart" ]; then
    start_tomcat
    sleep 2
elif [ "x$1" = "xstop" ]; then
    stop_tomcat
    sleep 2
fi