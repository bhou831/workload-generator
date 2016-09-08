nohup time hadoop jar wordCount.jar wordCount -dl 200 -input 	/user/generator/file1/file1 	/user/generator/file6/file6 -output /user/generator/out1370553182115
 mv nohup.out results1370553182115
hadoop fs -rmr /user/generator/out1370553182115 
date +%s > finishTime_1370553182115.txt