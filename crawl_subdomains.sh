#!/bin/bash

[[ -z $@ ]] && echo "give me a project name, and make sure to create a PROJECT-seeds.md file inside there!" && exit 1

PROJECT=$1

cd ~/recon/$PROJECT/

echo "running hakrawler on $domain"
for domain in `cat $PROJECT-seeds.md`; do
	echo $domain | httprobe | hakrawler | sed '/javascript:void(0)/d' | sort -u| tee $domain.hakrawler
done
