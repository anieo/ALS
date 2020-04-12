#!/bin/bash 

for i in `seq 12 17`;
do
	./6.$i-*
	read -p "Enter to confirm" -n 1 -r
done

