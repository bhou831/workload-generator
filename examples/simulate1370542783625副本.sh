nohup time hadoop jar wordCount.jar wordCount -dl 200 -input 	/user/generator/file31/file31 	/user/generator/file8/file8 	/user/generator/file25/file25 	/user/generator/file11/file11 	/user/generator/file42/file42 	/user/generator/file20/file20 	/user/generator/file70/file70 -output /user/generator/out1370542783625
 mv nohup.out results1370542783625
hadoop fs -rmr /user/generator/out1370542783625 
date +%s > finishTime_1370542783625.txt