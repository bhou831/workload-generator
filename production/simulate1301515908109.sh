nohup hadoop jar /opt/hadoop/hadoop-0.20.2-test.jar loadgen -m 1 -keepmap 100 -keepred 200 -indir 	/user/generator/file20/file20 -outdir /user/generator/out1301515908109
 mv nohup.out results1301515908109
date +%s > finishTime_1301515908109.txt