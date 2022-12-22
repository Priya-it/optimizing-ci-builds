#!/bin/bash

if [[ $1 == "" || $2 == "" ]]; then
    echo "give $1 (directory name)"
    echo "give $2 (Project name)"
    exit
fi
currentDir=$(pwd)
if [ -f "$currentDir/Output/$2-never-accessed" ]; then
    rm "$currentDir/Output/$2-never-accessed"
fi

if [ -f "$currentDir/Output/$2-accessed" ]; then
    rm "$currentDir/Output/$2-accessed"
fi
dir_arr=($(cd $1 && printf -- '%s\n' */))
#$(find . -maxdepth 1 -type d -printf '%f\n')
cd $1
#echo "PWD= ${dir_arr}"
never_accessed_file_name_array=("cm_a.csv" "c_m_a.csv" "c_m__a.csv" "cm__a.csv"  "_cm_a.csv"  "_cm__a.csv.csv"  "_c_m_a.csv" "_c_m__a.csv" )
accessed_file_name_array=("cma.csv" "c_ma.csv" "_cma.csv"  "_c_ma.csv"  )

if [[ ! -d "$currentDir/Output" ]]; then
    mkdir "$currentDir/Output"
fi

for i in "${dir_arr[@]}"
do
        
    echo "==========$i ========== $(pwd)"
    #if [[ $i != "." ]]; then
    for j in "${never_accessed_file_name_array[@]}"
    do
        #echo $i$j
        if [ -f $i$j ]; then
            echo "Found $i$j"
            cat "$i$j" >> "$currentDir/Output/$2-never-accessed"
        else 
            echo "Not Found"
        fi
    done

    for k in "${accessed_file_name_array[@]}"
    do
        if [ -f $i$k ]; then
            echo "pwd =$(pwd)"
            echo $i$k
            cat "$i$k" >> "$currentDir/Output/$2-accessed"
        fi
    done
    #fi
done

#sort -k1 -n -t,  "$currentDir/Output/$2-never-accessed"
#sort -k1 -n -t,  "$currentDir/Output/$2-accessed"
#sort -u
#$(sort -u "$currentDir/Output/$2-never-accessed") > "$currentDir/tmp"
cat "$currentDir/Output/$2-never-accessed" | sort | uniq > "$currentDir/tmp"
cp "$currentDir/tmp" "$currentDir/Output/$2-never-accessed" 
rm "$currentDir/tmp"
