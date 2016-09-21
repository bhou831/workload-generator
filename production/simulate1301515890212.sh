nohup hadoop jar /opt/hadoop/hadoop-0.20.2-test.jar loadgen -m 1 -keepmap 100 -keepred 200 -indir 	/user/generator/file1/file1 -outdir /user/generator/out1301515890212
 mv nohup.out results1301515890212
date +%s > finishTime_1301515890212.txt