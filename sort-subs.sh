#!/bin/bash

# sort subdomains that are listed in a file

[[ -z $@ ]] && echo "No filename provided... \n
        Usage: ./sort_subs file1 file2 ... filen" && exit 1

for file in $@; do
        awk -F'.' '{ print $5 "\t" $4 "\t" $3 "\t" $2 "\t" $1 }' $file |
                sort -u |
                awk -F'\t' '{ print $5 "." $4 "." $3 "." $2 "." $1 }' |
                sed 's/[\.]*$//g' > $file.txt
done
