nohup hadoop jar /opt/hadoop/hadoop-0.20.2-test.jar loadgen -m 1 -keepmap 100 -keepred 200 -indir 	/user/generator/file4/file4 -outdir /user/generator/out1301515910147
 mv nohup.out results1301515910147
date +%s > finishTime_1301515910147.txt