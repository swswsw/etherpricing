<%-- all time high result --%>

<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONArray"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="apiheader.jspf" %>
<%@ page import="java.util.*" %>    
<%@ page import="com.googlecode.objectify.Key" %>
<%@ page import="com.googlecode.objectify.ObjectifyService" %>
<%@ page import="com.etherpricing.cache.*" %>
<%@ page import="com.etherpricing.model.*" %>
<%@ page import="com.etherpricing.objectify.ObjectifyManager"%>

<%!
public static final String CACHE_PREFIX = "ath";
/**
 * create standard cache key
 * @param timeMillis - epoch time, as in System.currentTimeMillis()
 */
private static String getCacheKey(long timeMillis) {
	return CACHE_PREFIX + timeMillis;
}

%>

<%
//
// show the all time high price
//

long timeMillis = System.currentTimeMillis();
final long MILLIS_IN_ONE_MINUTE = 1000L * 60L;
long wholeTime = Minute.calcWholeTime(timeMillis);

// get from cache
String result = CacheManager.getString(getCacheKey(wholeTime));

if (result == null) {
	// if not, get data and fill cache
	
	// get data
	Minute ath = ObjectifyService.ofy()
	          .load()
	          .type(Minute.class)
	          .order("-average")       // largest first
	          .first()
	          .now();
	
	Minute athUsd = ObjectifyService.ofy()
	          .load()
	          .type(Minute.class)
	          .order("-avgUsd")       // largest first
	          .first()
	          .now();
	
	
	JSONObject json = new JSONObject();
	
	json.put("ath", ath.average);
	json.put("athTimestamp", ath.timestamp);
	json.put("athUsd", athUsd.avgUsd);
	json.put("athUsdTimestamp", athUsd.timestamp);
	
	result = json.toString(2);
	
	// temporary remove cache
	//CacheManager.save(getCacheKey(wholeTime), result);
	
	// delete earlier cached item
	//long lastCacheTime = wholeTime - MILLIS_IN_ONE_MINUTE;
	//CacheManager.delete(getCacheKey(lastCacheTime));
}
%>
<%=result%>