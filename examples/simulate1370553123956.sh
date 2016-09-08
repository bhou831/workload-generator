nohup time hadoop jar wordCount.jar wordCount -dl 200 -input 	/user/generator/file1/file1 -output /user/generator/out1370553123956
 mv nohup.out results1370553123956
hadoop fs -rmr /user/generator/out1370553123956 
date +%s > finishTime_1370553123956.txt