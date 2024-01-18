package org.ad.innovation.agent.scaling;

public class ClusterLoadGenerator extends AbstractLoadGenerator {


    public static void main(String[] args) {
        ClusterLoadGenerator clg=new ClusterLoadGenerator();
        System.out.println("**********************************************************************************");
        System.out.println("ClusterLoadGenerator parameter:");
        System.out.println("-t\tThe average time for the inter-arrival time");
        System.out.println("-lm\tAverage Load size");
        System.out.println("-lv\tVariance of Load size");
        System.out.println("-randomSize \t Specify whether your load size is random or the fixed load size,-1 is random");
        System.out.println("-zipf \t Specify whether you use zipf distribution for population or not. 1 is true");
        System.out.println("-strictUD\tUse fixed number of inter-arrival time and block number requested by each job");
        System.out.println("-strictSize\tFixed load for each job");
        System.out.println("-normalUD\tUse relaxed uniform distribution so that the interarrival time is expontential");
        System.out.println("-skew\tZipf distribution skew");
        System.out.println("-dl\t Job Deadline");
        System.out.println("**********************************************************************************");
        for(int i=0; i < args.length; ++i) {
            try {
                if("-skew".equals(args[i])){
                    clg.skew=Double.parseDouble(args[++i]);
                } else if("-lm".equals(args[i])){
                    clg.averageSize=Long.parseLong(args[++i]);
                } else if("-lv".equals(args[i])){
                    clg.variance=Long.parseLong(args[++i]);
                } else if("-t".equals(args[i])){
                    clg.waitInterval=Integer.parseInt(args[++i]);
                } else if("-randomSize".equals(args[i])){
                    clg.randomSize=Integer.parseInt(args[++i]);
                }else if("-zipf".equals(args[i])){
                    clg.zipf=Integer.parseInt(args[++i]);
                }else if("-strictUD".equals(args[i])){
                    clg.strictUD=Integer.parseInt(args[++i]);
                }else if("-strictSize".equals(args[i])){
                    clg.strictSize=Integer.parseInt(args[++i]);
                }else if("-normalUD".equals(args[i])){
                    clg.normalUD=Integer.parseInt(args[++i]);
                }
                else if("-dl".equals(args[i])){
                    clg.deadline=Integer.parseInt(args[++i]);
                }
            }catch(Exception e) {System.out.println("Input parameter parsing error:"+e.toString());}
        }
    }
}
