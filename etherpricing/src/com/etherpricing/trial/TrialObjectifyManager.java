package com.etherpricing.trial;

public class TrialObjectifyManager {

	/**
	 * test only
	 */
	public static void trialSave() {
		final int RED = 5;
		Car porsche = new Car("2FAST", RED);
		com.googlecode.objectify.ObjectifyService.ofy().save().entity(porsche).now();    // async without the now()
	}
}
