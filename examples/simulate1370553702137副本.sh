nohup time hadoop jar wordCount.jar wordCount -dl 200 -input 	/user/generator/file2/file2 -output /user/generator/out1370553702137
 mv nohup.out results1370553702137
hadoop fs -rmr /user/generator/out1370553702137 
date +%s > finishTime_1370553702137.txt