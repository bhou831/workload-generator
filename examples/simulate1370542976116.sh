nohup time hadoop jar wordCount.jar wordCount -dl 200 -input 	/user/generator/file1/file1 	/user/generator/file1/file1 	/user/generator/file3/file3 	/user/generator/file40/file40 	/user/generator/file6/file6 	/user/generator/file51/file51 	/user/generator/file7/file7 	/user/generator/file6/file6 	/user/generator/file75/file75 	/user/generator/file3/file3 -output /user/generator/out1370542976116
 mv nohup.out results1370542976116
hadoop fs -rmr /user/generator/out1370542976116 
date +%s > finishTime_1370542976116.txt