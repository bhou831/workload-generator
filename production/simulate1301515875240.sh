nohup hadoop jar /opt/hadoop/hadoop-0.20.2-test.jar loadgen -m 2 -keepmap 100 -keepred 200 -indir 	/user/generator/file81/file81 	/user/generator/file21/file21 -outdir /user/generator/out1301515875240
 mv nohup.out results1301515875240
date +%s > finishTime_1301515875240.txt