FROM camunda/camunda-bpm-platform:tomcat-7.14.0

# Copy third-party Java libraries
COPY docker/camunda/lib/* lib

# Remove examples
RUN rm -r webapps/camunda-invoice && rm -r webapps/h2 && rm -r webapps/examples && rm -r webapps/ROOT && rm -r webapps/docs && rm -r webapps/manager && rm -r webapps/host-manager