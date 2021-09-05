#!/bin/bash

# Create directory if it doesn't exist
BASE=${HOME}/croot
mkdir -p ${BASE}

cat <<EOF >./kind-config-with-mounts.yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  extraMounts:
  - hostPath: ${BASE}/
    containerPath: /croot
- role: worker
  extraMounts:
  - hostPath: ${BASE}/
    containerPath: /croot
EOF

