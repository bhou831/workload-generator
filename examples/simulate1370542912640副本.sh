nohup time hadoop jar wordCount.jar wordCount -dl 200 -input 	/user/generator/file1/file1 	/user/generator/file19/file19 	/user/generator/file2/file2 	/user/generator/file9/file9 	/user/generator/file2/file2 	/user/generator/file22/file22 	/user/generator/file1/file1 	/user/generator/file6/file6 	/user/generator/file2/file2 	/user/generator/file10/file10 -output /user/generator/out1370542912640
 mv nohup.out results1370542912640
hadoop fs -rmr /user/generator/out1370542912640 
date +%s > finishTime_1370542912640.txt