<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="exportheader.jspf" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="com.googlecode.objectify.Key" %>
<%@ page import="com.googlecode.objectify.ObjectifyService" %>
<%@ page import="com.etherpricing.model.*" %>
<%@ page import="com.etherpricing.objectify.ObjectifyManager"%>

<%!
private static String printCsvLine(Hour hour) {
	StringBuilder sb = new StringBuilder();
	sb.append(hour.id) // same as timeslot (epoch time)
		.append(",").append(toIsoDate(hour.timeslot))
		.append(",").append(hour.average)
		.append(",").append(hour.volume)
		.append(",").append(hour.sum)
		.append(getLineEnd())
		;
	return sb.toString();
}

private static String getLineEnd() {
	return System.lineSeparator();
}

private static String toIsoDate(Date date) {
	TimeZone tz = TimeZone.getTimeZone("UTC");
	DateFormat df = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
	df.setTimeZone(tz);
	String iso = df.format(new Date());
	return iso;
}
%>

<%
response.setContentType("text/csv");

String paramStart = request.getParameter("start");
String paramEnd = request.getParameter("end");

if (paramStart != null && !"".equals(paramStart)
	&& paramEnd != null && !"".equals(paramEnd)) {
	Date start = new Date(Long.parseLong(paramStart));
	Date end = new Date(Long.parseLong(paramEnd));
	System.out.println(start);
	System.out.println(end);
	
	// get data
	// note, this may not be able to get current time.  because it might take sometime for the index to get updated.
	List<Hour> hours = ObjectifyService.ofy()
	          .load()
	          .type(Hour.class)
	          .filter("timeslot >=", start)
	          .filter("timeslot <=", end)
	          .order("timeslot")       // Most recent first - timestamp
	          .list();

	//sum up the 10 mins results
	if (hours.size() > 0) {
		double sum = 0.0d;
		double volume = 0.0d;
		for (Hour hour:hours) {
			// convert to csv
%>

			<%=printCsvLine(hour)%>

<%
		}

	} else {
		System.out.println("test");
	}
	
} else {
	throw new IllegalArgumentException("parameters missing or invalid parameters");
}



%>
