nohup time hadoop jar wordCount.jar wordCount -dl 200 -input 	/user/generator/file25/file25 	/user/generator/file1/file1 	/user/generator/file5/file5 	/user/generator/file67/file67 	/user/generator/file2/file2 	/user/generator/file84/file84 	/user/generator/file12/file12 	/user/generator/file2/file2 	/user/generator/file37/file37 	/user/generator/file81/file81 -output /user/generator/out1370553112582
 mv nohup.out results1370553112582
hadoop fs -rmr /user/generator/out1370553112582 
date +%s > finishTime_1370553112582.txt