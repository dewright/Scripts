#!/bin/bash

if [[ $1 == "--help" ]]; then
	echo "Usage: $0 [directory] [depth] [minimum size in MB] [max # of results]"
	exit 0

else

	if [[ $2 == "" ]]; then
	
		depth=""
		
	else
	
		depth="-d $2"
		
	fi
	
	if [[ $3 == "" ]]; then

		minsize=0

	else

		minsize=($3*1024)

	fi

	if [[ $4  == "" ]]; then

		du $depth 2>/dev/null $1 | sort -k 1nr | awk '$1>'$minsize' { printf "%4.1f GB %-s\n", ($1/1024/1024),$2 }'

	else

		du $depth 2>/dev/null $1 | sort -k 1nr | awk '$1>'$minsize' { printf "%4.1f GB %-s\n", ($1/1024/1024),$2 }' | head -$4

	fi

fi
