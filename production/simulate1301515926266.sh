nohup hadoop jar /opt/hadoop/hadoop-0.20.2-test.jar loadgen -m 1 -keepmap 100 -keepred 200 -indir 	/user/generator/file2/file2 -outdir /user/generator/out1301515926266
 mv nohup.out results1301515926266
date +%s > finishTime_1301515926266.txt