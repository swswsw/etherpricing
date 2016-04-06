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
 * @param currencyPair - yunbi currencyPair, eg. ethbtc, ethcny
 */
private PriceCache.Price convertToPrice(String currencyPair, JSONObject obj, long time, String exchange) {
	String currency1 = currencyPair.substring(0,3).toUpperCase(); // first 3 characters are currency1
	String currency2 = currencyPair.substring(3).toUpperCase(); // rest of the strings
	JSONObject ticker = obj.getJSONObject("ticker");
	double last = ticker.getDouble("last");
	double volume = ticker.getDouble("vol");
	return new PriceCache.Price(currency1, currency2, last, volume, time, exchange);
}
%>
<%
JSONObject json = null;
try {
	json = RetrieveData.jsonData("https://yunbi.com/api/v2/tickers");
} catch (SocketTimeoutException ex) {
	// sometimes, timeout can occur
	throw ex;
}

final long time = System.currentTimeMillis();
final String yunbi = "Yunbi";

PriceCache pc = new PriceCache();

if (json != null) {
	for (Iterator<String> keys = json.keys(); keys.hasNext(); ) {
		String key = keys.next();
		String currencyPair = key.toUpperCase(); // normalize to upper case
		JSONObject value = json.getJSONObject(key);
		if (currencyPair.startsWith("ETH")) {
			PriceCache.Price price = convertToPrice(currencyPair, value, time, yunbi);
			pc.getPriceList().add(price);
		}
	}
}


CacheManager.save("latest_yunbi", pc);
%>
<%=pc%>