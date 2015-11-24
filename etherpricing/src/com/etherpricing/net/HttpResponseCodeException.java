package com.etherpricing.net;

import java.net.HttpURLConnection;

/**
 * thrown when the resulting http response code is not 200 ok.  
 * @author sol wu
 *
 */
public class HttpResponseCodeException extends Exception {

	public static final int UNKNOWN = -1;
	
	private final int responseCode;
	private final String responseMessage;
	
	public HttpResponseCodeException(int responseCode, String responseMessage) {
		this.responseCode = responseCode;
		this.responseMessage = responseMessage;
	}
	
	public int getResponseCode() {
		return responseCode;
	}
	
	public String getResponseMessage() {
		return responseMessage;
	}

	public String toString() {
		return "http responseCode=" + getResponseCode() 
				+ ". http responseMessage=" + getResponseMessage() 
				+ ".  super message: " + super.toString();
	}
	
}
