nohup time hadoop jar wordCount.jar wordCount -dl 200 -input 	/user/generator/file1/file1 	/user/generator/file2/file2 	/user/generator/file1/file1 	/user/generator/file9/file9 	/user/generator/file1/file1 	/user/generator/file24/file24 	/user/generator/file11/file11 	/user/generator/file70/file70 	/user/generator/file8/file8 	/user/generator/file22/file22 -output /user/generator/out1370553741428
 mv nohup.out results1370553741428
hadoop fs -rmr /user/generator/out1370553741428 
date +%s > finishTime_1370553741428.txt