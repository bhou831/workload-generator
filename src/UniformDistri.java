import java.util.*;
import java.lang.*;
public class UniformDistri {
	private Random rnd = new Random(System.currentTimeMillis());
	private int rangeInt;
	private float rangeFloat;
	private int nextIntegerValue;
	private float nextFloatValue;
	
	public UniformDistri(){}
	public UniformDistri(long blockNumber){
		rangeInt=(int)blockNumber;
		
	}
	
	int nextInt(int celling){
		nextIntegerValue=this.rnd.nextInt(celling);
		return nextIntegerValue;
	}
	int nextInt(){
		nextIntegerValue=this.rnd.nextInt(10);
		return nextIntegerValue;
	}
}
