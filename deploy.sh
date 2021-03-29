#!/bin/bash

docker build -t jkjar/multi-client:latest -t jkjar/multi-client:"$GIT_SHA" -f ./client/Dockerfile ./client
docker build -t jkjar/multi-server:latest -t jkjar/multi-server:"$GIT_SHA" -f ./server/Dockerfile ./server
docker build -t jkjar/multi-worker:latest -t jkjar/multi-worker:"$GIT_SHA" -f ./worker/Dockerfile ./worker

docker push jkjar/multi-client:latest
docker push jkjar/multi-server:latest
docker push jkjar/multi-worker:latest
docker push jkjar/multi-client:"$GIT_SHA"
docker push jkjar/multi-server:"$GIT_SHA"
docker push jkjar/multi-worker:"$GIT_SHA"

kubectl apply -f ./k8s/

kubectl set image deployments/client-deployment client=jkjar/multi-client:"$GIT_SHA"
kubectl set image deployments/server-deployment server=jkjar/multi-server:"$GIT_SHA"
kubectl set image deployments/worker-deployment worker=jkjar/multi-worker:"$GIT_SHA"