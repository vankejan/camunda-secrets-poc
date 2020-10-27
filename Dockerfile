FROM camunda/camunda-bpm-platform:tomcat-7.14.0

# add custom configurations
COPY docker/camunda/conf/ conf

# Copy third-party Java libraries
COPY docker/camunda/lib/* lib