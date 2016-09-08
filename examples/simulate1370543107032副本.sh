nohup time hadoop jar wordCount.jar wordCount -dl 200 -input 	/user/generator/file1/file1 -output /user/generator/out1370543107032
 mv nohup.out results1370543107032
hadoop fs -rmr /user/generator/out1370543107032 
date +%s > finishTime_1370543107032.txt