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
 * @param currencyPair - kraken currencyPair, eg. XETHXXBT, XETHZEUR
 */
private PriceCache.Price convertToPrice(String currencyPair, JSONObject krakenObj, long time, String exchange) {
	String currency1 = currencyPair.substring(1, 4); // ignore the leading x or z
	String currency2 = currencyPair.substring(5, 8); // ignore the leading x or z
	JSONArray lastArray = krakenObj.getJSONArray("c"); // "c" is last traded array
	double last = lastArray.getDouble(0); // index 0 is last price
	JSONArray volumeArray = krakenObj.getJSONArray("v"); // "v" is volume array
	double volume = volumeArray.getDouble(1); // index 1 is 24h volume
	return new PriceCache.Price(currency1, currency2, last, volume, time, exchange);
}
%>
<%
JSONObject json = null;
try {
	json = RetrieveData.jsonData("https://api.kraken.com/0/public/Ticker?pair=ETHXBT,ETHUSD,ETHEUR,ETHCAD,ETHGBP,ETHJPY");
} catch (SocketTimeoutException ex) {
	// sometimes, timeout can occur
	throw ex;
}

final long time = System.currentTimeMillis();
final String kraken = "Kraken";

PriceCache pc = new PriceCache();

if (json != null) {
	// perhaps we should also check that "error" is an empty array
	JSONObject result = json.getJSONObject("result"); // what if result is not there?
	if (result != null) {
		
		for (Iterator<String> keys = result.keys(); keys.hasNext(); ) {
			String key = keys.next();
			JSONObject value = result.getJSONObject(key);
			PriceCache.Price price = convertToPrice(key, value, time, kraken);
			pc.getPriceList().add(price);
		}
	}
}


CacheManager.save("latest_kraken", pc);
%>
<%=pc%>