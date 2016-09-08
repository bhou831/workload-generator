nohup time hadoop jar wordCount.jar wordCount -dl 200 -input 	/user/generator/file3/file3 -output /user/generator/out1370552798775
 mv nohup.out results1370552798775
hadoop fs -rmr /user/generator/out1370552798775 
date +%s > finishTime_1370552798775.txt