nohup hadoop jar /opt/hadoop/hadoop-0.20.2-test.jar loadgen -m 2 -keepmap 100 -keepred 200 -indir 	/user/generator/file2/file2 	/user/generator/file54/file54 -outdir /user/generator/out1301515879711
 mv nohup.out results1301515879711
date +%s > finishTime_1301515879711.txt