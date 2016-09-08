nohup time hadoop jar wordCount.jar wordCount -dl 200 -input 	/user/generator/file26/file26 -output /user/generator/out1370552743426
 mv nohup.out results1370552743426
hadoop fs -rmr /user/generator/out1370552743426 
date +%s > finishTime_1370552743426.txt