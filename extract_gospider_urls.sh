#!/bin/bash

jq '.type="url"|.output' $1 | sed 's/"//; s/"$//'
