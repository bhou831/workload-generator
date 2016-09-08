nohup time hadoop jar wordCount.jar wordCount -dl 200 -input 	/user/generator/file21/file21 -output /user/generator/out1370553739988
 mv nohup.out results1370553739988
hadoop fs -rmr /user/generator/out1370553739988 
date +%s > finishTime_1370553739988.txt