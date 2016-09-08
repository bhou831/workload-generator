nohup time hadoop jar wordCount.jar wordCount -dl 200 -input 	/user/generator/file19/file19 -output /user/generator/out1370552730899
 mv nohup.out results1370552730899
hadoop fs -rmr /user/generator/out1370552730899 
date +%s > finishTime_1370552730899.txt