nohup time hadoop jar wordCount.jar wordCount -dl 200 -input 	/user/generator/file14/file14 	/user/generator/file61/file61 	/user/generator/file2/file2 	/user/generator/file35/file35 	/user/generator/file5/file5 	/user/generator/file41/file41 	/user/generator/file8/file8 	/user/generator/file1/file1 	/user/generator/file1/file1 	/user/generator/file9/file9 -output /user/generator/out1370553681050
 mv nohup.out results1370553681050
hadoop fs -rmr /user/generator/out1370553681050 
date +%s > finishTime_1370553681050.txt