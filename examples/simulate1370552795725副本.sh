nohup time hadoop jar wordCount.jar wordCount -dl 200 -input 	/user/generator/file13/file13 -output /user/generator/out1370552795725
 mv nohup.out results1370552795725
hadoop fs -rmr /user/generator/out1370552795725 
date +%s > finishTime_1370552795725.txt