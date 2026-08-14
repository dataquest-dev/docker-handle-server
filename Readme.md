# Status
[![☃ build-and-publish](https://github.com/dataquest-dev/docker-handle-server/actions/workflows/ci.yml/badge.svg)](https://github.com/dataquest-dev/docker-handle-server/actions/workflows/ci.yml)

# Overview

Dockerized https://github.com/DSpace/Remote-Handle-Resolver.

The Handle server runs as a **standalone service** and resolves handles through
the DSpace backend REST API — it does not connect to the database itself:

```
client -> handle-server(:8000) --HTTP /server/resolve--> DSpace backend --> database
```

## Quick start (docker compose)

Clone & run — the container points the resolver plugin at your backend, waits
for it, and starts the Handle server:

```
git clone --recurse-submodules https://github.com/dataquest-dev/docker-handle-server.git
cd docker-handle-server
cp .env.example .env          # set DSPACE_HANDLE_ENDPOINT to your backend (…/server)
docker compose up -d
```

Requirements on the backend side:

```
handle.remote-resolver.enabled = true
```

Test a resolve once it is up (use a handle that exists in your repository):

```
curl http://localhost:8000/api/handles/123456789/0
```

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

1. pull image, recreate config (keys, ...), copy default configuration from the image
```
IMG=ghcr.io/dataquest-dev/docker-handle-server:latest

docker run --rm -it -v $(pwd):/app-share $IMG sh -c "cd /app/hs/bin/ && ./hdl-setup-server /app-share"
docker create --name temphs-plugin $IMG
docker cp temphs-plugin:/app/config/handle-dspace-plugin.cfg ./
docker cp temphs-plugin:/app/config/log4j-handle-plugin.properties ./
docker rm temphs-plugin
```

2. Update config.dct
```
...
  "server_config" = {

    "storage_type" = "CUSTOM"
    "storage_class" = "org.dspace.handle.MultiRemoteDSpaceRepositoryHandlePlugin"

    "server_admins" = (
...
```

3. Start it

```
docker run --pull=always --name hs --rm -v $(pwd):/app/config -p 8000:8000 $IMG sh -c "/app/hs/bin/hdl-server /app/config/"
```
go to http://XXX:8000/ and test with a PID in this format, `11234/1-5419`.

# Structure

* Dockerfile - multi-stage build, builds plugin, creates handle server with provided configs,
* Dockerfile.fast - creates handle server with provided configs,
* Dockerfile.build - builds plugin, copies .jar to assets/lib/
