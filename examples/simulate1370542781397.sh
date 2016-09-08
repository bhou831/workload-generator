nohup time hadoop jar wordCount.jar wordCount -dl 200 -input 	/user/generator/file53/file53 	/user/generator/file64/file64 -output /user/generator/out1370542781397
 mv nohup.out results1370542781397
hadoop fs -rmr /user/generator/out1370542781397 
date +%s > finishTime_1370542781397.txt