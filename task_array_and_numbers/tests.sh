#! /bin/bash
counter=1
for file in tests/*.txt 
do 
echo Тест № $counter
((counter++))
cat "${file}" | ./array_and_numbers
printf '\n'
done > output.txt 

