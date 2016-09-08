#!/bin/bash

for A in {1..9} 
do
    hadoop fs -mkdir /user/generator/file$A/
    hadoop fs -D dfs.blocksize=134217728 -put  128file /user/generator/file$A/file$A

done
#for A in {1..101}
#do
#    echo "$A   /user/generator/file$A/file$A" >> request2Block.txt
#done
