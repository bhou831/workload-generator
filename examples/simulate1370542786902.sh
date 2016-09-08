nohup time hadoop jar wordCount.jar wordCount -dl 200 -input 	/user/generator/file61/file61 	/user/generator/file11/file11 	/user/generator/file63/file63 	/user/generator/file58/file58 	/user/generator/file13/file13 	/user/generator/file82/file82 	/user/generator/file67/file67 	/user/generator/file99/file99 	/user/generator/file99/file99 	/user/generator/file16/file16 	/user/generator/file48/file48 	/user/generator/file81/file81 -output /user/generator/out1370542786902
 mv nohup.out results1370542786902
hadoop fs -rmr /user/generator/out1370542786902 
date +%s > finishTime_1370542786902.txt