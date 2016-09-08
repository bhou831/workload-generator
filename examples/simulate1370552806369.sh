nohup time hadoop jar wordCount.jar wordCount -dl 200 -input 	/user/generator/file6/file6 -output /user/generator/out1370552806369
 mv nohup.out results1370552806369
hadoop fs -rmr /user/generator/out1370552806369 
date +%s > finishTime_1370552806369.txt