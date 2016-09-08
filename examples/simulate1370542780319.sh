nohup time hadoop jar wordCount.jar wordCount -dl 200 -input 	/user/generator/file6/file6 	/user/generator/file41/file41 	/user/generator/file33/file33 	/user/generator/file90/file90 	/user/generator/file1/file1 	/user/generator/file47/file47 	/user/generator/file95/file95 	/user/generator/file48/file48 	/user/generator/file42/file42 -output /user/generator/out1370542780319
 mv nohup.out results1370542780319
hadoop fs -rmr /user/generator/out1370542780319 
date +%s > finishTime_1370542780319.txt