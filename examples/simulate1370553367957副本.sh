nohup time hadoop jar wordCount.jar wordCount -dl 200 -input 	/user/generator/file77/file77 -output /user/generator/out1370553367957
 mv nohup.out results1370553367957
hadoop fs -rmr /user/generator/out1370553367957 
date +%s > finishTime_1370553367957.txt