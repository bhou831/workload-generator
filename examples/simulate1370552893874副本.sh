nohup time hadoop jar wordCount.jar wordCount -dl 200 -input 	/user/generator/file5/file5 -output /user/generator/out1370552893874
 mv nohup.out results1370552893874
hadoop fs -rmr /user/generator/out1370552893874 
date +%s > finishTime_1370552893874.txt