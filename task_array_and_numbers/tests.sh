#! /bin/bash
counter=1
for file in tests/*.txt 
do 
echo Тест № $counter
cat "${file}" | ./array_and_numbers > output_${counter}.txt
((counter++))
done  
