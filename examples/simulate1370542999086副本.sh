nohup time hadoop jar wordCount.jar wordCount -dl 200 -input 	/user/generator/file4/file4 	/user/generator/file15/file15 	/user/generator/file28/file28 	/user/generator/file57/file57 	/user/generator/file2/file2 	/user/generator/file1/file1 	/user/generator/file3/file3 	/user/generator/file77/file77 	/user/generator/file38/file38 	/user/generator/file25/file25 -output /user/generator/out1370542999086
 mv nohup.out results1370542999086
hadoop fs -rmr /user/generator/out1370542999086 
date +%s > finishTime_1370542999086.txt