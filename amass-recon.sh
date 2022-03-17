#!/bin/bash

if [[ -a $1 ]]
then
	foreach domain in `cat ~/targets/xiaomi/xiaomi-seeds.md`; do
		mkdir ~/targets/xiaomi/$domain
		./amass-recon.sh enum -brute -o ~/targets/xiaomi/$domain/$domain.md -d $domain -v;
	done
else
	echo './amass.sh FILENAME'
fi
