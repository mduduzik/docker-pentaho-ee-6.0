# Update config files

set -e

if [ ! -f ${PENTAHO_HOME}/.touched ]; then

  sed -i "s/localhost/$PGHOST/g" $CATALINA_HOME/webapps/pentaho-di/META-INF/context.xml
  sed -i "s/localhost/$PGHOST/g" $PENTAHO_HOME/server/data-integration-server/pentaho-solutions/system/jackrabbit/repository.xml
  sed -i "s/localhost/$PGHOST/g" $PENTAHO_HOME/server/data-integration-server/pentaho-solutions/system/hibernate/postgresql.hibernate.cfg.xml

  # Update solutions path in web.xml
  perl -0777 -i -pe 's/<param-name>solution-path.*<param-value><\/param-value>/<param-name>solution-path<\/param-name>\n\t\t<param-value>$ENV{'PENTAHO_HOME'}\/server\/data-integration-server\/pentaho-solutions<\/param-value>/smg' $CATALINA_HOME/webapps/pentaho-di/WEB-INF/web.xml

  # kettle.properties
  #sed -i "s/PENTAHO_HOME/$PENTAHO_HOME/g" $PENTAHO_HOME/server/data-integration-server/pentaho-solutions/system/kettle/kettle.properties

  # startup.sh: Add 'DI_HOME=$DIR/pentaho-solutions/system/kettle' before 'Check that target executable exists' line
  #perl -0777 -i -pe 's/# Check that target executable exists/$&\nDI_HOME\=$PENTAHO_HOME\/server\/data-integration-server\/pentaho-solutions\/system\/kettle\n/g' $CATALINA_HOME/bin/startup.sh

  #perl -0777 -i -pe 'print "DI_HOME\=$PENTAHO_HOME\/server\/data-integration-server\/pentaho-solutions\/system\/kettle" if(/Check that target executable exists/);' $CATALINA_HOME/bin/startup.sh

  # startup.sh: Add this line directly before the exec "$PRGDIR"/"$EXECUTABLE" start "$@"
  #perl -0777 -i -pe 's/exec \"\$PRGDIR\"\/\"\$EXECUTABLE\" start \"\$\@\"/$&\nexport CATALINA_OPTS\=\"\-Xms2048m \-Xmx2048m \-XX:MaxPermSize=256m \-Dsun\.rmi\.dgc\.client\.gcInterval=3600000 \-Dsun\.rmi\.dgc\.server\.gcInterval=3600000 \-Dpentaho\.installed\.licenses\.file=\$PENTAHO_INSTALLED_LICENSE_PATH \-DDI_HOME=\$DI_HOME\n/g' $CATALINA_HOME/bin/startup.sh

  #perl -0777 -i -pe 'print "export CATALINA_OPTS\=\"\-Xms2048m \-Xmx2048m \-XX:MaxPermSize=256m \-Dsun\.rmi\.dgc\.client\.gcInterval=3600000 \-Dsun\.rmi\.dgc\.server\.gcInterval=3600000 \-Dpentaho\.installed\.licenses\.file=\$PENTAHO_INSTALLED_LICENSE_PATH \-DDI_HOME=\$DI_HOME\"" if(/exec \"\$PRGDIR\"\/\"\$EXECUTABLE\" start \"\$\@\"/);' $CATALINA_HOME/bin/startup.sh

  touch ${PENTAHO_HOME}/.touched
fi

#if [ "${TOMCAT_DEBUG}" = "true" ]; then
# echo
#  echo "==== Tomcat Debug ENABLED ===="
#  export CATALINA_OPTS="${CATALINA_OPTS} -Xdebug -Xrunjdwp:transport=dt_socket,address=8001,server=y,suspend=n"
#fi

# Set up the database and start PBA
#sh setup-postgres-creds.sh
sh setup-ssh.sh
sh setup-postgres.sh
sh setup-ee-licenses.sh
sh setup-samples.sh
#if [ "${CLUSTERED}" ]; then sh setup-clustering.sh; fi
sh run.sh
