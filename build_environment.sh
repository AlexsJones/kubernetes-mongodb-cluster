#!/usr/bin/env sh
ENV=$1

echo "Building for environment ${ENV}"

rm -rf deployment || true

TMPFILE=$(mktemp)
/usr/bin/openssl rand -base64 741 > $TMPFILE
kubectl create secret generic shared-bootstrap-data --from-file=internal-auth-mongodb-keyfile=$TMPFILE --dry-run --namespace={{.namespace}} -o yaml > templates/secret.yaml
rm ${TMPFILE}

vortex --template templates --output deployment -varpath ./environments/${ENV}.yaml
