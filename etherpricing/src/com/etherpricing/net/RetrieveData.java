package com.etherpricing.net;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.logging.Level;
import java.util.logging.Logger;

import org.json.JSONArray;
import org.json.JSONObject;


public class RetrieveData {
	private static final Logger log = Logger.getLogger(RetrieveData.class.getName());
	
	private static String userAgent = "java";

	public static JSONObject jsonData(String sUrl) 
			throws IOException, HttpResponseCodeException {
		JSONObject json = null;
		try {
			// 
	        URL url = new URL(sUrl);
	        HttpURLConnection connection = (HttpURLConnection) url.openConnection();
	        connection.setRequestProperty("Content-Type", "application/json");
	        //connection.setRequestProperty("accept", "application/json");
	        //connection.setRequestMethod("GET");
	        // on deployed server, it will append appengine specific strings.  see https://cloud.google.com/appengine/docs/java/outbound-requests#request_headers
	        connection.setRequestProperty("User-Agent", userAgent);
	 
	        if (connection.getResponseCode() == HttpURLConnection.HTTP_OK) {
	            // OK
	            BufferedReader reader = new BufferedReader(new InputStreamReader(connection.getInputStream()));
	            StringBuffer sb = new StringBuffer(); 
	            String line;
	            while ((line = reader.readLine()) != null) {
	            	sb.append(line).append(System.lineSeparator()); // should we append this with line break
	            }
	            reader.close();
	 
	            json = new JSONObject(sb.toString());
	            //int count = jsonObj.getInt("count");
	            
	        } else {
	            // Server returned HTTP error code.
	        	// throw exception
	        	throw new HttpResponseCodeException(connection.getResponseCode(), connection.getResponseMessage());
	        }
	 
		} catch (MalformedURLException ex) {
			log.log(Level.WARNING, "malformed url.  this should not happen as the input should have be vetted", ex);
		}
//	    } catch (Exception e) {
//	    	return null;
//	    }
		
		return json;
		
	}
	
	/**
	 * same as jsonData, except this returns JSONArray instead of 
	 * JSONObject.  the data in sUrl must be an array.
	 * @param sUrl
	 * @return
	 * @throws IOException
	 * @throws HttpResponseCodeException
	 */
	public static JSONArray jsonArray(String sUrl) 
			throws IOException, HttpResponseCodeException {
		JSONArray json = null;
		try {
			// 
	        URL url = new URL(sUrl);
	        HttpURLConnection connection = (HttpURLConnection) url.openConnection();
	        connection.setRequestProperty("Content-Type", "application/json");
	        connection.setRequestProperty("User-Agent", userAgent);
	 
	        if (connection.getResponseCode() == HttpURLConnection.HTTP_OK) {
	            // OK
	            BufferedReader reader = new BufferedReader(new InputStreamReader(connection.getInputStream()));
	            StringBuffer sb = new StringBuffer(); 
	            String line;
	            while ((line = reader.readLine()) != null) {
	            	sb.append(line).append(System.lineSeparator()); // should we append this with line break
	            }
	            reader.close();
	 
	            json = new JSONArray(sb.toString());
	            //int count = jsonObj.getInt("count");
	            
	        } else {
	            // Server returned HTTP error code.
	        	// throw exception
	        	throw new HttpResponseCodeException(connection.getResponseCode(), connection.getResponseMessage());
	        }
	 
		} catch (MalformedURLException ex) {
			log.log(Level.WARNING, "malformed url.  this should not happen as the input should have be vetted", ex);
		}
//	    } catch (Exception e) {
//	    	return null;
//	    }
		
		return json;
		
	}
	
}
