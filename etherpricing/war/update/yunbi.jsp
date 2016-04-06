<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="updateheader.jspf" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@ page import="com.etherpricing.net.*" %>
<%@ page import="com.etherpricing.cache.*" %>
<%@ page import="org.json.*" %>
<%
JSONObject json = null;
try {
	json = RetrieveData.jsonData("https://www.gatecoin.com/api/Public/LiveTickers");
} catch (SocketTimeoutException ex) {
	// sometimes, timeout can occur
	throw ex;
}

final long time = System.currentTimeMillis();
final String gatecoin = "Gatecoin";

List<JSONObject> ethTickers = new ArrayList<JSONObject>(5);
if (json != null) {
	JSONArray tickers = json.getJSONArray("tickers");
	if (tickers != null) {
		int length = tickers.length();
		for (int i=0; i<length; i++) {
			JSONObject ticker = tickers.getJSONObject(i);
			String currencyPair = ticker.getString("currencyPair");
			if (currencyPair != null) {
				if (currencyPair.startsWith("ETH") || currencyPair.endsWith("ETH")) {
					ethTickers.add(ticker);
				}
			}
		}
	}
}

PriceCache pc = new PriceCache();
for (int i=0; i<ethTickers.size(); i++) {
	JSONObject ethTicker = ethTickers.get(i);
	// eg. currencyPair = "ETHBTC"
	String currencyPair = ethTicker.getString("currencyPair");
	String currency1 = currencyPair.substring(0,3); // first 3 characters are currency1
	String currency2 = currencyPair.substring(3); // last 3 characters are currency2
	PriceCache.Price price = new PriceCache.Price(currency1, currency2, 
			ethTicker.getDouble("last"), ethTicker.getDouble("volume"), time, gatecoin);
	pc.getPriceList().add(price);
}

CacheManager.save("latest_gatecoin", pc);
%>
<%=pc%>