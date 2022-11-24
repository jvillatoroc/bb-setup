#!/bin/bash

[[ -z $@ ]] && echo "give me a project name, and make sure to create a PROJECT-seeds.md file inside there!" && exit 1

PROJECT=$1

cd ~/recon/$PROJECT/

echo "running amass on $PROJECT's seed domains"
for domain in `cat $PROJECT-seeds.md`; do
	amass enum -brute -o $domain.txt -d $domain -w ~/tools/jhaddix/all.txt -v
done
