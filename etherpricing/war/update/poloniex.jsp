<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.etherpricing.net.*" %>
<%@ page import="com.etherpricing.cache.*" %>
<%@ page import="org.json.*" %>
<%
JSONObject json = RetrieveData.jsonData("https://poloniex.com/public?command=returnTicker");
PriceCache pc = new PriceCache();
if (json != null) {
	JSONObject btceth = json.getJSONObject("BTC_ETH");
	JSONObject usdteth = json.getJSONObject("USDT_ETH");
	
	// weird, currency pair means first currency = this much second currency.  
	// eg. eth_btc price of 0.0020 means  1 eth = 0.0020 btc
	// but poloniex seems to flip the price (flip around first and second currency)
	// we want to normalize the notation, so we will flip first and second currency.
	
	// we want quoteVolume as the unit is in eth
	PriceCache.Price btcethPrice = 
		new PriceCache.Price("ETH", "BTC", btceth.getDouble("last"), btceth.getDouble("quoteVolume"));
	
	PriceCache.Price usdtethPrice = 
			new PriceCache.Price("ETH", "USD", usdteth.getDouble("last"), usdteth.getDouble("quoteVolume"));
	
	pc.getPriceList().add(btcethPrice);
	pc.getPriceList().add(usdtethPrice);
	
	CacheManager.save("latest_poloniex", pc);
}
%>
<%=pc%>