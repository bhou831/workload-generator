nohup time hadoop jar wordCount.jar wordCount -dl 200 -input 	/user/generator/file4/file4 	/user/generator/file2/file2 	/user/generator/file6/file6 	/user/generator/file2/file2 	/user/generator/file25/file25 	/user/generator/file7/file7 	/user/generator/file9/file9 	/user/generator/file36/file36 	/user/generator/file2/file2 	/user/generator/file4/file4 -output /user/generator/out1370553729182
 mv nohup.out results1370553729182
hadoop fs -rmr /user/generator/out1370553729182 
date +%s > finishTime_1370553729182.txt