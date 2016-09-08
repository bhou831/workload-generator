nohup time hadoop jar wordCount.jar wordCount -dl 200 -input 	/user/generator/file34/file34 	/user/generator/file5/file5 	/user/generator/file4/file4 	/user/generator/file52/file52 	/user/generator/file4/file4 	/user/generator/file21/file21 	/user/generator/file7/file7 	/user/generator/file4/file4 	/user/generator/file31/file31 	/user/generator/file1/file1 -output /user/generator/out1370543061212
 mv nohup.out results1370543061212
hadoop fs -rmr /user/generator/out1370543061212 
date +%s > finishTime_1370543061212.txt