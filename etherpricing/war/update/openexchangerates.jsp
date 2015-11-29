<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@ page import="com.etherpricing.net.*" %>
<%@ page import="com.etherpricing.cache.*" %>
<%@ page import="org.json.*" %>
<%
JSONObject json = null;
try {
	json = RetrieveData.jsonData("http://openexchangerates.org/api/latest.json?app_id=638d04bc42aa455d9432dcc9e900e454");
} catch (SocketTimeoutException ex) {
	// sometimes, timeout can occur
	throw ex;
}

CacheManager.save("latest_openexchangerates", json.toString());
%>
<%=json.toString(2)%>