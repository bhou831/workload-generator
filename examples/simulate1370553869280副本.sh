nohup time hadoop jar wordCount.jar wordCount -dl 200 -input 	/user/generator/file21/file21 	/user/generator/file3/file3 	/user/generator/file10/file10 	/user/generator/file6/file6 	/user/generator/file93/file93 	/user/generator/file90/file90 	/user/generator/file3/file3 	/user/generator/file23/file23 	/user/generator/file13/file13 	/user/generator/file1/file1 -output /user/generator/out1370553869280
 mv nohup.out results1370553869280
hadoop fs -rmr /user/generator/out1370553869280 
date +%s > finishTime_1370553869280.txt