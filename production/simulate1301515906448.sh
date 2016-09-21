nohup hadoop jar /opt/hadoop/hadoop-0.20.2-test.jar loadgen -m 1 -keepmap 100 -keepred 200 -indir 	/user/generator/file77/file77 -outdir /user/generator/out1301515906448
 mv nohup.out results1301515906448
date +%s > finishTime_1301515906448.txt