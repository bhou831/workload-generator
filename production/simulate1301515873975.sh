nohup hadoop jar /opt/hadoop/hadoop-0.20.2-test.jar loadgen -m 1 -keepmap 100 -keepred 200 -indir 	/user/generator/file17/file17 -outdir /user/generator/out1301515873975
 mv nohup.out results1301515873975
date +%s > finishTime_1301515873975.txt