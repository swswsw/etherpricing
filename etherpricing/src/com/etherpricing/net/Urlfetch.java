package com.etherpricing.net;

import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.logging.Level;
import java.util.logging.Logger;

import org.json.JSONArray;
import org.json.JSONObject;

import com.google.appengine.api.urlfetch.FetchOptions;
import com.google.appengine.api.urlfetch.HTTPHeader;
import com.google.appengine.api.urlfetch.HTTPMethod;
import com.google.appengine.api.urlfetch.HTTPRequest;
import com.google.appengine.api.urlfetch.HTTPResponse;
import com.google.appengine.api.urlfetch.URLFetchService;
import com.google.appengine.api.urlfetch.URLFetchServiceFactory;

/**
 * retrieve data using appengine's low level urlfetch.  
 * this allows us to set some options that are otherwise unavailable with httpurlconnection.  
 * options such as doNotValidateCertificate
 * 
 * @author sol wu
 *
 */
public class Urlfetch {
	
	private static final Logger log = Logger.getLogger(Urlfetch.class.getName());

	public static JSONObject jsonData(String sUrl) 
		throws IOException {
		JSONObject json = null;
		try {
//			HTTPRequest httpRequest = new HTTPRequest(new URL(sUrl), HTTPMethod.GET, FetchOptions.Builder.validateCertificate());
//			URLFetchService service = URLFetchServiceFactory.getURLFetchService();
//			HTTPResponse httpResponse = service.fetch(httpRequest);
//			String content = new String(httpResponse.getContent());
			
			URLFetchService fetcher = URLFetchServiceFactory.getURLFetchService();
	        FetchOptions lFetchOptions = FetchOptions.Builder
	        		.doNotValidateCertificate()
	        		.setDeadline(20D)
	        		.doNotFollowRedirects();
	        HTTPRequest request = new HTTPRequest(new URL(sUrl), HTTPMethod.GET, lFetchOptions);
	        // setting user-agent works on both development server and deployed server
	        request.addHeader(new HTTPHeader("user-agent", "Java")); // gdax requires user agent
	        HTTPResponse response = fetcher.fetch(request);
	        String content = new String(response.getContent());
			
			json = new JSONObject(content);
		} catch (MalformedURLException ex) {
			log.log(Level.WARNING, "malformed url.  this should not happen as the input should have be vetted", ex);
		}
		
		return json;
	}
	
	public static JSONArray jsonArray(String sUrl) 
		throws IOException {
		JSONArray json = null;
		try {
//				HTTPRequest httpRequest = new HTTPRequest(new URL(sUrl), HTTPMethod.GET, FetchOptions.Builder.validateCertificate());
//				URLFetchService service = URLFetchServiceFactory.getURLFetchService();
//				HTTPResponse httpResponse = service.fetch(httpRequest);
//				String content = new String(httpResponse.getContent());
			
			URLFetchService fetcher = URLFetchServiceFactory.getURLFetchService();
	        FetchOptions lFetchOptions = FetchOptions.Builder
	        		.doNotValidateCertificate()
	        		.setDeadline(20D)
	        		.doNotFollowRedirects();
	        HTTPRequest request = new HTTPRequest(new URL(sUrl), HTTPMethod.GET, lFetchOptions);
	        // setting user-agent works on both development server and deployed server
	        request.addHeader(new HTTPHeader("user-agent", "Java")); // gdax requires user agent
	        HTTPResponse response = fetcher.fetch(request);
	        String content = new String(response.getContent());
			
			json = new JSONArray(content);
		} catch (MalformedURLException ex) {
			log.log(Level.WARNING, "malformed url.  this should not happen as the input should have be vetted", ex);
		}
		
		return json;
	}
}
