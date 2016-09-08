nohup time hadoop jar wordCount.jar wordCount -dl 200 -input 	/user/generator/file87/file87 	/user/generator/file47/file47 -output /user/generator/out1370542784810
 mv nohup.out results1370542784810
hadoop fs -rmr /user/generator/out1370542784810 
date +%s > finishTime_1370542784810.txt