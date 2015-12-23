package com.etherpricing.objectify;

import com.etherpricing.model.Day;
import com.etherpricing.model.Hour;
import com.etherpricing.model.Minute;
import com.etherpricing.model.TenMinute;

import static com.googlecode.objectify.ObjectifyService.ofy;

public class ObjectifyManager {

	// remember to add to ofyhelper
	
	public static void save(Minute minute) {
		ofy().save().entity(minute).now();
	}
	
	public static void save(TenMinute value) {
		ofy().save().entity(value).now();
	}
	
	public static void save(Hour value) {
		ofy().save().entity(value).now();
	}
	
	public static void save(Day value) {
		ofy().save().entity(value).now();
	}
}
