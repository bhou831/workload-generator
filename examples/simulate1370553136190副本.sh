nohup time hadoop jar wordCount.jar wordCount -dl 200 -input 	/user/generator/file100/file100 	/user/generator/file37/file37 	/user/generator/file10/file10 	/user/generator/file1/file1 	/user/generator/file2/file2 	/user/generator/file9/file9 	/user/generator/file5/file5 	/user/generator/file8/file8 	/user/generator/file44/file44 	/user/generator/file12/file12 -output /user/generator/out1370553136190
 mv nohup.out results1370553136190
hadoop fs -rmr /user/generator/out1370553136190 
date +%s > finishTime_1370553136190.txt