nohup time hadoop jar wordCount.jar wordCount -dl 200 -input 	/user/generator/file96/file96 -output /user/generator/out1370552851259
 mv nohup.out results1370552851259
hadoop fs -rmr /user/generator/out1370552851259 
date +%s > finishTime_1370552851259.txt