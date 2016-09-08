nohup time hadoop jar wordCount.jar wordCount -dl 200 -input 	/user/generator/file33/file33 	/user/generator/file16/file16 -output /user/generator/out1370553374745
 mv nohup.out results1370553374745
hadoop fs -rmr /user/generator/out1370553374745 
date +%s > finishTime_1370553374745.txt