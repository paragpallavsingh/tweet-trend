#!/bin/sh
kubectl destroy -f secret.yaml
kubectl destroy -f deployment.yaml
kubectl destroy -f service.yaml
kubectl destroy -f namespace.yaml
