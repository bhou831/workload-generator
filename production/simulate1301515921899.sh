nohup hadoop jar /opt/hadoop/hadoop-0.20.2-test.jar loadgen -m 1 -keepmap 100 -keepred 200 -indir 	/user/generator/file28/file28 -outdir /user/generator/out1301515921899
 mv nohup.out results1301515921899
date +%s > finishTime_1301515921899.txt