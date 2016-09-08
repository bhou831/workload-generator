nohup time hadoop jar wordCount.jar wordCount -dl 200 -input 	/user/generator/file27/file27 -output /user/generator/out1370543116946
 mv nohup.out results1370543116946
hadoop fs -rmr /user/generator/out1370543116946 
date +%s > finishTime_1370543116946.txt