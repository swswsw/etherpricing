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
long wholeTime = Day.calcWholeTime(timeMillis);
final long MILLIS_IN_ONE_DAY = 1000L * 60L * 60L * 24L;
Date start = new Date(wholeTime - MILLIS_IN_ONE_DAY);
Date end = new Date(wholeTime);

// get last day's data
// note, this may not be able to get current time.  because it might take sometime for the index to get updated.
List<Hour> hours = ObjectifyService.ofy()
          .load()
          .type(Hour.class) // We want only minute class
          .filter("timeslot >", start)
          .filter("timeslot <=", end)
          .order("-timeslot")       // Most recent first - timestamp
          .list();

		
if (hours.size() > 0) {
	//sum up results
	double sum = 0.0d;
	double volume = 0.0d;
	double sumUsd = 0.0d;
	boolean sumUsdComplete = true;
	for (Hour hour:hours) {
		sum += hour.sum;
		volume += hour.volume;
		if (hour.sumUsd == 0.0d) {
			sumUsdComplete = false;
		}
	}
	
	// if one of the sumUsd is 0, then not all data is complete.  report sumUsd as 0.
	if (!sumUsdComplete) { sumUsd = 0.0d; }

	Day value = new Day();
	value.id = wholeTime;
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
<%=hours%>