nohup hadoop jar /opt/hadoop/hadoop-0.20.2-test.jar loadgen -m 1 -keepmap 100 -keepred 200 -indir 	/user/generator/file7/file7 -outdir /user/generator/out1301515877326
 mv nohup.out results1301515877326
date +%s > finishTime_1301515877326.txt