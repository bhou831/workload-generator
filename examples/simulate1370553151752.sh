nohup time hadoop jar wordCount.jar wordCount -dl 200 -input 	/user/generator/file90/file90 	/user/generator/file1/file1 	/user/generator/file2/file2 	/user/generator/file20/file20 	/user/generator/file4/file4 	/user/generator/file1/file1 	/user/generator/file37/file37 	/user/generator/file1/file1 	/user/generator/file19/file19 	/user/generator/file90/file90 -output /user/generator/out1370553151752
 mv nohup.out results1370553151752
hadoop fs -rmr /user/generator/out1370553151752 
date +%s > finishTime_1370553151752.txt