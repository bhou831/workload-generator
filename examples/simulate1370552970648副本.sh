nohup time hadoop jar wordCount.jar wordCount -dl 200 -input 	/user/generator/file1/file1 -output /user/generator/out1370552970648
 mv nohup.out results1370552970648
hadoop fs -rmr /user/generator/out1370552970648 
date +%s > finishTime_1370552970648.txt