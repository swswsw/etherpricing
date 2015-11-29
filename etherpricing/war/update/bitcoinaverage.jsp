<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@ page import="com.etherpricing.net.*" %>
<%@ page import="com.etherpricing.cache.*" %>
<%@ page import="org.json.*" %>
<%
// get bitcoinaverge prices
// https://api.bitcoinaverage.com/ticker/global/all

JSONObject json = null;
try {
	json = RetrieveData.jsonData("https://api.bitcoinaverage.com/ticker/global/all");
} catch (SocketTimeoutException ex) {
	// sometimes, timeout can occur
	throw ex;
}

if (json != null) {	
	CacheManager.save("latest_bitcoinaverage", json.toString());
}
%>
<%=(json != null) ? json.toString(2) : null %>