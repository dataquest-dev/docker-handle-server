# Status

# Overview

Dockerized https://github.com/DSpace/Remote-Handle-Resolver.

## Installation

1. Generate your own configuration by running:
```
docker run --rm -it -v %cd%:/app/ alpine/java:22-jdk /bin/sh /app/assets/handle-9.3.1/bin/hdl-setup-server /app/assets/config
```
or 
```
docker run --rm -it -v $(pwd):/app/ alpine/java:22-jdk /bin/sh /app/assets/handle-9.3.1/bin/hdl-setup-server /app/assets/config
```

2. Update handle-dspace-plugin.cfg and/or other files in assets/config. Verify config.dct has correct prefix values.

3. Make sure that dspace backend is running with, see https://wiki.lyrasis.org/display/DSDOC7x/Handle.Net+Registry+Support

```
handle.remote-resolver.enabled = true
```
e.g., https://dev-5.pc:8443/server/listhandles/123456789 should work

## Installation production using provided images

```
docker run --rm -it ghcr.io/dataquest-dev/docker-handle-server:latest /bin/sh /app/hs/bin/hdl-setup-server .
```


# Structure

* Dockerfile - multi-stage build, builds plugin, creates handle server with provided configs,
* Dockerfile.fast - creates handle server with provided configs,
* Dockerfile.build - builds plugin, copies .jar to assets/lib/
