nohup time hadoop jar wordCount.jar wordCount -dl 200 -input 	/user/generator/file7/file7 	/user/generator/file78/file78 -output /user/generator/out1370553397258
 mv nohup.out results1370553397258
hadoop fs -rmr /user/generator/out1370553397258 
date +%s > finishTime_1370553397258.txt