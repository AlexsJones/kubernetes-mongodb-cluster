#!/bin/bash

docker build -t tibbar/gcsfuse:latest .
docker push tibbar/gcsfuse:latest
