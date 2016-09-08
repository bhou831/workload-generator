nohup time hadoop jar wordCount.jar wordCount -dl 200 -input 	/user/generator/file3/file3 -output /user/generator/out1370553623461
 mv nohup.out results1370553623461
hadoop fs -rmr /user/generator/out1370553623461 
date +%s > finishTime_1370553623461.txt