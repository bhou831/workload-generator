nohup time hadoop jar wordCount.jar wordCount -dl 200 -input 	/user/generator/file3/file3 -output /user/generator/out1370552910883
 mv nohup.out results1370552910883
hadoop fs -rmr /user/generator/out1370552910883 
date +%s > finishTime_1370552910883.txt