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
public static final String CACHE_PREFIX = "avg24husdv3";
%>

<%
//
// show the price within 24h
//

long timeMillis = System.currentTimeMillis();
// todo: to further save the quota, i will use exact time minute time, 
// so this will only update cache every 10 minutes.
// i will want to change this back to per minute when i want to show more detailed data 
long wholeTime = TenMinute.calcWholeTime(timeMillis);
final long MILLIS_IN_ONE_DAY = 1000L * 60L * 60L * 24L;
long startTime = wholeTime - MILLIS_IN_ONE_DAY;
long endTime = wholeTime;
Date start = new Date(startTime);
Date end = new Date(endTime);

// get from cache
String result = CacheManager.getString(CACHE_PREFIX);

if (result == null) {
	// if not, get data and fill cache
	
	// get data
	// note, this may not be able to get current time.  because it might take sometime for the index to get updated.
	List<TenMinute> tenmins = ObjectifyService.ofy()
	          .load()
	          .type(TenMinute.class)
	          .filter("timeslot >", start)
	          .filter("timeslot <=", end)
	          .order("timeslot")       // Most recent first - timestamp
	          .list();
	
	// convert to json array of array.
	// eg.
	//[
	//[1456728329000, 0.02123456, 35123456, 10.1234],
	//[1456728332000, 0.02234356, 36123456, 10.6789],
	//]
	//
	//[time, price_in_xbt, volume, price_in_usd]
	
	JSONArray arrays = new JSONArray();
	for (TenMinute tenmin: tenmins) {
		JSONArray array = new JSONArray();
		array.put(tenmin.id);
		array.put(tenmin.average);
		array.put(tenmin.volume);
		array.put(tenmin.avgUsd);
		arrays.put(array);
	}

	result = arrays.toString(2);
	
	CacheManager.save(CACHE_PREFIX, result);
}
%>
<%=result%>