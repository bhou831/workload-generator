nohup hadoop jar /opt/hadoop/hadoop-0.20.2-test.jar loadgen -m 2 -keepmap 100 -keepred 200 -indir 	/user/generator/file61/file61 	/user/generator/file24/file24 -outdir /user/generator/out1301515870770
 mv nohup.out results1301515870770
date +%s > finishTime_1301515870770.txt