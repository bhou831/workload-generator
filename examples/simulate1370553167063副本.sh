nohup time hadoop jar wordCount.jar wordCount -dl 200 -input 	/user/generator/file55/file55 	/user/generator/file2/file2 -output /user/generator/out1370553167063
 mv nohup.out results1370553167063
hadoop fs -rmr /user/generator/out1370553167063 
date +%s > finishTime_1370553167063.txt