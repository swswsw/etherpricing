<%-- give an overall data shown on the first part of the page --%>
<%@page import="java.util.*"%>
<%@page import="org.json.JSONObject"%>
<%@page import="com.etherpricing.cache.*"%>
<%@page import="flexjson.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="apiheader.jspf" %>
<%
// fetch data from cache and display.
ArrayList<PriceCache.Price> priceList = CacheManager.getPriceList("price_list");
String result;
if (priceList != null) {
	JSONSerializer serializer = new JSONSerializer();
	// exclude class name.  don't serialize class name.  (otherwise, there will be class field    class: "com.ether.PriceCache$Price")
	result = serializer.exclude("*.class").serialize(priceList);
} else {
	result = "{ \"error\": \"temporarily not available.  please try again later.\" }";
}
// if cache not available, return error.
%>
<%=result%>