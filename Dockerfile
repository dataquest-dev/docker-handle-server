FROM maven:3.9.9-eclipse-temurin-22-alpine as builder
WORKDIR /build/
COPY Remote-Handle-Resolver /build
RUN ls -lah /build/ && \
    cd /build/ && \
    mvn clean install

FROM alpine/java:22-jdk
WORKDIR /app/

COPY assets/handle-9.3.1 /app/hs/
COPY assets/config/* /app/config/
COPY --from=builder /build/target/dspace-remote-handle-resolver*.jar /app/hs/lib/

RUN mkdir -p /app/logs && \
    sed -i 's/net\.handle\.server\.Main "\$@"/ \$HANDLEJAVACMD net.handle.server.Main "\$@"/' /app/hs/bin/hdl

env HANDLEJAVACMD=" -Dlog4j.debug=true -Dlog4j.configuration=file:///app/config/log4j-handle-plugin.properties -Ddspace.handle.plugin.configuration=/app/config/handle-dspace-plugin.cfg"

RUN ls -lah /app && \
    ls -lah /app/hs/

CMD [ "/app/hs/bin/hdl-server", "/app/config/" ]
