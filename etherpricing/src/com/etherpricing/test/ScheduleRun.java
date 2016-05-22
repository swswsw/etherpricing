package com.etherpricing.test;

import java.util.Date;
import java.util.Timer;
import java.util.TimerTask;
import java.util.logging.Level;
import java.util.logging.Logger;

import org.json.JSONArray;
import org.json.JSONObject;

import com.etherpricing.net.RetrieveData;

/**
 * helper script to 
 * start a scheduled run for testing
 * @author sol wu
 *
 */
public class ScheduleRun {

	private static final Logger log = Logger.getLogger(ScheduleRun.class.getName());
	
	private static String host = "http://localhost:8888";
	
	/** how many ms in one minute */
	private static final long PERIOD_MINUTE = 1000L * 60;
	/** how many ms in 10 mins */
	private static final long PERIOD_TENMIN = PERIOD_MINUTE * 10;
	/** how many ms in 1 hour */
	private static final long PERIOD_HOUR = PERIOD_MINUTE * 60;
	/** how many ms in 1 day */
	private static final long PERIOD_DAY = PERIOD_HOUR * 24;
	
	public static void main(String[] args) throws Exception {
		Timer timer = new Timer();
		Date now = new Date();
        timer.schedule(new MinuteTask(), now, PERIOD_MINUTE);
        timer.schedule(new TenMinTask(), now, PERIOD_TENMIN);
        timer.schedule(new HourTask(), now, PERIOD_HOUR);
        timer.schedule(new DayTask(), now, PERIOD_DAY);
	}
	
	/**
	 * run every minute
	 */
	public static void minute() {
		final String[] uris = {
			"/update/bitfinex.jsp",
			"/update/poloniex.jsp",
			"/update/gatecoin.jsp",
			"/update/kraken.jsp",
			"/update/yunbi.jsp",
			"/update/bittrex.jsp",
			//"/update/livecoin.jsp",
			"/update/quadrigacx.jsp",
			"/update/cex.jsp",
			"/update/yobit.jsp",
			"/update/btce.jsp",
			"/update/gemini.jsp",
			"/update/bitso.jsp",
			"/update/gdax.jsp",
			"/update/okcoin.jsp",
			"/update/bitcoinaverage.jsp",
			"/update/average.jsp",
		};
		
		for (String uri:uris) {
			retrieveData(host + uri);
		}
		
		retrieveArray(host + "/update/avg24hv3.jsp");
		retrieveArray(host + "/update/avg24husdv3.jsp");
	}
	
	public static void tenmin() {
		final String tenmin = "/update/tenmin.jsp";		
		retrieveArray(host + tenmin);
	}
	
	public static void hour() {
		final String hour = "/update/hour.jsp";		
		retrieveArray(host + hour);
	}
	
	public static void day() {
		final String day = "/update/day.jsp";		
		retrieveArray(host + day);
	}
	
	private static JSONObject retrieveData(String url) {
		log.log(Level.INFO, "calling " + url);
		JSONObject json = null;
		try {
			json = RetrieveData.jsonData(url);
		} catch (Exception ex) {
			log.log(Level.WARNING, "unable to retrieve data from " + url, ex);
		}
		return json;
	}
	
	private static JSONArray retrieveArray(String url) {
		log.log(Level.INFO, "calling " + url);
		JSONArray json = null;
		try {
			json = RetrieveData.jsonArray(url);
		} catch (Exception ex) {
			log.log(Level.WARNING, "unable to retrieve data from " + url, ex);
		}
		return json;
	}
	
	/** runs every minute */
	private static class MinuteTask extends TimerTask {
        public void run() {
        	log.log(Level.INFO, "runs every minute");
        	minute();
        }
    }
	
	private static class TenMinTask extends TimerTask {
		public void run() {
			log.log(Level.INFO, "runs every 10 mins");
			tenmin();
		}
	}
	
	private static class HourTask extends TimerTask {
		public void run() {
			log.log(Level.INFO, "runs every hour");
			hour();
		}
	}
	
	private static class DayTask extends TimerTask {
		public void run() {
			log.log(Level.INFO, "runs every day");
			day();
		}
	}
	
}
