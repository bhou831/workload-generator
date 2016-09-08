nohup time hadoop jar wordCount.jar wordCount -dl 200 -input 	/user/generator/file43/file43 	/user/generator/file62/file62 	/user/generator/file1/file1 	/user/generator/file1/file1 	/user/generator/file1/file1 	/user/generator/file4/file4 	/user/generator/file18/file18 	/user/generator/file1/file1 	/user/generator/file75/file75 	/user/generator/file3/file3 -output /user/generator/out1370553264863
 mv nohup.out results1370553264863
hadoop fs -rmr /user/generator/out1370553264863 
date +%s > finishTime_1370553264863.txt