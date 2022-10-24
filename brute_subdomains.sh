#!/bin/bash

[[ -z $@ ]] && echo "give me a project name, and make sure to create a PROJECT-seeds.md file inside there!" && exit 1

PROJECT=$1

cd ~/recon/$PROJECT/

echo "running amass on $PROJECT's seed domains"
for domain in `cat $PROJECT-seeds.md`; do
	# if the file doesn't exist, create the directory and run
	# amass. If it does, skip and move on to the next seed
	# domain
	[[ ! -a $domain/$domain.txt ]] && \
		mkdir -p $domain && \
		amass enum -brute -o $domain/$domain-subs -d $domain -w ~/tools/jhaddix/all.txt -v
done
