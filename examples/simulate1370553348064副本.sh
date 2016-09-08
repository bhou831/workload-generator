nohup time hadoop jar wordCount.jar wordCount -dl 200 -input 	/user/generator/file3/file3 	/user/generator/file1/file1 -output /user/generator/out1370553348064
 mv nohup.out results1370553348064
hadoop fs -rmr /user/generator/out1370553348064 
date +%s > finishTime_1370553348064.txt