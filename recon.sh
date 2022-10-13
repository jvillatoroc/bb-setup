#!/bin/bash

[[ -z $@ ]] && echo "give me a project name, and make sure to create a PROJECT-seeds.md file inside there!" && exit 1

PROJECT=$1

cd ~/recon/$PROJECT/

echo "running amass on $PROJECT\'s seed domains"
for domain in `cat $PROJECT-seeds.md`; do
	# if the file doesn't exist, create the directory and run
	# amass. If it does, skip and move on to the next seed
	# domain
	[[ ! -a $domain/$domain.txt ]] && \
		mkdir -p $domain && \
		amass enum -brute -o $domain/$domain.txt -d $domain -v

	echo "running hakrawler on $domain"
	echo $domain | httprobe | hakrawler | tee -a $domain/$domain-hakrawler.txt
done

echo "running gospider and feroxbuster on subdomains"
for domain in `cat $PROJECT-seeds.md`; do
	for subdomain in `cat $domain/$domain.txt`; do
		gospider -s "https://$subdomain" -o $subdomain/gospider --threads 20 --concurrent 10 --depth 5 --other-source --include-subs --robots
		feroxbuster -u $subdomain -k --redirects --depth 5 --extract-links --force-recursion -w ~/tools/commonspeak2-wordlists/wordswithext/words.txt -o $domain/$subdomain-feroxbuster-words.txt -vv
	done
done

