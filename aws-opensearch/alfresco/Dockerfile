ARG ALFRESCO_TAG
FROM quay.io/alfresco/alfresco-content-repository:${ALFRESCO_TAG}

ARG TOMCAT_DIR=/usr/local/tomcat
ARG ALF_DATA_DIR=${TOMCAT_DIR}/alf_data

USER root

# Increase Tomcat maxThreads value to 400 (200 by default)
RUN sed -i "s/\
[[:space:]]\+connectionTimeout=\"20000\"/\n\
  connectionTimeout=\"20000\"\n\
  maxThreads=\"400\"\n\
  /g" ${TOMCAT_DIR}/conf/server.xml

# License is provided as an external volume

# RUN echo 'log4j.logger.org.alfresco=DEBUG' >> /usr/local/tomcat/webapps/alfresco/WEB-INF/classes/log4j.properties
