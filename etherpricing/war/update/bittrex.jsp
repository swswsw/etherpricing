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
	json = RetrieveData.jsonData("https://bittrex.com/api/v1.1/public/getmarketsummaries");
} catch (SocketTimeoutException ex) {
	// sometimes, timeout can occur
	throw ex;
}

final long time = System.currentTimeMillis();
final String bittrex = "Bittrex";

List<JSONObject> ethTickers = new ArrayList<JSONObject>(5);
if (json != null) {
	boolean success = json.getBoolean("success");
	if (success) {
		JSONArray tickers = json.getJSONArray("result");
		if (tickers != null) {
			int length = tickers.length();
			for (int i=0; i<length; i++) {
				JSONObject ticker = tickers.getJSONObject(i);
				String currencyPair = ticker.getString("MarketName");
				if (currencyPair != null) {
					if (currencyPair.startsWith("ETH") || currencyPair.endsWith("ETH")) {
						ethTickers.add(ticker);
					}
				}
			}
		}
	}
}
  
PriceCache pc = new PriceCache();
for (int i=0; i<ethTickers.size(); i++) {
	JSONObject ethTicker = ethTickers.get(i);
	// eg. currencyPair = "BTC-ETH".  each currency may be more than 3 characters.
	String currencyPair = ethTicker.getString("MarketName");
	String[] currencies = currencyPair.split("-"); // separated by "-""
	// note we have to flip currency1 and currency2
	String currency1 = currencies[1];
	String currency2 = currencies[0];
	// this works for BTC-ETH, not for ETH-BTC pair.  last and volume would be incorrect.
	if ("ETH".equals(currency1)) {
		PriceCache.Price price = new PriceCache.Price(currency1, currency2, 
				ethTicker.getDouble("Last"), ethTicker.getDouble("Volume"), time, bittrex);
		pc.getPriceList().add(price);
	} else if ("ETH".equals(currency2)) {
		// if it is "ETH-BTC" instead of "BTC-ETH", we need to recalculate last and volume.
		// not sure how to do this yet
		//double nonBtcLast = ethTicker.getDouble("Last");
		//double btcLast = 0L;// how to calculate this?
		//double nonEthVolume = ethTicker.getDouble("Volume");
		//double ethVolume = nonEthVolume / nonBtcLast; // wait, this might not be correct
		//PriceCache.Price price = new PriceCache.Price(currency1, currency2, 
		//		btcLast, ethVolume, time, bittrex);
		//pc.getPriceList().add(price);
	}
	
}

CacheManager.save("latest_bittrex", pc);
%>
<%=pc%>