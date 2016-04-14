<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="exportheader.jspf" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="com.googlecode.objectify.Key" %>
<%@ page import="com.googlecode.objectify.ObjectifyService" %>
<%@ page import="com.etherpricing.model.*" %>
<%@ page import="com.etherpricing.objectify.ObjectifyManager"%>
<%@ page import="com.etherpricing.util.*" %>

<%!
private static String printCsvLine(Minute entity) {
	StringBuilder sb = new StringBuilder();
	sb.append(entity.id) // same as timeslot (epoch time)
		.append(",").append(DateUtil.toIso(entity.timeslot))
		.append(",").append(entity.average)
		.append(",").append(entity.volume)
		.append(",").append(entity.sum)
		.append(getLineEnd())
		;
	return sb.toString();
}

private static String getLineEnd() {
	return System.lineSeparator();
}

/**
 * convert to csv
 */
private static StringBuilder toCsv(List<Minute> list) {
	StringBuilder sb = new StringBuilder();
	for (Minute entity:list) {
		// convert to csv
		sb.append(printCsvLine(entity));
	}
	
	return sb;
}


%>

<%
boolean enable = false;

StringBuilder csv = new StringBuilder();

if (!enable) { 
	response.sendRedirect("disabled.jsp");
} else {
	
	//response.setContentType("text/csv");
	
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
		List<Minute> entities = ObjectifyService.ofy()
		          .load()
		          .type(Minute.class)
		          .filter("timeslot >=", start)
		          .filter("timeslot <=", end)
		          .order("timeslot")       // Most recent first - timestamp
		          .list();
	
		csv = toCsv(entities);
		
	} else {
		throw new IllegalArgumentException("parameters missing or invalid parameters");
	}
}


%>
<%=csv.toString()%>