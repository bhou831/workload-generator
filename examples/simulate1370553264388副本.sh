nohup time hadoop jar wordCount.jar wordCount -dl 200 -input 	/user/generator/file2/file2 -output /user/generator/out1370553264388
 mv nohup.out results1370553264388
hadoop fs -rmr /user/generator/out1370553264388 
date +%s > finishTime_1370553264388.txt