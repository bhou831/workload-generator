nohup time hadoop jar wordCount.jar wordCount -dl 200 -input 	/user/generator/file21/file21 	/user/generator/file1/file1 	/user/generator/file55/file55 	/user/generator/file11/file11 	/user/generator/file11/file11 	/user/generator/file42/file42 	/user/generator/file6/file6 	/user/generator/file1/file1 	/user/generator/file1/file1 	/user/generator/file11/file11 -output /user/generator/out1370553092760
 mv nohup.out results1370553092760
hadoop fs -rmr /user/generator/out1370553092760 
date +%s > finishTime_1370553092760.txt