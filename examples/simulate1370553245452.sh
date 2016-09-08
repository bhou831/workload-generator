nohup time hadoop jar wordCount.jar wordCount -dl 200 -input 	/user/generator/file5/file5 	/user/generator/file59/file59 -output /user/generator/out1370553245452
 mv nohup.out results1370553245452
hadoop fs -rmr /user/generator/out1370553245452 
date +%s > finishTime_1370553245452.txt