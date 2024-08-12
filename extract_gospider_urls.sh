#!/bin/bash

jq -r 'select(.status != 0 and .status != 404)|.output' $1
