package com.etherpricing.model;

import java.util.Date;

import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;
import com.googlecode.objectify.annotation.Index;

@Entity
public class Minute {
	@Id public Long id;
    public double sum;
    public double volume;
    @Index public double average;
    @Index public Date timestamp;
}
