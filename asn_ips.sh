#!/bin/bash

[[ -z $@ ]] && echo "I need a project name and to have a PROJECT-ASNs.md file!" && exit 1

PROJECT=$1

cd ~/recon/$PROJECT/

echo "getting IPs from $PROJECT's ASN numbers"
for ASN in `cat asns.txt`; do
	amass intel -asn $ASN -ip -o ips.txt
done
