nohup time hadoop jar wordCount.jar wordCount -dl 200 -input 	/user/generator/file9/file9 -output /user/generator/out1370552719741
 mv nohup.out results1370552719741
hadoop fs -rmr /user/generator/out1370552719741 
date +%s > finishTime_1370552719741.txt