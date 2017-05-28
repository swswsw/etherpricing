<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="updateheader.jspf" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.etherpricing.net.*" %>
<%@ page import="com.etherpricing.cache.*" %>
<%@ page import="org.json.*" %>
<%!
/**
 * convert json data to price object
 */
private PriceCache.Price retrieveData(String url, String currency1, String currency2, String exchange)
	throws IOException, HttpResponseCodeException {
	PriceCache.Price result = null;
	final long time = System.currentTimeMillis();
	JSONObject json = RetrieveData.jsonData(url);
	result = new PriceCache.Price(currency1, currency2, json.getDouble("last"), json.getDouble("volume"), time, exchange);
	return result;
}
%>

<%
final String bitstamp = "Bitstamp";
PriceCache.Price ethbtc = retrieveData("https://www.bitstamp.net/api/v2/ticker/ethbtc/", "ETH", "BTC", bitstamp);
PriceCache.Price ethusd = retrieveData("https://www.bitstamp.net/api/v2/ticker/ethusd/", "ETH", "USD", bitstamp);
PriceCache.Price etheur = retrieveData("https://www.bitstamp.net/api/v2/ticker/etheur/", "ETH", "EUR", bitstamp);
PriceCache pc = new PriceCache();
if (ethbtc != null) {
	pc.getPriceList().add(ethbtc);
}

if (ethusd != null) {
	pc.getPriceList().add(ethusd);
}

if (etheur != null) {
	pc.getPriceList().add(etheur);
}

if (pc.getPriceList().size() > 0) {
	CacheManager.save("latest_bitstamp", pc);
}
%>
<%=pc%>