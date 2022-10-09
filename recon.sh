#!/bin/bash

[[ -z $@ ]] && echo "give me a project name!" && exit 1

PROJECT=$1

cd ~/notas/02\ Proyectos/$PROJECT/

echo "running amass on $PROJECT\'s seed domains"
for domain in `cat $PROJECT-seeds.md`; do
	# if the file doesn't exist, create the directory and run
	# amass. If it does, skip and move on to the next seed
	# domain
	[[ ! -a $domain/$domain.txt ]] && \
		mkdir $domain && \
		amass enum -brute -o $domain/$domain.txt -d $domain -v
done

echo "running dirsearch and feroxbuster on subdomains"
for domain in `cat $PROJECT-seeds.md`; do
	for subdomain in `cat $domain/$domain.txt`; do
		python ~/tools/dirsearch/dirsearch.py -w ~/tools/SecLists/Discovery/Web-Content/raft-large-words.txt -u https://$subdomain/ --format plain -o $domain/$subdomain-dirsearch.txt
		feroxbuster -u $subdomain -k -r --depth 5 --scan-limit 2 -w ~/tools/SecLists/Discovery/Web-Content/raft-large-words.txt -o $domain/$subdomain-feroxbuster.txt -v
	done
done

