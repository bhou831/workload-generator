nohup hadoop jar /opt/hadoop/hadoop-0.20.2-test.jar loadgen -m 1 -keepmap 100 -keepred 200 -indir 	/user/generator/file70/file70 -outdir /user/generator/out1301515913099
 mv nohup.out results1301515913099
date +%s > finishTime_1301515913099.txt