nohup time hadoop jar wordCount.jar wordCount -dl 200 -input 	/user/generator/file93/file93 	/user/generator/file28/file28 	/user/generator/file1/file1 	/user/generator/file26/file26 	/user/generator/file1/file1 	/user/generator/file4/file4 	/user/generator/file17/file17 	/user/generator/file56/file56 	/user/generator/file1/file1 	/user/generator/file50/file50 -output /user/generator/out1370542989072
 mv nohup.out results1370542989072
hadoop fs -rmr /user/generator/out1370542989072 
date +%s > finishTime_1370542989072.txt