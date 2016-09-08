nohup time hadoop jar wordCount.jar wordCount -dl 200 -input 	/user/generator/file64/file64 -output /user/generator/out1370553644426
 mv nohup.out results1370553644426
hadoop fs -rmr /user/generator/out1370553644426 
date +%s > finishTime_1370553644426.txt