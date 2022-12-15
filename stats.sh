#!/bin/bash

count=11
printf "| Lines | Average | Program                              |\n"
printf "| ----: | ------: | :----------------------------------- |\n"
for file in 2022/*/*.ex; do
	input=$(dirname $file)/input
	total=0.00
	if [ -f $input ]; then
		lines=$(/bin/grep -vE '^(\s*)(--.*)?$' $file | /usr/bin/wc -l)
		for n in $(seq 1 $count); do
			elapsed=$(/usr/bin/time -f '%es' /bin/bash -c "eui $file < $input > /dev/null" 2>&1)
			total=$(/usr/bin/awk "BEGIN {print $total + $elapsed; exit}")
		done
		average=$(/usr/bin/awk "BEGIN {print $total / $count * 100; exit}")
		printf "| %5d |  %3.1fms | [%s](%s) |\n" $lines $average $file $file
	fi
done
