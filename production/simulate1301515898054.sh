nohup hadoop jar /opt/hadoop/hadoop-0.20.2-test.jar loadgen -m 2 -keepmap 100 -keepred 200 -indir 	/user/generator/file3/file3 	/user/generator/file10/file10 -outdir /user/generator/out1301515898054
 mv nohup.out results1301515898054
date +%s > finishTime_1301515898054.txt