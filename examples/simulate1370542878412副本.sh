nohup time hadoop jar wordCount.jar wordCount -dl 200 -input 	/user/generator/file88/file88 	/user/generator/file2/file2 	/user/generator/file37/file37 	/user/generator/file4/file4 	/user/generator/file4/file4 	/user/generator/file59/file59 	/user/generator/file56/file56 	/user/generator/file1/file1 	/user/generator/file87/file87 	/user/generator/file16/file16 -output /user/generator/out1370542878412
 mv nohup.out results1370542878412
hadoop fs -rmr /user/generator/out1370542878412 
date +%s > finishTime_1370542878412.txt