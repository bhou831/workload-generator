nohup hadoop jar /opt/hadoop/hadoop-0.20.2-test.jar loadgen -m 1 -keepmap 100 -keepred 200 -indir 	/user/generator/file33/file33 -outdir /user/generator/out1301515888550
 mv nohup.out results1301515888550
date +%s > finishTime_1301515888550.txt