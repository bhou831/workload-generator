nohup hadoop jar /opt/hadoop/hadoop-0.20.2-test.jar loadgen -m 1 -keepmap 100 -keepred 200 -indir 	/user/generator/file10/file10 -outdir /user/generator/out1301515883211
 mv nohup.out results1301515883211
date +%s > finishTime_1301515883211.txt