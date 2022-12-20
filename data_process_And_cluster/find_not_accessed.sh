#!/bin/bash
#$1
if [[ $1 == "" ]]; then
	echo "plz give argument link (uses26)"
fi

rm "cm_sort_Prefix_remove.csv"
#rm "unsort_Prefix_remove.csv"

cm__a="$1cm__a.csv"
_cm__a="_$1cm__a.csv"
_c_m__a="$1_c_m__a.csv" # It will be some sort of unnecessary files

while read line 
do
	file_name=$(echo $line | cut -d',' -f2) 	
	prefix_remove=$(sed 's;^.*target/;;g' <<< ${file_name})
	echo ${prefix_remove} >> "cm_unsort_Prefix_remove.csv"
done < ${cm__a}
sort "cm_unsort_Prefix_remove.csv" > "cm_sort_Prefix_remove.csv"
rm  "cm_unsort_Prefix_remove.csv"

group_arr=$(cut -f1 -d'/' "cm_sort_Prefix_remove.csv"  | sort | uniq)

echo "group,count" > "cm_Clustering.csv"
for group in ${group_arr[@]}; do
    count=$(grep -r "$group" "cm_sort_Prefix_remove.csv" | wc -l)
    echo "$group,$count" >> "cm_Clustering.csv"
done
