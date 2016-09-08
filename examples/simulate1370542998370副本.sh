nohup time hadoop jar wordCount.jar wordCount -dl 200 -input 	/user/generator/file2/file2 	/user/generator/file3/file3 	/user/generator/file7/file7 	/user/generator/file21/file21 	/user/generator/file16/file16 	/user/generator/file1/file1 	/user/generator/file1/file1 	/user/generator/file20/file20 	/user/generator/file4/file4 	/user/generator/file2/file2 -output /user/generator/out1370542998370
 mv nohup.out results1370542998370
hadoop fs -rmr /user/generator/out1370542998370 
date +%s > finishTime_1370542998370.txt