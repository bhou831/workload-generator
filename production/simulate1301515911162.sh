nohup hadoop jar /opt/hadoop/hadoop-0.20.2-test.jar loadgen -m 1 -keepmap 100 -keepred 200 -indir 	/user/generator/file3/file3 -outdir /user/generator/out1301515911162
 mv nohup.out results1301515911162
date +%s > finishTime_1301515911162.txt