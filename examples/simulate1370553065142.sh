nohup time hadoop jar wordCount.jar wordCount -dl 200 -input 	/user/generator/file11/file11 	/user/generator/file50/file50 	/user/generator/file53/file53 	/user/generator/file17/file17 	/user/generator/file51/file51 	/user/generator/file17/file17 	/user/generator/file67/file67 	/user/generator/file25/file25 	/user/generator/file10/file10 	/user/generator/file1/file1 -output /user/generator/out1370553065142
 mv nohup.out results1370553065142
hadoop fs -rmr /user/generator/out1370553065142 
date +%s > finishTime_1370553065142.txt