nohup hadoop jar /opt/hadoop/hadoop-0.20.2-test.jar loadgen -m 2 -keepmap 100 -keepred 200 -indir 	/user/generator/file11/file11 	/user/generator/file88/file88 -outdir /user/generator/out1301515900095
 mv nohup.out results1301515900095
date +%s > finishTime_1301515900095.txt