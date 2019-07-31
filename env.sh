#!/bin/sh

# shellcheck disable=SC2034
CHEDIR=/home/mvala/dev/che

getKubeChePod() {
	kubectl get pods -n che | grep -P 'che-' | cut -d' ' -f1
}
