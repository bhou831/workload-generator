nohup time hadoop jar wordCount.jar wordCount -dl 200 -input 	/user/generator/file1/file1 -output /user/generator/out1370552776961
 mv nohup.out results1370552776961
hadoop fs -rmr /user/generator/out1370552776961 
date +%s > finishTime_1370552776961.txt