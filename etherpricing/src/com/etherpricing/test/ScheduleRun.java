package com.etherpricing.test;

import java.util.logging.Level;
import java.util.logging.Logger;

import org.json.JSONObject;

import com.etherpricing.net.RetrieveData;

/**
 * start a scheduled run for testing
 * @author sol wu
 *
 */
public class ScheduleRun {

	private static final Logger log = Logger.getLogger(ScheduleRun.class.getName());
	
	private static String host = "http://localhost:8888";
	
	public static void main(String[] args) throws Exception {
		final String poloniex = "/update/poloniex.jsp";
		final String gatecoin = "/update/gatecoin.jsp";
		final String kraken = "/update/kraken.jsp";
		final String bittrex = "/update/bittrex.jsp";
		final String bitcoinaverage = "/update/bitcoinaverage.jsp";
		final String average = "/update/average.jsp";
		
		retrieveData(host + poloniex);
		retrieveData(host + gatecoin);
		retrieveData(host + kraken);
		retrieveData(host + bittrex);
		retrieveData(host + bitcoinaverage);
		retrieveData(host + average);
	}
	
	private static JSONObject retrieveData(String url) {
		JSONObject json = null;
		try {
			json = RetrieveData.jsonData(url);
		} catch (Exception ex) {
			log.log(Level.WARNING, "unable to retrieve data from " + url, ex);
		}
		return json;
	}
}
