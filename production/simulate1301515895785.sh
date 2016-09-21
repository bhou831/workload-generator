nohup hadoop jar /opt/hadoop/hadoop-0.20.2-test.jar loadgen -m 2 -keepmap 100 -keepred 200 -indir 	/user/generator/file2/file2 	/user/generator/file1/file1 -outdir /user/generator/out1301515895785
 mv nohup.out results1301515895785
date +%s > finishTime_1301515895785.txt