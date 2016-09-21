nohup hadoop jar /opt/hadoop/hadoop-0.20.2-test.jar loadgen -m 1 -keepmap 100 -keepred 200 -indir 	/user/generator/file8/file8 -outdir /user/generator/out1301515902644
 mv nohup.out results1301515902644
date +%s > finishTime_1301515902644.txt