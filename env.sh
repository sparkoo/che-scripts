#!/bin/sh

# shellcheck disable=SC2034
CHEDIR=/home/mvala/dev/che
CHETHEIADIR=/home/mvala/dev/che-theia
CHEDOCSDIR=/home/mvala/dev/che-docs
CHEPLUGINREGISTRYDIR=/home/mvala/dev/che-plugin-registry
CHEDEVFILEREGISTRYDIR=/home/mvala/dev/che-devfile-registry
CHEOPERATORDIR=/home/mvala/dev/go/src/github.com/eclipse/che-operator

CHE_NAMESPACE=che

PRIVATE_DOCKERREGISTRY=quay.io/mvala

OPENSHIFT_ADMIN_USER=kubeadmin
OPENSHIFT_ADMIN_PASS=

OPENSHIFT_REGISTRY_USER=developer
OPENSHIFT_REGISTRY_PASS=developer

OPENSHIFT_USER=developer
OPENSHIFT_USER_PASS=developer

if [ -f /tmp/env-openshift.sh ]; then
  source /tmp/env-openshift.sh
fi

getKubeChePod() {
	kubectl get pods -l=app=che,component=che -o name
}

getOcChePod() {
  oc get pods -n che |  grep -P 'che-[0-9a-f]*-[0-9a-z]*'| cut -d' ' -f1
}

getCurrentBranch() {
  cat ${CHEDIR}/.git/HEAD | cut -d'/' -f3
}
