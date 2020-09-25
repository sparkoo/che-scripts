#!/bin/sh

# shellcheck disable=SC2034
CHEDIR=/home/mvala/dev/che
CHETHEIADIR=/home/mvala/dev/che-theia
CHEDOCSDIR=/home/mvala/dev/che-docs
CHEPLUGINREGISTRYDIR=/home/mvala/dev/che-plugin-registry
CHEDEVFILEREGISTRYDIR=/home/mvala/dev/che-devfile-registry
CHEOPERATORDIR=/home/mvala/dev/go/src/github.com/eclipse/che-operator

PRIVATE_DOCKERREGISTRY=quay.io/mvala

getKubeChePod() {
	kubectl get pods -n che | grep -P 'che-' | grep -v 'operator' | grep 'Running' | cut -d' ' -f1
}

getOcChePod() {
  oc get pods -n che |  grep -P 'che-[0-9a-f]*-[0-9a-z]*'| cut -d' ' -f1
}

getCurrentBranch() {
  cat ${CHEDIR}/.git/HEAD | cut -d'/' -f3
}
