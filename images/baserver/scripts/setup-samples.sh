set -e

if [ ! -f $PENTAHO_HOME/.samples_touched ]; then
  # BioMe2
  mkdir -p $APPS_HOME/biome2
  unzip -q /tmp/biome_60_solution_20150928.zip -d $APPS_HOME/biome2
  rm -f /tmp/biome_60_solution_20150928.zip

  # 1.  Add a new template to Interactive
  # Copy PIR files
  cp $APPS_HOME/biome2/bioMe/30-Reports/templates/* $PENTAHO_HOME/server/biserver-ee/pentaho-solutions/system/pentaho-interactive-reporting/resources/templates

  # Add template_my_green_template=BioMe Template line at the end of file
  perl -0777 -i -pe 's/$/\ntemplate_my_green_template=BioMe Template/' $PENTAHO_HOME/server/biserver-ee/pentaho-solutions/system/pentaho-interactive-reporting/resources/messages/messages.properties

  # 2.  Enable BA Server to import TT
  #
  perl -0777 -i -pe 's/\"localeExportList\">\n(\s+)i?<list>/\"localeExportList\">\n$1<list>\n$1\t<value>\.eot<\/value>\n$1\t<value>\.ttf<\/value>\n$1\t<value>\.woff<\/value>\n$1\t<value>\.otf<\/value>$1\t/smg' $PENTAHO_HOME/server/biserver-ee/pentaho-solutions/system/importExport.xml

  #
  perl -0777 -i -pe 's/LocaleImportHandler\"\/>(.*)?<list>\n(\s+)/LocaleImportHandler\"\/>$1\n$2<list>\n$2<value>eot<\/value>\n$2<value>ttf<\/value>\n$2<value>woff<\/value>\n$2<value>otf<\/value>\n$2/smg' $PENTAHO_HOME/server/biserver-ee/pentaho-solutions/system/importExport.xml

  #
  perl -0777 -i -pe 's/\"convertersMap\">\n(\s+)?/\"convertersMap\">\n$1<entry key=\"eot\" value-ref=\"streamConverter\"\/>\n$1<entry key=\"ttf\" value-ref=\"streamConverter\"\/>\n$1<entry key=\"woff\" value-ref=\"streamConverter\"\/>\n$1<entry key=\"otf\" value-ref=\"streamConverter\"\/>\n$1/smg' $PENTAHO_HOME/server/biserver-ee/pentaho-solutions/system/importExport.xml
  #
  #perl -0777 -i -pe 's/RepositoryFileImportFileHandler\">\n(\s+)?<MimeTypeDefinitions>/RepositoryFileImportFileHandler\">\n$1<MimeTypeDefinitions>\n$1<MimeTypeDefinition mimeType=\"application\/x-font-woff\" hidden=\"true\">\n$1\t<extension>woff<\/extension>\n$1<\/MimeTypeDefinition>\n$1<MimeTypeDefinition mimeType=\"application\/vnd.ms-fontobject\" hidden=\"false\">\n$1\t<extension>eot<\/extension>\n$1<\/MimeTypeDefinition>\n$1<MimeTypeDefinition mimeType=\"application\/x-font-otf\" hidden=\"false\">\n$1\t<extension>otf<\/extension>\n$1<\/MimeTypeDefinition>\n$1<MimeTypeDefinition mimeType=\"application\/octet-stream\" hidden=\"false\">\n$1\t<extension>ttf<\/extension>\n$1<\/MimeTypeDefinition>$1/smg' $PENTAHO_HOME/server/biserver-ee/pentaho-solutions/system/ImportHandlerMimeTypeDefinitions.xml

  #3. Changing pentaho ports / authentication
  # When BA Server has a different
  perl -0777 -i -pe 's/localhost/conx\.dev/smg' $PENTAHO_HOME/server/biserver-ee/pentaho-solutions/system/CLP/endpoints/kettle/list_files.ktr
  perl -0777 -i -pe 's/8080/8180/smg' $PENTAHO_HOME/server/biserver-ee/pentaho-solutions/system/CLP/endpoints/kettle/list_files.ktr
  #
  # kettle.properties
  #sed -i 's|BIOMEV2_APP|'${BIOMEV2_APP}'|g' $PENTAHO_HOME/.kettle/kettle.properties

  # repositories.xml
  #sed -i 's|PDI_SERVER_HOST|'${PDI_SERVER_HOST}'|g' $PENTAHO_HOME/.kettle/repositories.xml
  #sed -i 's|PDI_SERVER_PORT|'${PDI_SERVER_PORT}'|g' $PENTAHO_HOME/.kettle/repositories.xml
  #sed -i "s/PDI_SERVER_HOST/$PDI_SERVER_HOST/g" $PENTAHO_HOME/$PENTAHO_HOME/.kettle/repositories.xml
  #sed -i "s/PDI_SERVER_PORT/$PDI_SERVER_PORT/g" $PENTAHO_HOME/$PENTAHO_HOME/.kettle/repositories.xml
  #sh -c 'cd $PENTAHO_HOME/tools/data-integration && ./import.sh -rep="${PDI_SERVER_HOST}_${PDI_SERVER_PORT}" -user=admin -pass=password -dir=/ -file=${BIOMEV2_APP}/biome_dataservice.ktr -rules=./import-rules.xml -coe=false -replace=true -comment="Imported by Docker"'

  touch $PENTAHO_HOME/.samples_touched
fi