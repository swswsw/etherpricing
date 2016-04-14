package com.etherpricing.util;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.TimeZone;

/**
 * date related utility
 * @author sol wu
 *
 */
public class DateUtil {

	/**
	 * to iso string
	 * @param date
	 * @return
	 */
	public static String toIso(Date date) {
		TimeZone tz = TimeZone.getTimeZone("UTC");
		DateFormat df = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
		df.setTimeZone(tz);
		String iso = df.format(date);
		return iso;
	}
	
}
