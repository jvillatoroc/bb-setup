#!/bin/bash

[[ -z $@ ]] && echo "domains.txt file missing!" && exit 1

echo "running gospider on seed domains"
for domain in `cat domains.txt`; do
	gospider -s "https://$domain" -o gospider --threads 20 --concurrent 10 --depth 10 --other-source --include-other-source --subs --include-subs --sitemap --robots --json
done
