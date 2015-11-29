package com.etherpricing.cache;

import java.io.Serializable;

/**
 * average result.  
 * 
 * @author sol wu
 *
 */
public class AverageCache implements Serializable {
	private static final long serialVersionUID = 1L;
	
	private double last = Double.NaN;
	private double volume = Double.NaN;
	
	public AverageCache(double last, double volume) {
		this.last = last;
		this.volume = volume;
	}
	
	public double getLast() {
		return last;
	}
	public void setLast(double last) {
		this.last = last;
	}
	public double getVolume() {
		return volume;
	}
	public void setVolume(double volume) {
		this.volume = volume;
	}
	
	
}
