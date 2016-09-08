nohup time hadoop jar wordCount.jar wordCount -dl 200 -input 	/user/generator/file2/file2 -output /user/generator/out1370553248685
 mv nohup.out results1370553248685
hadoop fs -rmr /user/generator/out1370553248685 
date +%s > finishTime_1370553248685.txt