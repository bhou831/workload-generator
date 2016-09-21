nohup hadoop jar /opt/hadoop/hadoop-0.20.2-test.jar loadgen -m 1 -keepmap 100 -keepred 200 -indir 	/user/generator/file11/file11 -outdir /user/generator/out1301515904758
 mv nohup.out results1301515904758
date +%s > finishTime_1301515904758.txt