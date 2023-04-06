#!/usr/bin/env bash

esc=""
boldon="${esc}[1m";
boldoff="${esc}[22m"
redf="${esc}[31m";
bluef="${esc}[34m";
reset="${esc}[0m"

i=0
while read line
do
  line=${line##*/}
  array[ $i ]=${line%.svg}
  (( i++ ))
done < <(ls svg/*.svg)

for i in ${array[@]};
do
  echo "${boldon}${redf}inkscape${boldoff} ${bluef}-z -e png20/$i.png -w 20 -h 20 svg/$i.svg${reset}"
  inkscape -z -e png20/$i.png -w 20 -h 20 svg/$i.svg
done
