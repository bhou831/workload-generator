nohup time hadoop jar wordCount.jar wordCount -dl 200 -input 	/user/generator/file82/file82 -output /user/generator/out1370542787936
 mv nohup.out results1370542787936
hadoop fs -rmr /user/generator/out1370542787936 
date +%s > finishTime_1370542787936.txt