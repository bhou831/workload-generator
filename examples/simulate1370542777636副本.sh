nohup time hadoop jar wordCount.jar wordCount -dl 200 -input 	/user/generator/file34/file34 	/user/generator/file41/file41 	/user/generator/file77/file77 	/user/generator/file48/file48 	/user/generator/file65/file65 	/user/generator/file96/file96 	/user/generator/file39/file39 -output /user/generator/out1370542777636
 mv nohup.out results1370542777636
hadoop fs -rmr /user/generator/out1370542777636 
date +%s > finishTime_1370542777636.txt