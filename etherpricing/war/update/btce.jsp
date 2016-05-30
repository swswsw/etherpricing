<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="updateheader.jspf" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@ page import="com.etherpricing.net.*" %>
<%@ page import="com.etherpricing.cache.*" %>
<%@ page import="org.json.*" %>
<%!
/**
 * @param currencyPair - btce currencyPair, eg. eth_btc, etc_usd
 */
private PriceCache.Price convertToPrice(String currencyPair, JSONObject obj, long time, String exchange) {
	String[] currencies = currencyPair.split("_");
	String currency1 = currencies[0].toUpperCase();
	String currency2 = currencies[1].toUpperCase();
	double last = obj.getDouble("last");
	double volume = obj.getDouble("vol_cur"); // not "vol".  vol_cur is volume in currency1.  vol is volume in currency2.
	return new PriceCache.Price(currency1, currency2, last, volume, time, exchange);
}
%>
<%
JSONObject json = null;
try {
	json = RetrieveData.jsonData("https://btc-e.com/api/3/ticker/eth_btc-eth_usd-eth_rur");
} catch (SocketTimeoutException ex) {
	// sometimes, timeout can occur
	throw ex;
}

final long time = System.currentTimeMillis();
final String btce = "BTC-e";

PriceCache pc = new PriceCache();

if (json != null) {	
	for (Iterator<String> keys = json.keys(); keys.hasNext(); ) {
		String key = keys.next();
		JSONObject value = json.getJSONObject(key);
		PriceCache.Price price = convertToPrice(key, value, time, btce);
		pc.getPriceList().add(price);
	}
}


CacheManager.save("latest_btce", pc);
%>
<%=pc%>