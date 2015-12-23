# Update config files

set -e

if [ ! -f ${PENTAHO_HOME}/.touched ]; then

  sed -i "s/localhost/$PGHOST/g" $CATALINA_HOME/webapps/pentaho/META-INF/context.xml
  sed -i "s/localhost/$PGHOST/g" $PENTAHO_HOME/server/biserver-ee/pentaho-solutions/system/jackrabbit/repository.xml
  sed -i "s/localhost/$PGHOST/g" $PENTAHO_HOME/server/biserver-ee/pentaho-solutions/system/hibernate/postgresql.hibernate.cfg.xml

  # TODO: Use perl
  sed -i '/<param-name>solution-path<\/param-name>.*/ {N; s#\(<param-name>solution-path<\/param-name>\).*<\/param-value>#\1\n\t\t<param-value>'"${PENTAHO_HOME}/server/biserver-ee/pentaho-solutions"'<\/param-value>#}' $CATALINA_HOME/webapps/pentaho/WEB-INF/web.xml

  # Add marketplace
  perl -0777 -i -pe 's/featuresBoot\=(.*)$/featuresBoot\=$1\,pentaho-marketplace/mg' $PENTAHO_HOME/server/biserver-ee/pentaho-solutions/system/karaf/etc/org.apache.karaf.features.cfg

  # =======================
  # Enable CDE/CDF plugins: http://forums.pentaho.com/showthread.php?197460-Where-is-CDE-in-Pentaho-6
  # =======================

  # Uncomment CDF plugin.xml
  # Go to pentaho-solutions/system/pentaho-cdf-dd and edit the plugin.xml file. You'll notice there are two commented blocks there (at line 20 and line 37). Uncomment those blocks.
  perl -0777 -i -pe 's/<!--//mg' $PENTAHO_HOME/server/biserver-ee/pentaho-solutions/system/pentaho-cdf-dd/plugin.xml
  perl -0777 -i -pe 's/-->//mg' $PENTAHO_HOME/server/biserver-ee/pentaho-solutions/system/pentaho-cdf-dd/plugin.xml

  #Uncomment settings.xml: Uncomment block at end of file (definining the new-toolbar-button).
  perl -0777 -i -pe 's/<!--\n(\s+<new-toolbar-button>.*<\/new-toolbar-button>)\n-->/$1/mg' $PENTAHO_HOME/server/biserver-ee/ pentaho-solutions/system/pentaho-cdf-dd/settings.xml

  #Uncomment CDE plugin.xml
  perl -0777 -i -pe 's/<!--//mg' $PENTAHO_HOME/server/biserver-ee/pentaho-solutions/system/cde/plugin.xml
  perl -0777 -i -pe 's/-->//mg' $PENTAHO_HOME/server/biserver-ee/pentaho-solutions/system/cde/plugin.xml


  # Get rid of sample data and disable HSQLDB
  rm -f ${PENTAHO_HOME}/server/biserver-ee/pentaho-solutions/system/default-content/*.zip
  perl -0777 -i -pe 's/(<!-- \[BEGIN HSQLDB DATABASES\] -->)(.*)(<!-- \[END HSQLDB DATABASES\] -->)/$1\n    <!--    $2-->\n    $3/smg' $CATALINA_HOME/webapps/pentaho/WEB-INF/web.xml
  perl -0777 -i -pe 's/(<!-- \[BEGIN HSQLDB STARTER\] -->)(.*)(<!-- \[END HSQLDB STARTER\] -->)/$1\n    <!--    $2-->\n    $3/smg' $CATALINA_HOME/webapps/pentaho/WEB-INF/web.xml
  touch ${PENTAHO_HOME}/.touched

fi

if [ "${TOMCAT_DEBUG}" = "true" ]; then
  echo
  echo "==== Tomcat Debug ENABLED ===="
  export CATALINA_OPTS="${CATALINA_OPTS} -Xdebug -Xrunjdwp:transport=dt_socket,address=8001,server=y,suspend=n"
fi

# Set up the database and start PBA
#sh setup-postgres-creds.sh
sh setup-ssh.sh
sh setup-postgres.sh
sh setup-ee-licenses.sh
#if [ "${CLUSTERED}" ]; then sh setup-clustering.sh; fi
sh run.sh
