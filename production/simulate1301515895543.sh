nohup hadoop jar /opt/hadoop/hadoop-0.20.2-test.jar loadgen -m 1 -keepmap 100 -keepred 200 -indir 	/user/generator/file98/file98 -outdir /user/generator/out1301515895543
 mv nohup.out results1301515895543
date +%s > finishTime_1301515895543.txt