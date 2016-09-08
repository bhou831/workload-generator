nohup time hadoop jar wordCount.jar wordCount -dl 200 -input 	/user/generator/file91/file91 	/user/generator/file2/file2 -output /user/generator/out1370553699400
 mv nohup.out results1370553699400
hadoop fs -rmr /user/generator/out1370553699400 
date +%s > finishTime_1370553699400.txt