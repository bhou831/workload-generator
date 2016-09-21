nohup hadoop jar /opt/hadoop/hadoop-0.20.2-test.jar loadgen -m 1 -keepmap 100 -keepred 200 -indir 	/user/generator/file5/file5 -outdir /user/generator/out1301515870606
 mv nohup.out results1301515870606
date +%s > finishTime_1301515870606.txt