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
 * @param currencyPair - xbtce currencyPair, eg. ETHBTC
 */
private PriceCache.Price convertToPrice(String currencyPair, JSONObject obj, long time, String exchange) {
	String currency1 = currencyPair.substring(0, 3);
	String currency2 = currencyPair.substring(3);
	double last = obj.getDouble("BestBid");
	double volume = obj.getDouble("DailyTradedTotalVolume");
	return new PriceCache.Price(currency1, currency2, last, volume, time, exchange);
}
%>
<%
// works on deployed version, doesn't work on local dev server.  "Could not verify SSL certificate"

JSONArray array = null;
try {
	array = RetrieveData.jsonArray("https://cryptottlivewebapi.xbtce.net:8443/api/v1/public/ticker");
} catch (SocketTimeoutException ex) {
	// sometimes, timeout can occur
	throw ex;
}

final long time = System.currentTimeMillis();
final String xbtce = "xBTCe";

PriceCache pc = new PriceCache();

if (array != null) {	
	for (int i=0; i<array.length(); i++) {
		JSONObject json = array.getJSONObject(i);
		if (json.getString("Symbol") != null) {
			String currencyPair = json.getString("Symbol");
			if (currencyPair.startsWith("ETH")) {
				// note, xbtce has currencypair ethcnh and ethltc, although we don't currently handle cnh right now.
				PriceCache.Price price = convertToPrice(currencyPair, json, time, xbtce);
				pc.getPriceList().add(price);
			}
		}
	}
}


CacheManager.save("latest_xbtce", pc);
%>
<%=pc%>