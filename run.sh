#!/bin/sh

docker build . -t repository
docker run -d -p  50080:80 repository
