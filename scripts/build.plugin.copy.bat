cd ..
docker build -f Dockerfile.build . -t hs-plugin
docker create --name temphs-plugin hs-plugin
docker cp temphs-plugin:/build/target/dspace-remote-handle-resolver-1.1-SNAPSHOT.jar ./assets/lib/
docker rm temphs-plugin
pause