nohup time hadoop jar wordCount.jar wordCount -dl 200 -input 	/user/generator/file1/file1 -output /user/generator/out1370553054403
 mv nohup.out results1370553054403
hadoop fs -rmr /user/generator/out1370553054403 
date +%s > finishTime_1370553054403.txt