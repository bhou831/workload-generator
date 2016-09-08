nohup time hadoop jar wordCount.jar wordCount -dl 200 -input 	/user/generator/file2/file2 -output /user/generator/out1370552686448
 mv nohup.out results1370552686448
hadoop fs -rmr /user/generator/out1370552686448 
date +%s > finishTime_1370552686448.txt