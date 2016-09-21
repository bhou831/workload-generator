nohup hadoop jar /opt/hadoop/hadoop-0.20.2-test.jar loadgen -m 2 -keepmap 100 -keepred 200 -indir 	/user/generator/file17/file17 	/user/generator/file66/file66 -outdir /user/generator/out1301515888308
 mv nohup.out results1301515888308
date +%s > finishTime_1301515888308.txt