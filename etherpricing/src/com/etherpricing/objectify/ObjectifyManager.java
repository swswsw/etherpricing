package com.etherpricing.objectify;

import com.etherpricing.model.Minute;
import com.etherpricing.model.TenMinute;

import static com.googlecode.objectify.ObjectifyService.ofy;

public class ObjectifyManager {

	public static void save(Minute minute) {
		ofy().save().entity(minute).now();
	}
	
	public static void save(TenMinute value) {
		ofy().save().entity(value).now();
	}
}
