FROM tomcat:8.0

MAINTAINER mduduzi.keswa@gmail.com

# Set up environment
ENV PENTAHO_HOME=/opt2/pentaho
ENV CATALINA_HOME=/usr/local/tomcat
ENV PENTAHO_VERSION=6.0.1.0-386


# Components to be installed
ENV COMPONENTS=biserver-manual-ee:paz-plugin-ee:pdd-plugin-ee:pentaho-mobile-plugin:pir-plugin-ee
#ENV COMPONENTS=biserver-manual-ee
ENV PLUGINS=pentaho-cdf-dd
ENV COMPONENTS_DIR=/tmp/components
ENV PLUGINS_DIR=/tmp/plugins
ENV APPS_HOME=${PENTAHO_HOME}/applications

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
COPY build/manual /tmp/
COPY build/samples/*.zip /tmp/
RUN ls /tmp/
COPY scripts ${PENTAHO_HOME}/scripts/
# Auto login to postgres
ADD pgpass ${PENTAHO_HOME}/.pgpass
USER root
RUN chmod 0600 ${PENTAHO_HOME}/.pgpass
#COPY rds ${PENTAHO_HOME}/rds/
#COPY cluster ${PENTAHO_HOME}/cluster/

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
     unzip -qo /tmp/$PKG-${PENTAHO_VERSION}-dist.zip -d /tmp; \
     rm -rf /tmp/$PKG-${PENTAHO_VERSION}-dist.zip; \
     done

# Unzip plugins, removing the archives as we go
#RUN for PKG in $(echo ${PLUGINS} | tr ':' '\n'); \
#    do echo "Unzipping $PKG-${PENTAHO_VERSION}.zip..."; \
#     unzip -q /tmp/$PKG-${PENTAHO_VERSION}.zip -d ${PLUGINS_DIR}; \
#     rm -rf /tmp/$PKG-${PENTAHO_VERSION}.zip; \
#     done

RUN ls -la /tmp/CLP-15.10.21.zip

RUN echo "Unzipping CLP-15.10.21.zip... onto ${PLUGINS_DIR}"; \
     unzip -qo /tmp/CLP-15.10.21.zip -d ${PLUGINS_DIR}; \
     rm -f /tmp/CLP-15.10.21.zip;

# Install packages
WORKDIR /tmp
RUN ls -d *

# Run the installers headless
RUN for DIR in $(ls -d *${PENTAHO_VERSION}*); \
    do echo "Installing into ${COMPONENTS_DIR}/${DIR}..."; \
    sh ${PENTAHO_HOME}/scripts/run-installer.sh ${DIR} > /dev/null 2>&1; \
    rm -rf ${DIR}; \
    done


#########################################################################################
# Explode the wars in advance so that we can update files without having to boot Tomcat #
#########################################################################################
WORKDIR ${COMPONENTS_DIR}
RUN ls -d *

RUN BISERVER_DIR=$(ls -d * | grep biserver | sed 's/\///'); \
    mkdir -p ${CATALINA_HOME}/webapps/pentaho; \
    mkdir -p ${CATALINA_HOME}/webapps/pentaho-style; \
    unzip -q ${BISERVER_DIR}/pentaho.war -d ${CATALINA_HOME}/webapps/pentaho; \
    rm -rf ${BISERVER_DIR}/pentaho.war; \
    unzip -q ${BISERVER_DIR}/pentaho-style.war -d ${CATALINA_HOME}/webapps/pentaho-style; \
    rm -rf ${BISERVER_DIR}/pentaho-style.war; \
    mkdir -p ${PENTAHO_HOME}/server/biserver-ee; \
    unzip -q ${BISERVER_DIR}/pentaho-solutions.zip -d ${PENTAHO_HOME}/server/biserver-ee; \
    rm -rf ${BISERVER_DIR}/pentaho-solutions.zip; \
    unzip -q ${BISERVER_DIR}/pentaho-data.zip -d ${PENTAHO_HOME}/server/biserver-ee; \
    rm -rf ${BISERVER_DIR}/pentaho-data.zip; \
    unzip -q ${BISERVER_DIR}/license-installer.zip -d ${PENTAHO_HOME}/server; \
    rm -rf ${BISERVER_DIR}

# Hackaround for docker/docker#4570
RUN cp -r * ${PENTAHO_HOME}/server/biserver-ee/pentaho-solutions/system; \
    rm -rf *

#########################################################################################
# Explode plugins into system
#########################################################################################
WORKDIR ${PLUGINS_DIR}
RUN cp -r * ${PENTAHO_HOME}/server/biserver-ee/pentaho-solutions/system; \
    rm -rf *

RUN ls
RUN ln -s ${CATALINA_HOME} ${PENTAHO_HOME}/server/biserver-ee/tomcat

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

RUN echo ${CATALINA_HOME}/bin/catalina.sh
CMD ["sh", "startup.sh"]