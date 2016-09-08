#!/bin/bash

for A in {1..101}
do
    hadoop fs -mkdir /users/che/file$A/
    hadoop fs -put  file /users/che/file$A/file$A

done
#for A in {1..101}
#do
#    echo "$A   /user/generator/file$A/file$A" >> request2Block.txt
#done
