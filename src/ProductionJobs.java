import java.util.HashMap;
import java.util.Map;
import java.util.Random;


public class ProductionJobs {
	Map<Integer,Integer> productionJobs=new HashMap<Integer,Integer>();
	private Random rnd=new Random(System.currentTimeMillis());

	public ProductionJobs(){
		generateWork();
	}
	void generateWork(){
		productionJobs.put(1, 38);
		productionJobs.put(2, 16);
		productionJobs.put(10, 14);
		/*
		productionJobs.put(50, 8);
		productionJobs.put(100, 6);
		productionJobs.put(200, 6);
		//productionJobs.put(1, 38);

		 */
	}
	public int next(){
		int jobsize=0;
		int temp;
		int marker=0;
		//check wheather there is a job in the Map
		if(productionJobs.size()==0){
			//generateWork();
		}
		if(productionJobs.get(1)==0 && productionJobs.get(2)==0){
			if(productionJobs.get(10)==0 && productionJobs.get(50)==0){
				if(productionJobs.get(100)==0 && productionJobs.get(200)==0){
					System.err.println("Exusting job pool! Program will be terminated!");
					return -1;
				}
			}
		}

		while(marker==0){
			//jobsize=rnd.nextInt(300);
			jobsize=rnd.nextInt(150);
			//System.out.println("Obtain random number:"+jobsize);
			if(jobsize>=1&&jobsize<=50){
				temp=productionJobs.get(1);
				//System.out.println("get job size here!");
				if(temp!=0){
					productionJobs.put(1, (temp-1));
					marker=1;
				}
				jobsize=1;
			}
			else if(jobsize>50&&jobsize<=100){
				temp=productionJobs.get(2);
				if(temp!=0){
					productionJobs.put(2, (temp-1));
					marker=1;
				}
				jobsize=2;
			}
			else if(jobsize>100&&jobsize<=150){
				temp=productionJobs.get(10);
				if(temp!=0){
					productionJobs.put(10, (temp-1));
					marker=1;
				}
				jobsize=10;
		    }
			/*
			else if(jobsize<=200&&jobsize>150){
				temp=productionJobs.get(50);
				if(temp!=0){
					productionJobs.put(50, (temp-1));
					marker=1;
				}
				jobsize=50;
	    	}
			else if(jobsize<=250&&jobsize>=201){
				temp=productionJobs.get(100);
				if(temp!=0){
					productionJobs.put(100, (temp-1));
					marker=1;
				}
				jobsize=100;
	    	}
			else if(jobsize<=300&&jobsize>=251){
				temp=productionJobs.get(200);
				if(temp!=0){
					productionJobs.put(200, (temp-1));
					marker=1;
				}
				jobsize=200;
	     	}
	     	*/
		}
		return (jobsize-1);
	}
}
