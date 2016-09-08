import java.util.*;
import java.lang.*;
import jas.random.*;

public class NormalDistribution {
	private RandomGenerator rg=new RandomGenerator();
	private long mean;
	private long sd;

	public NormalDistribution(long mean, long variance){
		this.mean=mean;
		this.sd=variance;
	}
	
	public double next(){
		double ranFileLen=rg.getNormal(mean, sd);
		return ranFileLen;
	}
}
