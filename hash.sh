#!/bin/bash

clear

IJO='\e[92m'
MERAH='\e[91m'
KUNING='\e[93m'
CYAN='\e[96m'
NC='\e[0m'

hash(){
	email=$(echo $1 | grep -Eo "\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,6}\b")
	encrypt=$(echo $1 | grep -Eo "\b[A-Za-z0-9]{32,128}\b")
	getDecrypt=$(curl -s "https://lea.kz/api/hash/${encrypt}" -L)
	if [[ ! $getDecrypt =~ "404 Not Found" ]]; then
		getPass=$(echo $getDecrypt | grep -Po '(?<="password": ")[^"]*')
		printf "${IJO}FOUND => ${KUNING}$encrypt ${NC}[ ${CYAN}$email${NC}|${CYAN}$getPass ${NC}]\n"
		echo "$email|$getPass" >> result.txt
	else
		printf "${MERAH}NOT FOUND => ${KUNING}$encrypt\n"
	fi

}


if [[ -z $1 ]]; then
	header
	printf "To Use $0 <list.txt> \n"
	exit 1
fi

printf "START ...\n\n"

IFS=$'\r\n' GLOBIGNORE='*' command eval 'list=($(cat $1))'
for (( i = 0; i < "${#list[@]}"; i++ )); do
	passlist="${list[$i]}"
	hash $passlist
done
wait
