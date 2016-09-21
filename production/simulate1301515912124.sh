nohup hadoop jar /opt/hadoop/hadoop-0.20.2-test.jar loadgen -m 1 -keepmap 100 -keepred 200 -indir 	/user/generator/file6/file6 -outdir /user/generator/out1301515912124
 mv nohup.out results1301515912124
date +%s > finishTime_1301515912124.txt