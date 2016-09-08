nohup time hadoop jar wordCount.jar wordCount -dl 200 -input 	/user/generator/file1/file1 	/user/generator/file7/file7 	/user/generator/file74/file74 	/user/generator/file1/file1 	/user/generator/file34/file34 	/user/generator/file6/file6 	/user/generator/file37/file37 	/user/generator/file6/file6 	/user/generator/file13/file13 	/user/generator/file59/file59 -output /user/generator/out1370542981080
 mv nohup.out results1370542981080
hadoop fs -rmr /user/generator/out1370542981080 
date +%s > finishTime_1370542981080.txt