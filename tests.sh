#! /bin/bash
counter=1
for file in tests/*.txt 
do 
echo Тест № $counter
((counter++))
cat "${file}" | ./array_and_numbers
printf '\n'
done > output.txt 
#python -c 'print("GCG"*40 + "gcua"*20 + "AG"*400 + 15*("AUG"*3 + "UUCA" * 7 + "UAA")+ "."
