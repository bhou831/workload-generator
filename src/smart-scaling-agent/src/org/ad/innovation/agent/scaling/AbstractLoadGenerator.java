package org.ad.innovation.agent.scaling;

import org.ad.innovation.agent.ExponentialGenerator;
import org.ad.innovation.agent.NormalDistribution;
import org.ad.innovation.agent.UniformDistribution;
import org.ad.innovation.agent.ZipfGenerator;


public abstract class AbstractLoadGenerator {

    //static long averageTime=11 * 1000;
    static long averageSize=640;
    static long variance=1;
    static long waitInterval=0;
    static int randomSize=-1;
    static int zipf=0;
    static int strictUD=0;
    static int strictSize=10;
    static int normalUD=0;
    static double skew=10.5;
    static int deadline=0;

    ExponentialGenerator timer;
    ExponentialGenerator loadSize;
    ZipfGenerator zipfDistributor;
    NormalDistribution nd;
    UniformDistribution ud;
    UniformDistribution loadUD;
    UniformDistribution intervalUD;
    UniformDistribution deadlineUD;
}
