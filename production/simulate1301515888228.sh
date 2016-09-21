nohup hadoop jar /opt/hadoop/hadoop-0.20.2-test.jar loadgen -m 2 -keepmap 100 -keepred 200 -indir 	/user/generator/file2/file2 	/user/generator/file7/file7 -outdir /user/generator/out1301515888228
 mv nohup.out results1301515888228
date +%s > finishTime_1301515888228.txt