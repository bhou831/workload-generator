nohup time hadoop jar wordCount.jar wordCount -dl 200 -input 	/user/generator/file3/file3 	/user/generator/file27/file27 	/user/generator/file23/file23 	/user/generator/file2/file2 	/user/generator/file34/file34 	/user/generator/file17/file17 	/user/generator/file8/file8 	/user/generator/file2/file2 	/user/generator/file1/file1 	/user/generator/file28/file28 -output /user/generator/out1370542877173
 mv nohup.out results1370542877173
hadoop fs -rmr /user/generator/out1370542877173 
date +%s > finishTime_1370542877173.txt