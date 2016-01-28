FROM tomcat:8.0

MAINTAINER mduduzi.keswa@gmail.com

# Set up environment
ENV PENTAHO_HOME=/opt2/pentaho
ENV CATALINA_HOME=/usr/local/tomcat
ENV PENTAHO_VERSION=6.0.1.0-386


# Components to be installed
ENV COMPONENTS=pdi-manual-ee:pdi-ee-client
ENV COMPONENTS_DIR=/tmp/components
ENV APPS_HOME=${PENTAHO_HOME}/applications
ENV BIOMEV2_APP=${APPS_HOME}/biome2/etl

# Set up JAVA_HOME
RUN . /etc/environment
ENV JAVA_HOME /usr/lib/jvm/java-1.7.0-openjdk-amd64
ENV PENTAHO_JAVA_HOME ${JAVA_HOME}

# Install Dependences
RUN apt-get update && apt-get install -y \
    git \
    netcat \
    postgresql-client-9.4 \
    unzip \
    wget \
    ; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Get PBA EE
COPY build /tmp/
COPY samples /tmp/
RUN ls /tmp/
COPY scripts ${PENTAHO_HOME}/scripts/
# Auto login to postgres
ADD pgpass ${PENTAHO_HOME}/.pgpass
USER root
RUN chmod 0600 ${PENTAHO_HOME}/.pgpass
#COPY rds ${PENTAHO_HOME}/rds/
#COPY cluster ${PENTAHO_HOME}/cluster/

# COPY kettle.properties
COPY kettle_home ${PENTAHO_HOME}/.kettle

# Postgres driver
ADD https://jdbc.postgresql.org/download/postgresql-9.4-1201.jdbc41.jar ${CATALINA_HOME}/lib/

RUN useradd -s /bin/bash -d ${PENTAHO_HOME} pentaho; \
    chown -R pentaho:pentaho ${PENTAHO_HOME} ${CATALINA_HOME} /tmp
USER pentaho

################################################################################
# NOTE: Owning /tmp up front and passing the Pentaho files in already unzipped #
# shaves almost 2GB from the image.                                            #
################################################################################

# Unzip components, removing the archives as we go
RUN for PKG in $(echo ${COMPONENTS} | tr ':' '\n'); \
     do echo "Unzipping $PKG-${PENTAHO_VERSION}-dist.zip..."; \
     unzip -uo /tmp/$PKG-${PENTAHO_VERSION}-dist.zip -d /tmp; \
     rm -rf /tmp/$PKG-${PENTAHO_VERSION}-dist.zip; \
     done

WORKDIR /tmp

# Run the PDI Server installers headless
RUN for DIR in $(ls -d *pdi-manual*); \
    do sh ${PENTAHO_HOME}/scripts/run-installer.sh ${DIR} ${COMPONENTS_DIR}> /dev/null 2>&1; \
    chown -R pentaho ${DIR}; \
    rm -rf ${DIR}; \
    done

# Run the PDI Tools installers headless
RUN mkdir -p ${PENTAHO_HOME}/tools
RUN for DIR in $(ls -d *pdi*client*); \
    do sh ${PENTAHO_HOME}/scripts/run-installer.sh ${DIR} ${PENTAHO_HOME}/tools> /dev/null 2>&1; \
    chown -R pentaho ${DIR}; \
    rm -rf ${DIR}; \
    done

#########################################################################################
# Explode the wars in advance so that we can update files without having to boot Tomcat #
#########################################################################################

WORKDIR ${COMPONENTS_DIR}

RUN ls -d *

#=== DI SERVER
RUN DISERVER_DIR=$(ls -d * | grep pdi-manual | sed 's/\///'); \
    mkdir -p ${APPS_HOME}; \
    mkdir -p ${PENTAHO_HOME}/server/data-integration-server; \
    unzip -q ${DISERVER_DIR}/di-license-installer.zip -d ${PENTAHO_HOME}; \
    rm -rf ${DISERVER_DIR}/di-license-installer.zip; \
    unzip -q ${DISERVER_DIR}/di-jdbc-distribution-utility.zip -d ${PENTAHO_HOME}/server; \
    rm -rf ${DISERVER_DIR}/di-jdbc-distribution-utility.zip; \
    unzip -q ${DISERVER_DIR}/di-pentaho-data.zip -d ${PENTAHO_HOME}/server/data-integration-server; \
    rm -rf ${DISERVER_DIR}/di-pentaho-data.zip; \
    unzip -q ${DISERVER_DIR}/di-pentaho-solutions.zip -d ${PENTAHO_HOME}/server/data-integration-server; \
    rm -rf ${DISERVER_DIR}/di-pentaho-solutions.zip; \
    mkdir -p ${CATALINA_HOME}/webapps/pentaho-di; \
    unzip -q ${DISERVER_DIR}/pentaho-di.war -d ${CATALINA_HOME}/webapps/pentaho-di; \
    rm -rf ${DISERVER_DIR}/pentaho-di.war; \
    unzip -q ${DISERVER_DIR}/pentaho-style.war -d ${CATALINA_HOME}/webapps/pentaho-style; \
    rm -rf ${DISERVER_DIR}/pentaho-style.war; \
    cp ${DISERVER_DIR}/PentahoDataIntegration_OSS_Licenses.html ${PENTAHO_HOME}/server/data-integration-server; \
    rm ${DISERVER_DIR}/PentahoDataIntegration_OSS_Licenses.html; \
    rm -rf ${DISERVER_DIR}

# Hackaround for docker/docker#4570
RUN cp -r * ${PENTAHO_HOME}/server/data-integration-server/pentaho-solutions/system; \
    rm -rf *

RUN ls
RUN ln -s ${CATALINA_HOME} ${PENTAHO_HOME}/server/data-integration-server/tomcat

VOLUME ["${PENTAHO_HOME}"]


#######################
# Copy EE Licenses #
#######################
ENV PENTAHO_INSTALLED_LICENSE_PATH=${PENTAHO_HOME}/.pentaho/.installedLicenses.xml
#COPY licenses/installedLicenses_ee.xml ${PENTAHO_HOME}/.installedLicenses.xml
COPY licenses/oem ${PENTAHO_HOME}/licenses/


#######################
# Expose ports #
#######################
EXPOSE 8080 22

#######################
# Start the BA Server #
#######################

WORKDIR ${PENTAHO_HOME}/scripts

VOLUME ["${CATALINA_HOME}/logs"]

CMD ["sh", "startup.sh"]