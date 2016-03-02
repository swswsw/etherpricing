<%@page import="org.json.JSONArray"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="apiheader.jspf" %>
<%@ page import="java.util.*" %>    
<%@ page import="com.googlecode.objectify.Key" %>
<%@ page import="com.googlecode.objectify.ObjectifyService" %>
<%@ page import="com.etherpricing.model.*" %>
<%@ page import="com.etherpricing.objectify.ObjectifyManager"%>

<%
//
// show the price within 24h
//

long timeMillis = System.currentTimeMillis();
final long MILLIS_IN_ONE_DAY = 1000L * 60L * 60L * 24L;
Date start = new Date(timeMillis - MILLIS_IN_ONE_DAY);
Date end = new Date(timeMillis);

// get last 10 minutes' data
// note, this may not be able to get current time.  because it might take sometime for the index to get updated.
List<TenMinute> hours = ObjectifyService.ofy()
          .load()
          .type(TenMinute.class)
          .filter("timeslot >", start)
          .filter("timeslot <=", end)
          .order("-timeslot")       // Most recent first - timestamp
          .list();

// convert to json array of array.
// eg.
//[
//[1456728329000, 437.72],
//[1456728332000, 437.71],
//]

JSONArray results = new JSONArray();
for (TenMinute hour: hours) {
	JSONArray result = new JSONArray();
	result.put(hour.id);
	result.put(hour.average);
	results.put(result);
}
%>
<%=results.toString(2)%>