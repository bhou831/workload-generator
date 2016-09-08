nohup time hadoop jar wordCount.jar wordCount -dl 200 -input 	/user/generator/file27/file27 	/user/generator/file6/file6 	/user/generator/file86/file86 	/user/generator/file65/file65 	/user/generator/file7/file7 	/user/generator/file62/file62 	/user/generator/file1/file1 	/user/generator/file88/file88 	/user/generator/file8/file8 	/user/generator/file19/file19 -output /user/generator/out1370553162079
 mv nohup.out results1370553162079
hadoop fs -rmr /user/generator/out1370553162079 
date +%s > finishTime_1370553162079.txt