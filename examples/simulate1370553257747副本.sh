nohup time hadoop jar wordCount.jar wordCount -dl 200 -input 	/user/generator/file1/file1 	/user/generator/file1/file1 	/user/generator/file40/file40 	/user/generator/file55/file55 	/user/generator/file5/file5 	/user/generator/file35/file35 	/user/generator/file8/file8 	/user/generator/file1/file1 	/user/generator/file33/file33 	/user/generator/file25/file25 -output /user/generator/out1370553257747
 mv nohup.out results1370553257747
hadoop fs -rmr /user/generator/out1370553257747 
date +%s > finishTime_1370553257747.txt