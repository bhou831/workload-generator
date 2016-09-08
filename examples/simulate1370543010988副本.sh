nohup time hadoop jar wordCount.jar wordCount -dl 200 -input 	/user/generator/file2/file2 	/user/generator/file1/file1 	/user/generator/file26/file26 	/user/generator/file27/file27 	/user/generator/file82/file82 	/user/generator/file11/file11 	/user/generator/file57/file57 	/user/generator/file1/file1 	/user/generator/file16/file16 	/user/generator/file1/file1 -output /user/generator/out1370543010988
 mv nohup.out results1370543010988
hadoop fs -rmr /user/generator/out1370543010988 
date +%s > finishTime_1370543010988.txt