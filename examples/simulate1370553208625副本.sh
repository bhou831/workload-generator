nohup time hadoop jar wordCount.jar wordCount -dl 200 -input 	/user/generator/file38/file38 -output /user/generator/out1370553208625
 mv nohup.out results1370553208625
hadoop fs -rmr /user/generator/out1370553208625 
date +%s > finishTime_1370553208625.txt