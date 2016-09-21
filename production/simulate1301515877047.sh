nohup hadoop jar /opt/hadoop/hadoop-0.20.2-test.jar loadgen -m 2 -keepmap 100 -keepred 200 -indir 	/user/generator/file87/file87 	/user/generator/file77/file77 -outdir /user/generator/out1301515877047
 mv nohup.out results1301515877047
date +%s > finishTime_1301515877047.txt