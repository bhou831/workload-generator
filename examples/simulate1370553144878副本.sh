nohup time hadoop jar wordCount.jar wordCount -dl 200 -input 	/user/generator/file17/file17 	/user/generator/file11/file11 	/user/generator/file7/file7 	/user/generator/file4/file4 	/user/generator/file1/file1 	/user/generator/file2/file2 	/user/generator/file1/file1 	/user/generator/file4/file4 	/user/generator/file27/file27 	/user/generator/file15/file15 -output /user/generator/out1370553144878
 mv nohup.out results1370553144878
hadoop fs -rmr /user/generator/out1370553144878 
date +%s > finishTime_1370553144878.txt