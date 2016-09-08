nohup time hadoop jar wordCount.jar wordCount -dl 200 -input 	/user/generator/file4/file4 	/user/generator/file41/file41 -output /user/generator/out1370553780090
 mv nohup.out results1370553780090
hadoop fs -rmr /user/generator/out1370553780090 
date +%s > finishTime_1370553780090.txt