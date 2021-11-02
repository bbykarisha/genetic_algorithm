#! /bin/bash
#python -c 'print("GCG"*40 + "gcua"*20 + "AG"*400 + 15*("AUG"*3 + "UUCA" * 7 + "UAA")+ "."
counter=1
for file in tests/*.txt 
do 
echo Тест № $counter
cat "${file}" | ./array_and_numbers > output_${counter}.txt
((counter++))
#printf '\n'
done