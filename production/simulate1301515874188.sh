nohup hadoop jar /opt/hadoop/hadoop-0.20.2-test.jar loadgen -m 1 -keepmap 100 -keepred 200 -indir 	/user/generator/file3/file3 -outdir /user/generator/out1301515874188
 mv nohup.out results1301515874188
date +%s > finishTime_1301515874188.txt