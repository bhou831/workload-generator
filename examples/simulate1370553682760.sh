nohup time hadoop jar wordCount.jar wordCount -dl 200 -input 	/user/generator/file5/file5 	/user/generator/file33/file33 -output /user/generator/out1370553682760
 mv nohup.out results1370553682760
hadoop fs -rmr /user/generator/out1370553682760 
date +%s > finishTime_1370553682760.txt