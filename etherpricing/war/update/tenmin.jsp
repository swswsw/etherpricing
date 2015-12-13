<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>    
<%@ page import="com.googlecode.objectify.Key" %>
<%@ page import="com.googlecode.objectify.ObjectifyService" %>
<%@ page import="com.etherpricing.model.*" %>
<%@ page import="com.etherpricing.objectify.ObjectifyManager"%>

<%
long timeMillis = System.currentTimeMillis();
long wholeMinute = Minute.calcWholeTime(timeMillis);
final long MILLIS_IN_TEN_MINUTES = 1000l * 60l * 10l;
Date start = new Date(wholeMinute - MILLIS_IN_TEN_MINUTES);
Date end = new Date(wholeMinute);

// get last 10 minutes' data
// note, this may not be able to get current time.  because it might take sometime for the index to get updated.
List<Minute> tenmins = ObjectifyService.ofy()
          .load()
          .type(Minute.class) // We want only minute class
          .filter("timeslot >", start)
          .filter("timeslot <=", end)
          .order("-timeslot")       // Most recent first - timestamp
          .list();
		
// sum up the 10 mins results
%>
<%=tenmins%>