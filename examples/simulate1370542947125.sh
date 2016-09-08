nohup time hadoop jar wordCount.jar wordCount -dl 200 -input 	/user/generator/file5/file5 	/user/generator/file57/file57 	/user/generator/file2/file2 	/user/generator/file6/file6 	/user/generator/file3/file3 	/user/generator/file1/file1 	/user/generator/file1/file1 	/user/generator/file2/file2 	/user/generator/file40/file40 	/user/generator/file27/file27 -output /user/generator/out1370542947125
 mv nohup.out results1370542947125
hadoop fs -rmr /user/generator/out1370542947125 
date +%s > finishTime_1370542947125.txt