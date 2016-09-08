nohup time hadoop jar wordCount.jar wordCount -dl 200 -input 	/user/generator/file24/file24 -output /user/generator/out1370542779194
 mv nohup.out results1370542779194
hadoop fs -rmr /user/generator/out1370542779194 
date +%s > finishTime_1370542779194.txt