#!/usr/bin/env sh
ENV=$1

echo "Building for environment ${ENV}"

rm -rf deployment || true

vortex --template templates --output deployment -varpath ./environments/${ENV}.yaml
