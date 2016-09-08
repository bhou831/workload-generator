nohup time hadoop jar wordCount.jar wordCount -dl 200 -input 	/user/generator/file9/file9 	/user/generator/file57/file57 	/user/generator/file25/file25 	/user/generator/file38/file38 	/user/generator/file1/file1 	/user/generator/file13/file13 	/user/generator/file43/file43 	/user/generator/file46/file46 	/user/generator/file2/file2 	/user/generator/file3/file3 -output /user/generator/out1370553147148
 mv nohup.out results1370553147148
hadoop fs -rmr /user/generator/out1370553147148 
date +%s > finishTime_1370553147148.txt