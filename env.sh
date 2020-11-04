#!/bin/sh

set +x

CHEDIR=/home/mvala/dev/che
CHETHEIADIR=/home/mvala/dev/che-theia
CHEDOCSDIR=/home/mvala/dev/che-docs
CHEPLUGINREGISTRYDIR=/home/mvala/dev/che-plugin-registry
CHEDEVFILEREGISTRYDIR=/home/mvala/dev/che-devfile-registry
CHEOPERATORDIR=/home/mvala/dev/che-operator

CHE_NAMESPACE=che

PRIVATE_DOCKERREGISTRY=quay.io/mvala

# openshift credentials for crc
OPENSHIFT_ADMIN_USER=kubeadmin
OPENSHIFT_ADMIN_PASS=$( $( dirname "${0}" )/che-cpass )

OPENSHIFT_REGISTRY_USER=developer
OPENSHIFT_REGISTRY_PASS=developer

OPENSHIFT_USER=developer
OPENSHIFT_USER_PASS=developer

OPENSHIFT_CLUSTER_URL=https://api.crc.testing:6443

# override anything in this script
if [ -f /tmp/env-openshift.sh ]; then
  source /tmp/env-openshift.sh
fi

getChePod() {
  kubectl get pods -l=app=che,component=che -o name -n ${CHE_NAMESPACE} --field-selector status.phase=Running
}

getBranch() {
  cat ${1}/.git/HEAD | cut -d'/' -f3
}

getCurrentBranch() {
  getBranch ${CHEDIR}
}

getCurrentCheopBranch() {
  getBranch ${CHEOPERATORDIR}
}

