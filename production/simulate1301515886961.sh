nohup hadoop jar /opt/hadoop/hadoop-0.20.2-test.jar loadgen -m 2 -keepmap 100 -keepred 200 -indir 	/user/generator/file65/file65 	/user/generator/file64/file64 -outdir /user/generator/out1301515886961
 mv nohup.out results1301515886961
date +%s > finishTime_1301515886961.txt