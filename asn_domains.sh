#!/bin/bash

[[ -z $@ ]] && echo "I need a project name and to have a PROJECT-ASNs.md file!" && exit 1

PROJECT=$1

cd ~/recon/$PROJECT/

echo "getting domains from $PROJECT's ASN numbers"
for ASN in `cat $PROJECT-ASNs.md`; do
	mkdir $ASN
	amass intel -asn $ASN -o $ASN/$ASN-domains
done
