nohup time hadoop jar wordCount.jar wordCount -dl 200 -input 	/user/generator/file29/file29 	/user/generator/file9/file9 -output /user/generator/out1370553157869
 mv nohup.out results1370553157869
hadoop fs -rmr /user/generator/out1370553157869 
date +%s > finishTime_1370553157869.txt