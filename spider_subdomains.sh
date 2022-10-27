#!/bin/bash

[[ -z $@ ]] && echo "give me a project name, and make sure to create a PROJECT-seeds.md file inside there!" && exit 1

PROJECT=$1

cd ~/recon/$PROJECT/

echo "running gospider on seed domains"
for domain in `cat $PROJECT-seeds.md`; do
	gospider -s "https://$domain" -o $domain-gospider --threads 20 --concurrent 10 --depth 5 --other-source --include-other-source --subs --include-subs --sitemap --robots
done
