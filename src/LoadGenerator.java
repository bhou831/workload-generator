

import org.jfree.data.xy.*;
import org.jfree.ui.RefineryUtilities;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.TreeMap;

public class LoadGenerator extends Thread{
	static long totalTime=0;
	static long averageTime=11 * 1000;
	static long averageSize=640;
	static long variance=1;
	static long HDFS_capacity=6400;
	static int parallelThreads=0;
	static long waitInterval=0;
	static double skew=10.5;
	static long fileMean=0;
	static long fileVariance=1;
	final long startTime=System.currentTimeMillis();
	static int seqNum=0;
	static int blockSize=64;
	String jobType="wordCount";
	static int fileNum=0;
	static int arrivalNum=0;
	static int blockNum=0;
	static int reducerNum=0;
	static int mapperNum=8;
	static int randomSize=-1;
	static int zipf=0;
	static int strictUD=0;
	static int normalUD=0;
	static int strictSize=2;
	static int production=0;
	static int mpercent=100;
	static int rpercent=200;
	 long deadline=0;
    TreeMap<Long, Integer> timeMap=new TreeMap<Long, Integer>();
    TreeMap<Long, Integer> fileMap=new TreeMap<Long, Integer>();
    TreeMap<Long, Integer> popMap=new TreeMap<Long, Integer>();
    ArrayList DetailedTime=new ArrayList();
    HashMap<Long,String> request2Block=new HashMap<Long, String>();
    String out="";
	/**
	 * @param args
	 */

	public void run() {
		long blockNumber=HDFS_capacity/64;
		double[] blocks=new double[(int) blockNumber];
		long sleepTime;
		long counter=0;
		long sleepInterval;
		long dataCollector=0;
		long collectTime=0;
		String selectedBlocks;
		ExponentialGenerator timer=new ExponentialGenerator(averageTime);
		//UniformDistri timer=new UniformDistri(totalTime);
		//System.out.println(averageTime);
		//System.out.println(averageSize+"\n");
		ExponentialGenerator fileSize=new ExponentialGenerator(averageSize/blockSize);
		ZipfGenerator zipf=new ZipfGenerator((int)blockNumber, this.skew);
		NormalDistribution nd=new NormalDistribution(averageSize/blockSize,variance/blockSize);
		UniformDistri ud=new UniformDistri(blockNumber);
		UniformDistri fileUD=new UniformDistri(100);
		UniformDistri intervalUD=new UniformDistri(10000);
		UniformDistri deadlineUD=new UniformDistri(200);
		File requestBlockMap=new File("./request2Block.txt");
		ProductionJobs pj=new ProductionJobs();

		//File currentDir=new File(".");
		//Read the requestBlockMap into memory
		try{
			FileWriter fws=new FileWriter(new File("startTime.txt"));
			BufferedWriter bws=new BufferedWriter(fws);
			String startTime= Long.toString(System.currentTimeMillis()/1000);
			//System.out.println(startTime);
			bws.write(startTime);
			bws.flush();
			bws.close();

			if(!requestBlockMap.exists()){
				System.out.println("Please make sure the Request2Block file is in the same Directory of the Java File!");
				System.exit(1);
			}
			else{
				FileReader fw=new FileReader(requestBlockMap);
				BufferedReader br=new BufferedReader(fw);
				String line;
				while((line=br.readLine())!=null){
					String[] array= line.split(" ");
					//System.out.println("The input Line from request2Block file is:"+array[0]+"\t"+array[1]);
					request2Block.put(Long.parseLong(array[0]), array[1]);
					//System.out.println(request2Block.size());
				}
				br.close();
				fw.close();
			}
		}catch (Exception e){
			System.out.println("Request2Block file Read Error"+e.toString());
		}
	/*	for(int i=0;i<blockNumber;i++){
	        blocks[i]=zipf.getProbability(i);
		}
    */
	    while(true){
	    	seqNum++;
	    	selectedBlocks="";
	    	//this.deadline=deadlineUD.nextInt();
	    	this.deadline=200;
	    	if(reducerNum!=0){
	    		if(jobType.equals("wordCount")){
	    			out="nohup time hadoop jar "+jobType+".jar "+jobType+"\t -rnum "+reducerNum+ " -dl "+this.deadline+" -input";
	    		}
	    		else if(jobType.contains("loadgen")){
	    			out="nohup hadoop jar /opt/hadoop/hadoop-0.20.2-test.jar loadgen ";
	    		}
	    		else if(jobType.contains("wc5min")){
	    			out="nohup hadoop jar "+jobType+".jar "+jobType+"\t -rnum "+reducerNum+" -input";
	    		}
	    	}
	    	else{
	    		if(jobType.equals("wordCount")){
	    			out="nohup time hadoop jar "+jobType+".jar "+jobType+ " -dl "+this.deadline+" -input";
	    		}
	    		else if(jobType.contains("loadgen")){
	    			out="nohup hadoop jar /opt/hadoop/hadoop-0.20.2-test.jar loadgen ";
	    		}
	    		else if(jobType.contains("wc5min")){
	    			out="nohup hadoop jar "+jobType+".jar "+jobType+"\t -rnum "+reducerNum+" -input";
	    		}
	    	}
	    	//System.out.println("Give value to out!"+out);
	    	try {
	    		long curTime=System.currentTimeMillis();
	    		String exeFileName="simulate"+curTime+".sh";
		    	File simulaterLog=new File(exeFileName);
		    	FileWriter fos=new FileWriter(simulaterLog);
		    	BufferedWriter bw=new BufferedWriter(fos);

		    	//Log writer
		    	File logFile=new File("log.txt");
				FileWriter fws2=new FileWriter(logFile,true);
				BufferedWriter bws2=new BufferedWriter(fws2);

	    	    if(totalTime==0 || counter>=totalTime){
	    	    	//plotInterArrival("InterarrivalTime",DetailedTime,arrivalNum, "JobID","InterArrivalTime(Second)");
	    	    	//plot("InterarrivalTime",timeMap,arrivalNum, "InterarrivalTime(Second)","Probability");
	    	    	//plot("File Size",fileMap, fileNum, "File Size(MB)","Probability");
	    	    	//plotZipf("Block Popularity",popMap,blockNum,"Rank","CDF");
	    	    	//plot("Block Popularity",popMap,blockNum,"Block ID","Probability");
	    	    	postProcess();
	    	    	bw.close();
	    	    	fos.close();
	    			bws2.close();
	    			fws2.close();
	    	    	break;
	    	    }
	    	    sleepInterval=1000;
	    	    if(this.zipf==1){
	    	    	DetailedTime.add(seqNum-1, sleepInterval);
	    	    }
	    	    else if(this.strictUD==1){
	    	        sleepInterval=10000;
	    	    }
	    	    sleepInterval=timer.next();
	    	    //sleepInterval=intervalUD.nextInt();
	    	    arrivalNum++;
	    	    //System.out.println("This is sleepTime:"+sleepInterval);
	    	    //out=sleepInterval+":";
	    	    if(timeMap.containsKey((Object) (sleepInterval/1000))){
	    	    	int values=Integer.parseInt(timeMap.get(sleepInterval/1000).toString());
	    	    	values+=1;
	    	    	timeMap.put(sleepInterval/1000,values);
	    	    }
	    	    else {
	    	    	timeMap.put(sleepInterval/1000, 1);
	    	    }
	    	    long tempFileSize;
	    	    //System.out.println("Got timeFileSize!");
	    	    if(this.strictUD==1){
	    	        counter+=10000;
	    	        tempFileSize=this.strictSize;
	    	    }
	    	    else if(this.normalUD==1){
	    	    	counter+=sleepInterval;
	    	    	tempFileSize=(long) fileUD.nextInt();
	    	    }
	    	    else if(this.production==1){
	    	    	//System.out.println("Job Size is:");
	    	    	counter+=sleepInterval;
	    	    	tempFileSize=(long) pj.next();
	    	    	if(tempFileSize==-1){
	    	    		counter=999999999;
	    	    		continue;
	    	    	}
	    	    	//System.out.println("Job Size is:"+tempFileSize);
	    	    }
	    	    else {
	    	    	counter+=sleepInterval;
	    	    	tempFileSize=fileSize.next();
	    	    	//long tempFileSize=nd.next();
	    	    }
	    	    //process out for loadgen job
	    	    if(jobType.contains("loadgen")){
	    	    	if(reducerNum!=0){
	    	    		out+="-m "+(tempFileSize+1)+" -r "+reducerNum+" -keepmap "+mpercent+" -keepred "+rpercent+" -dl "+this.deadline+" -indir";
	    	    	}
	    	    	else {
	    	    		out+="-m "+(tempFileSize+1)+" -keepmap "+mpercent+" -keepred "+rpercent+" -dl "+this.deadline+" -indir";
	    	    	}
	    	    }
	    	    fileNum++;
	    	    //System.out.println("This is FileSize:"+tempFileSize);
	    	    //out+=tempFileSize+":";
	    	    if(fileMap.containsKey(tempFileSize)){
	    	    	int fValue=Integer.parseInt(fileMap.get(tempFileSize).toString());
	    	    	fValue+=1;
	    	    	fileMap.put(tempFileSize, fValue);
	    	    }
	    	    else{
	    	    	fileMap.put(tempFileSize, 1);
	    	    }

	    	    //long fileBlockNum=(long) Math.ceil((double)(tempFileSize/64));
	    	    long fileBlockNum=(long) Math.ceil((double)(tempFileSize))+1;
	    	    if(randomSize>0){
	    	    	fileBlockNum=randomSize;
	    	    }
	    	    for(int i=0;i<fileBlockNum;i++){
	    	    	long randomRank=0;
	    	    	//Here I use randomRank to control the block in certain small interval to avoid unnecessary repeat.
	    	    	//for example, [1,10], [11,20],[21,30]...,[91-100]
	    	    	if(this.strictUD==1){
	    	    	    randomRank=(long)ud.nextInt()+((counter-10000)/10000)*10;
	    	    	    while(randomRank==0){
	    	    		    randomRank=(long)ud.nextInt()+((counter-10000)/10000)*10;
	    	    	    }
	    	    	}
	    	    	else if(this.normalUD==1){
	    	    		randomRank=ud.nextInt();
	    	    	}
	    	    	else {
	    	    		randomRank=zipf.next();
	    	    	}
	    	    	blockNum++;
		    	    //System.out.println("This is randomRank:"+randomRank);
	    	    	if(request2Block.containsKey(randomRank)){
	    	    		out+=" "+request2Block.get(randomRank);
	    	    		//System.out.println(out);
	    	    	}
	    	    	else {
	    	    		System.out.println(request2Block.get(randomRank));
	    	    		System.out.println("Block Generating Exception");
	    	    		System.exit(1);
	    	    	}
	    	    	if(popMap.containsKey(randomRank)){
	    	    		int pValue=popMap.get(randomRank);
	    	    		pValue+=1;
	    	    		popMap.put((long)randomRank, pValue);
	    	    	}
	    	    	else{
	    	    		popMap.put((long)randomRank, 1);
	    	    	}
	    	    	//blocks[randomRank]+=1;
	    	    	selectedBlocks+=randomRank+",";
	    	    }
	    	    //out+=selectedBlocks+"\n";
	    	    String logs=seqNum+":"+curTime+":"+fileBlockNum+":"+selectedBlocks+"\n";
	    	    //System.out.println(logs);
	    	    System.out.println("The ["+seqNum+"] st/nd/rd/th request arrived. "+"It requests ["+fileBlockNum+"] blocks");
	    	    System.out.println("The population of requested blocks are listed:"+selectedBlocks);
	    	    System.out.println("Simulater holds for ["+counter/1000+"] seconds");
	    	    if(jobType.contains("wordCount")){
	    	    	out+=" -output /user/generator/out"+curTime+"\n mv nohup.out "+"results"+curTime+"\n";
	    	    }
	    	    else if(jobType.contains("loadgen")){
	    	    	out+= " -outdir /user/generator/out"+curTime+"\n mv nohup.out "+"results"+curTime+"\n";
	    	    }
	    	    else if(jobType.contains("wc5min")){
	    	    	out+= " -outdir /user/generator/out"+curTime+"\n mv nohup.out "+"results"+curTime+"\n";
	    	    }
	    	    out+="hadoop fs -rmr /user/generator/out"+curTime+" \n";
	    	    out+="date +%s > finishTime_"+curTime+".txt";

				bw.write(out);
				bw.flush();
				bw.close();
				bws2.append(logs);
	    	    bws2.flush();
				bws2.close();

				//1) how to let one job run with many file input from diff directory? do that in MapReduce program
				//2) generate one job a series of jobs?  just one job which will visit all requested blocks
				//3) if a series of jobs, how can we generate the request at the same time? Not necessary
				if(collectTime==0){
					//collectTime=System.currentTimeMillis();
				}
				jobExecute(exeFileName);
				if(dataCollector==0){
					dataCollector=System.currentTimeMillis();
					//clusterStatus(dataCollector,"start");
				}
	    	    sleep(sleepInterval);
				//sleep(10000);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				System.out.println("Exception in generating requests"+e.toString()+e.getMessage());
			}
	    }
	}

	//public void clusterStatus(long sTime,String command){

	//};


	//To settle down some parameters and write the logs
	void postProcess(){

	}
	public void jobExecute(String shellFile2Exe) {
		try{
			//Process p = Runtime.getRuntime().exec(new String[]{"/bin/bash", "ls "+shellFile2Exe});

			//String str="sh ./"+shellFile2Exe;
			Process p=null;
			File shellFile=new File(".");
			if(shellFile.exists()){
				//System.out.println(shellFile2Exe);
				p= Runtime.getRuntime().exec("sh "+shellFile2Exe, null, shellFile);
			}
			else{ System.exit(1);}
			/*if(p.waitFor() == 0){
				BufferedReader br=new BufferedReader(new InputStreamReader(p.getInputStream()));
				PrintStream ps=new PrintStream(new FileOutputStream(shellFile2Exe+".out"));
				String inline;
				while(null!=(inline=br.readLine())){
					ps.println(inline);
				}
			}
			else{
				System.out.println("Shell does not work!!!");
			}
			*/
		} catch(Exception e){
			System.out.println("Exception in Executing the shell file"+e.toString());
		}
	}
	public void plotZipf(String title, TreeMap tm, int total,String x_aix, String y_aix) throws IOException{
		XYSeries xys=new XYSeries(title);
		double cdf=0.0;
		xys.add(0,0.0);
		for(Iterator it = tm.keySet().iterator(); it.hasNext();) {

			Object key = it.next();
		    Object value = tm.get(key);
		    double freq=Integer.parseInt(value.toString());
		    cdf+=freq/total;
		    //System.out.println("CDF"+cdf);
		    xys.add(Integer.parseInt(key.toString()),cdf);
		    //xys.add(java.lang.Math.log((double)Integer.parseInt(key.toString())),java.lang.Math.log((double)freq));
		}
	    PlotScatter demo = new PlotScatter(title, xys, x_aix, y_aix);
	    demo.pack();
	    RefineryUtilities.centerFrameOnScreen(demo);
	    demo.setVisible(true);
	}
	public void plot(String title, TreeMap tm, int total,String x_aix, String y_aix) throws IOException{
		XYSeries xys=new XYSeries(title);
		int expection=0;
		for(Iterator it = tm.keySet().iterator(); it.hasNext();) {
		    Object key = it.next();
		    Object value = tm.get(key);
		    double freq=Integer.parseInt(value.toString());
		    //xys.add(Integer.parseInt(key.toString()),freq/total);
		    xys.add(Integer.parseInt(key.toString()),freq/total);
		    expection+=(freq/total)*Integer.parseInt(key.toString());
		    System.out.println("Expection is: "+expection);
		}
		System.out.println("Final Expection is: "+expection);
	    PlotScatter demo = new PlotScatter(title, xys, x_aix, y_aix);
	    demo.pack();
	    RefineryUtilities.centerFrameOnScreen(demo);
	    demo.setVisible(true);
	}
	public void plotInterArrival(String title, ArrayList detailedTime, int total,String x_aix, String y_aix) throws IOException{
		XYSeries xys=new XYSeries(title);
		for(int i=0;i<DetailedTime.size();i++) {
		    double timeofEachJob=Double.parseDouble(DetailedTime.get(i).toString());
		    //xys.add(Integer.parseInt(key.toString()),freq/total);
		    xys.add(i,timeofEachJob/1000);
		}
	    PlotScatter demo = new PlotScatter(title, xys, x_aix, y_aix);
	    demo.pack();
	    RefineryUtilities.centerFrameOnScreen(demo);
	    demo.setVisible(true);
	}
/*	public TreeMap logTreeMap(TreeMap tm){
		for()
		Map results=new TreeMap();
		return (TreeMap) results;
	}
	*/
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		LoadGenerator ld=new LoadGenerator();
		System.out.println("**********************************************************************************");
		System.out.println("WorkLoadGenerator parameter:");
		System.out.println("-T\tTotal running time for this load generator in HH:MM:SS");
		System.out.println("-t\tThe average time for the interarrival time");
		System.out.println("-S\tTotal HDFS storage capacity in MB");
		System.out.println("-s\tZipf distribution's skew parameter");
		System.out.println("-N\tMaximum number of parallel requests");
		System.out.println("-fm\tAverage File size");
		System.out.println("-fv\tVariance of file size");
		System.out.println("-B\tBlock Size on HDFS");
		System.out.println("-JOB\tJob classname you want to execute");
		System.out.println("-mnum\tSpecify your mapper number");
		System.out.println("-rnum\tSpecify your reducer number");
		System.out.println("-randomSize \t Specify wheather your file size is random or the fixed file size in block,-1 is random");
		System.out.println("-zipf \t Specify wheather you use zipf distribution for population or not. 1 is true");
		System.out.println("-strictUD\tUse fixed number of interarrival time and block number requested by each job");
		System.out.println("-strictSize\tFixed block number for each job");
		System.out.println("-normalUD\tUse relaxed uniform distribution so that the interarrival time is expontential");
		System.out.println("-skew\tZipf distribution skew");
		System.out.println("-production\tProduction file size used");
		System.out.println("-dl\t Job Deadline");

		System.out.println("**********************************************************************************");
		for(int i=0; i < args.length; ++i) {
		      try {
		        if ("-T".equals(args[i])) {
		        	String[] totalTimeInString=args[++i].split(":");
		            ld.totalTime=Integer.parseInt(totalTimeInString[0])*3600+Integer.parseInt(totalTimeInString[1])*60+Integer.parseInt(totalTimeInString[2]);
		            ld.totalTime*=1000;
		        } else if ("-t".equals(args[i])) {
		            ld.averageTime = Long.parseLong(args[++i]);
		        } else if ("-S".equals(args[i])) {
		            ld.HDFS_capacity = Long.parseLong(args[++i]);
		        } else if ("-N".equals(args[i])){
		        	ld.parallelThreads=Integer.parseInt(args[++i]);
		        } else if("-skew".equals(args[i])){
		        	ld.skew=Double.parseDouble(args[++i]);
		        } else if("-fm".equals(args[i])){
		        	ld.averageSize=Long.parseLong(args[++i]);
		        } else if("-fv".equals(args[i])){
		        	ld.variance=Long.parseLong(args[++i]);
		        } else if("-B".equals(args[i])){
		        	ld.blockSize=Integer.parseInt(args[++i]);
		        } else if("-JOB".equals(args[i])){
		        	ld.jobType=args[++i];
		        } else if("-mnum".equals(args[i])){
		        	ld.mapperNum=Integer.parseInt(args[++i]);
        		} else if("-rnum".equals(args[i])){
        			ld.reducerNum=Integer.parseInt(args[++i]);
        		}else if("-randomSize".equals(args[i])){
        			ld.randomSize=Integer.parseInt(args[++i]);
        		}else if("-zipf".equals(args[i])){
        			ld.zipf=Integer.parseInt(args[++i]);
        		}else if("-strictUD".equals(args[i])){
        			ld.strictUD=Integer.parseInt(args[++i]);
        		}else if("-strictSize".equals(args[i])){
        			ld.strictSize=Integer.parseInt(args[++i]);
        		}else if("-normalUD".equals(args[i])){
        			ld.normalUD=Integer.parseInt(args[++i]);
        		}
        		else if("-production".equals(args[i])){
        			ld.production=Integer.parseInt(args[++i]);
        		}
        		else if("-mpercent".equals(args[i])){
        			ld.mpercent=Integer.parseInt(args[++i]);
        		}
        		else if("-rpercent".equals(args[i])){
        			ld.rpercent=Integer.parseInt(args[++i]);
        		}
        		else if("-dl".equals(args[i])){
        			ld.deadline=Long.parseLong(args[++i]);
        		}

		      }catch(Exception e) {System.out.println("Input parameter parsing error:"+e.toString());}
		}
		String parameterFile="parameterFile.txt";
		try{
			String pstr="-T "+ ld.totalTime + " -t " + ld.averageTime +" -S " + ld.HDFS_capacity+" -skew "+ ld.skew+" -fm "
			            +ld.averageSize+" -fv "+ld.variance+" -B "+ld.blockSize+" -JOB "+ld.jobType+" -mnum " + ld.mapperNum+" -rnum "+ ld.reducerNum
			            +" -randomSize "+ld.randomSize+" -zipf "+ld.zipf+" -strctUD "+ld.strictUD+" -strictSize "+ld.strictSize
			            + " -nromalUD "+ld.normalUD+"\n";
            FileWriter writer = new FileWriter(parameterFile, true);
            writer.write(pstr);
            writer.close();
		} catch(Exception e){
			System.out.println("Exception in updating parameterFile"+e.toString());
		}

		//control the number of thread generated by the workload generator
		ld.run();
	}
}