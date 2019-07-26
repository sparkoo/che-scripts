#!/bin/sh

CHEDIR=/home/mvala/dev/che

function getKubeChePod() {
	echo `kubectl get pods -n che | grep -P 'che' | cut -d' ' -f1`
}
