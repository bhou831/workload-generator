nohup time hadoop jar wordCount.jar wordCount -dl 200 -input 	/user/generator/file16/file16 -output /user/generator/out1370553337414
 mv nohup.out results1370553337414
hadoop fs -rmr /user/generator/out1370553337414 
date +%s > finishTime_1370553337414.txt