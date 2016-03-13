<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="updateheader.jspf" %>
<%@ page import="java.util.*" %>
<%@ page import="com.etherpricing.net.*" %>
<%@ page import="com.etherpricing.cache.*" %>
<%@ page import="org.json.*" %>
<%
// note: this works on cloud, but does not work on local dev server (v1.9.7).  javax.net.ssl.SSLHandshakeException: Could not verify SSL certificate for URL: https://api.livecoin.net/exchange/ticker?currencyPair=ETH/BTC

// same as livecoin.jsp class.  just to test urlfetch.

// use Urlfetch instead of RetrieveData class
JSONObject json = Urlfetch.jsonData("https://api.livecoin.net/exchange/ticker?currencyPair=ETH/BTC");
final long time = System.currentTimeMillis();
final String livecoin = "Livecoin"; 
PriceCache pc = new PriceCache();
if (json != null) {
	PriceCache.Price price = 
		new PriceCache.Price("ETH", "BTC", json.getDouble("last"), json.getDouble("volume"), time, livecoin);
	
	pc.getPriceList().add(price);
	
	// todo: temp
	//CacheManager.save("latest_livecoin", pc);
}
%>
<%=pc%>