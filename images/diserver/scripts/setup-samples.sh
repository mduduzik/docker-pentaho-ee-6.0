set -e

if [ ! -f $PENTAHO_HOME/.samples_touched ]; then
  # BioMe2
  mkdir -p $APPS_HOME/biome2
  unzip -q /tmp/biome_60_etl_20150928.zip -d $APPS_HOME/biome2
  rm -f /tmp/biome_60_etl_20150928.zip

  # kettle.properties
  sed -i 's|BIOMEV2_APP|'${BIOMEV2_APP}'|g' $PENTAHO_HOME/.kettle/kettle.properties

  # repositories.xml
  sed -i 's|PDI_SERVER_HOST|'${PDI_SERVER_HOST}'|g' $PENTAHO_HOME/.kettle/repositories.xml
  sed -i 's|PDI_SERVER_PORT|'${PDI_SERVER_PORT}'|g' $PENTAHO_HOME/.kettle/repositories.xml
  #sed -i "s/PDI_SERVER_HOST/$PDI_SERVER_HOST/g" $PENTAHO_HOME/$PENTAHO_HOME/.kettle/repositories.xml
  #sed -i "s/PDI_SERVER_PORT/$PDI_SERVER_PORT/g" $PENTAHO_HOME/$PENTAHO_HOME/.kettle/repositories.xml
  #sh -c 'cd $PENTAHO_HOME/tools/data-integration && ./import.sh -rep="${PDI_SERVER_HOST}_${PDI_SERVER_PORT}" -user=admin -pass=password -dir=/ -file=${BIOMEV2_APP}/biome_dataservice.ktr -rules=./import-rules.xml -coe=false -replace=true -comment="Imported by Docker"'

  touch $PENTAHO_HOME/.samples_touched
fi