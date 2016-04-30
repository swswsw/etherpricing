package com.etherpricing.model;

import java.util.Date;

import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;
import com.googlecode.objectify.annotation.Index;

import flexjson.JSONSerializer;

/**
 * saving this summary rollup every hour.
 * @author sol wu
 *
 */
@Entity
public class Hour {
	@Id public Long id;
    public double sum; // should i call this "last"?
    public double volume;
    @Index public double average;
    @Index public Date timeslot;
    public long timestamp;
    @Index public double avgUsd;
    public double sumUsd;
    
    
    public String toString() {
    	return new JSONSerializer().exclude("*.class").serialize(this);
    }
    
    /**
     * calculate the exact hour.  eg. 12:00, 01:00 
     * always get the lower bound.  the time that is already past.
     * @param timeMillis - java epoch time in milliseconds
     */
    public static Long calcWholeTime(long timeMillis) {
    	// divide by the number of milliseconds in 1 minute.  remove reminder.
    	final long MILLIS_IN_MINUTE = 1000 * 60 * 60; 
    	return timeMillis - (timeMillis % MILLIS_IN_MINUTE);
    }
}