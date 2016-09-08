nohup time hadoop jar wordCount.jar wordCount -dl 200 -input 	/user/generator/file25/file25 -output /user/generator/out1370552891508
 mv nohup.out results1370552891508
hadoop fs -rmr /user/generator/out1370552891508 
date +%s > finishTime_1370552891508.txt