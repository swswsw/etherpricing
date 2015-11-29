<%-- give an overall data shown on the first part of the page --%>
<%@page import="org.json.JSONObject"%>
<%@page import="com.etherpricing.cache.CacheManager"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="apiheader.jspf" %>
<%
// fetch data from cache and display.
String sAverage = CacheManager.getString("latest_average");
JSONObject result;
if (sAverage != null) {
	result = new JSONObject(sAverage);
} else {
	result = new JSONObject("{ \"error\": \"temporarily not available.  please try again later.\" }");
}
// if cache not available, return error.
%>
<%=result.toString(2)%>