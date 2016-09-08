nohup time hadoop jar wordCount.jar wordCount -dl 200 -input 	/user/generator/file36/file36 	/user/generator/file1/file1 	/user/generator/file1/file1 	/user/generator/file1/file1 	/user/generator/file5/file5 	/user/generator/file2/file2 	/user/generator/file19/file19 	/user/generator/file68/file68 	/user/generator/file67/file67 	/user/generator/file2/file2 -output /user/generator/out1370542975378
 mv nohup.out results1370542975378
hadoop fs -rmr /user/generator/out1370542975378 
date +%s > finishTime_1370542975378.txt