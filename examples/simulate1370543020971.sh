nohup time hadoop jar wordCount.jar wordCount -dl 200 -input 	/user/generator/file5/file5 	/user/generator/file23/file23 	/user/generator/file100/file100 	/user/generator/file2/file2 	/user/generator/file4/file4 	/user/generator/file5/file5 	/user/generator/file10/file10 	/user/generator/file35/file35 	/user/generator/file42/file42 	/user/generator/file18/file18 -output /user/generator/out1370543020971
 mv nohup.out results1370543020971
hadoop fs -rmr /user/generator/out1370543020971 
date +%s > finishTime_1370543020971.txt