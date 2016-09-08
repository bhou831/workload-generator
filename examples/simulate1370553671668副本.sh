nohup time hadoop jar wordCount.jar wordCount -dl 200 -input 	/user/generator/file1/file1 	/user/generator/file1/file1 -output /user/generator/out1370553671668
 mv nohup.out results1370553671668
hadoop fs -rmr /user/generator/out1370553671668 
date +%s > finishTime_1370553671668.txt