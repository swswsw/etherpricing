<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="updateheader.jspf" %>
<%@ page import="java.util.*" %>    
<%@ page import="com.googlecode.objectify.Key" %>
<%@ page import="com.googlecode.objectify.ObjectifyService" %>
<%@ page import="com.etherpricing.model.*" %>
<%@ page import="com.etherpricing.objectify.ObjectifyManager"%>

<%
long timeMillis = System.currentTimeMillis();
long wholeMinute = TenMinute.calcWholeTime(timeMillis);
final long MILLIS_IN_TEN_MINUTES = 1000L * 60L * 10L;
Date start = new Date(wholeMinute - MILLIS_IN_TEN_MINUTES);
Date end = new Date(wholeMinute);

// get last 10 minutes' data
// note, this may not be able to get current time.  because it might take sometime for the index to get updated.
List<Minute> mins = ObjectifyService.ofy()
          .load()
          .type(Minute.class) // We want only minute class
          .filter("timeslot >", start)
          .filter("timeslot <=", end)
          .order("-timeslot")       // Most recent first - timestamp
          .list();

//sum up the 10 mins results
if (mins.size() > 0) {
	double sum = 0.0d;
	double volume = 0.0d;
	double sumUsd = 0.0d;
	boolean sumUsdComplete = true;
	for (Minute minute:mins) {
		sum += minute.sum;
		volume += minute.volume;
		sumUsd += minute.sumUsd;
		if (minute.sumUsd == 0.0d) {
			sumUsdComplete = false;
		}
	}
	
	// if one of the sumUsd is 0, then not all data is complete.  report sumUsd as 0.
	if (!sumUsdComplete) { sumUsd = 0.0d; }
	
	TenMinute value = new TenMinute();
	value.id = wholeMinute;
	value.sum = sum;
	value.volume = volume;
	value.average = (volume > 0) ? (sum / volume) : 0.0d;
	value.timeslot = end;
	value.timestamp = timeMillis;
	value.avgUsd = (volume > 0 && sumUsdComplete) ? (sumUsd / volume) : 0.0d;
	value.sumUsd = sumUsd;
	
	ObjectifyManager.save(value);
}

%>
<%=mins%>