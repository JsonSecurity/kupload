#!/bin/bash

if [[ ! $1 ]];then
	echo -e "\n$0 http://<host>/server.php <line>"
	exit 1
fi

if [[ ! $2 ]];then
	start=1
else
	start=$2
fi

files=$(ls -1 | wc -l)
peso=$(du -ch * | grep total | awk '{print $1}')

R="\e[38;2;245;11;132m"
W="\e[0m"
A="${W}[${R}*${W}]"

echo -e """$R
 |     _ | _  _  _|
 |<|_||_)|(_)(_|(_|
     |$W           

   $A SIZE:$R $peso$W
   $A FILES:$R $files$W
   $A START:$R $start$W
"""
echo -e "\n $A Starting...\n"

for ((i=start; i<=files; i++));do
	FILE=$(ls -1 | awk "NR==$i")

	echo -e "$W [${R}FILE${W}]$W $FILE"

	status_code=$(curl -s -o /dev/null -w "%{http_code}" -k -X POST "$1" -F "archivo=@$FILE")
	
	if [[ ! $status_code -eq 200 ]]; then
	    echo -e "\n $A Error: $status_code\n"
	    exit
	fi
done

echo -e "\n $A Finish...\n"
