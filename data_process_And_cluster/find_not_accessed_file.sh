#!/bin/bash
#There are total _c_m__a,(_cm__a,cm__a),( _cma,cma),c,m
#I will not consider _c_m__a because it is not creating, modifying and accessing any file (src/test..) at the build time
#So, I considered 1st group(_cm__a,cm__a) and then 2nd group(__cma,cma) in the following code. It is noteworthy that all files in c and m are generated in target/
#$1

if [[ $1 == ""  || $2 == ""  ]]; then
	echo "plz give argument link (uses26)"
fi

uses_name=$(echo $1 | rev | cut -d'/' -f2 | rev)
#echo ${uses_name}
#rm "${uses_name}_cm_a_sort_Prefix_remove.csv"
#rm "${uses_name}_cm_a_Clustering.csv"
#rm  "contents_of_all_files_which_are_accessed.csv"
#rm "contents_of_all_files_which_are_never_ever_accessed.csv"

cm__a="$1cm__a.csv"
not_cm__a="$1cm__a.csv"
not_c_m__a="$1_c_m__a.csv" # It will be some sort of unnecessary files
#echo ${not_cm__a}
cat ${cm__a} >> "contents_of_all_files_which_are_never_ever_accessed.csv"
cat ${not_cm__a} >> "contents_of_all_files_which_are_never_ever_accessed.csv"


#===========Which are never ever accessed=========

while read line 
do
	file_name=$(echo $line | cut -d',' -f2) 	
	prefix_remove=$(sed 's;^.*target/;;g' <<< ${file_name})
	echo ${prefix_remove} >> "cm_unsort_Prefix_remove.csv"
done <  "contents_of_all_files_which_are_never_ever_accessed.csv"   

sort "cm_unsort_Prefix_remove.csv" > "${uses_name}_cm_a_sort_Prefix_remove.csv"
rm  "cm_unsort_Prefix_remove.csv"

#==========For Making Cluster============
group_arr=$(cut -f1 -d'/' "${uses_name}_cm_a_sort_Prefix_remove.csv"  | sort | uniq)
echo "group,count" > "${uses_name}_cm_a_Clustering.csv"
for group in ${group_arr[@]}; do
    count=$(grep -r "$group" "${uses_name}_cm_a_sort_Prefix_remove.csv" | wc -l)
    echo "$group,$count" >> "${uses_name}_cm_a_Clustering.csv"
    if [[ $group == "site" ]]; then
        grep -r "site" "${uses_name}_cm_a_sort_Prefix_remove.csv"  > "tmp_site.csv"
         group_site_arr=$(cut -f2 -d'/' "tmp_site.csv"  | sort | uniq)
         for group_site in ${group_site_arr[@]}; do
            count_site=$(grep -r "${group_site}" "tmp_site.csv" | wc -l)
            #echo ${group_site},${count_site}
            echo "site/${group_site},${count_site}" >> "${uses_name}_cm_a_Clustering.csv"
         done
    fi

done
#============ WHICH are Aceesessed =================

not_cma="$1_cma.csv"
cma="${1}cma.csv"

cat ${cma} >> "contents_of_all_files_which_are_accessed.csv"
cat ${not_cma} >> "contents_of_all_files_which_are_accessed.csv"


#comm -13 <(sort -u   "contents_of_all_files_which_are_accessed.csv") <(sort -u   "contents_of_all_files_which_are_never_ever_accessed.csv") > "common.csv"
sort "contents_of_all_files_which_are_accessed.csv" "contents_of_all_files_which_are_never_ever_accessed.csv" |uniq -d >   "uncommon_in_never_ever_accessed.csv"
comm -12 <(sort -u   "contents_of_all_files_which_are_accessed.csv") <(sort -u   "contents_of_all_files_which_are_never_ever_accessed.csv") > "common.csv"

#---------Extract file names which have target directory ------------
while read line 
do
	file_name=$(echo $line | cut -d',' -f2)	
	prefix_remove=$(sed 's;^.*target/;;g' <<< ${file_name})
	echo ${prefix_remove} >> "cma_unsort_Prefix_remove.csv"
done <  "contents_of_all_files_which_are_accessed.csv"   

sort "cma_unsort_Prefix_remove.csv" > "${uses_name}_cma_sort_Prefix_remove.csv"
rm  "cma_unsort_Prefix_remove.csv"

#==========For Making Cluster============

group_arr=$(cut -f1 -d'/' "${uses_name}_cma_sort_Prefix_remove.csv"  | sort | uniq)
echo "group,count" > "${uses_name}_cma_Clustering.csv"
for group in ${group_arr[@]}; do
    count=$(grep -r "$group" "${uses_name}_cma_sort_Prefix_remove.csv" | wc -l)
    echo "$group,$count" >> "${uses_name}_cma_Clustering.csv"
    if [[ $group == "site" ]]; then
        grep -r "site" "${uses_name}_cma_sort_Prefix_remove.csv"  > "tmp_site.csv"
         group_site_arr=$(cut -f2 -d'/' "tmp_site.csv"  | sort | uniq)
         for group_site in ${group_site_arr[@]}; do
            count_site=$(grep -r "${group_site}" "tmp_site.csv" | wc -l)
            #echo ${group_site},${count_site}
            echo "site/${group_site},${count_site}" >> "${uses_name}_cma_Clustering.csv"
         done
    fi
done

rm "tmp_site.csv"
if [[ ! -d $2 ]]; then
    mkdir $2
fi
mv *.csv  $2

#python3 pychart_generator.py "${uses_name}_cm_Clustering.csv"
