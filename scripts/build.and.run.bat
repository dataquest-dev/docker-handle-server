cd ..
docker build -f Dockerfile . -t hs && docker run -p 8000:8000 --rm -it hs
pause