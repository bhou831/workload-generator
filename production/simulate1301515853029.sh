nohup hadoop jar /opt/hadoop/hadoop-0.20.2-test.jar loadgen -m 2 -keepmap 100 -keepred 200 -indir 	/user/generator/file29/file29 	/user/generator/file48/file48 -outdir /user/generator/out1301515853029
 mv nohup.out results1301515853029
date +%s > finishTime_1301515853029.txt