nohup time hadoop jar wordCount.jar wordCount -dl 200 -input 	/user/generator/file1/file1 -output /user/generator/out1370553206147
 mv nohup.out results1370553206147
hadoop fs -rmr /user/generator/out1370553206147 
date +%s > finishTime_1370553206147.txt