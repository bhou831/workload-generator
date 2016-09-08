nohup time hadoop jar wordCount.jar wordCount -dl 200 -input 	/user/generator/file7/file7 	/user/generator/file8/file8 	/user/generator/file1/file1 	/user/generator/file29/file29 	/user/generator/file33/file33 	/user/generator/file10/file10 	/user/generator/file1/file1 	/user/generator/file30/file30 	/user/generator/file51/file51 	/user/generator/file3/file3 -output /user/generator/out1370543050444
 mv nohup.out results1370543050444
hadoop fs -rmr /user/generator/out1370543050444 
date +%s > finishTime_1370543050444.txt