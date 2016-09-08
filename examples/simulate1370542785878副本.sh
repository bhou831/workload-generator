nohup time hadoop jar wordCount.jar wordCount -dl 200 -input 	/user/generator/file18/file18 	/user/generator/file64/file64 	/user/generator/file68/file68 	/user/generator/file19/file19 	/user/generator/file55/file55 -output /user/generator/out1370542785878
 mv nohup.out results1370542785878
hadoop fs -rmr /user/generator/out1370542785878 
date +%s > finishTime_1370542785878.txt