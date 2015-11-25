<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@ page import="com.etherpricing.net.*" %>
<%@ page import="com.etherpricing.cache.*" %>
<%@ page import="org.json.*" %>
<%
// get bitcoinaverge btc_usd prices
// https://api.bitcoinaverage.com/ticker/global/USD/

JSONObject json = null;
try {
	json = RetrieveData.jsonData("https://api.bitcoinaverage.com/ticker/global/USD/");
} catch (SocketTimeoutException ex) {
	// sometimes, timeout can occur
	throw ex;
}

PriceCache pc = new PriceCache();
if (json != null) {
	double last = json.getDouble("last");
	double volume = json.getDouble("volume_btc");
	
	PriceCache.Price price = new PriceCache.Price("BTC", "USD", last, volume);
	pc.getPriceList().add(price);
	
	CacheManager.save("latest_bitcoinaverage", pc);
}
%>
<%=pc%>