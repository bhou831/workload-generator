nohup time hadoop jar wordCount.jar wordCount -dl 200 -input 	/user/generator/file56/file56 -output /user/generator/out1370553023195
 mv nohup.out results1370553023195
hadoop fs -rmr /user/generator/out1370553023195 
date +%s > finishTime_1370553023195.txt