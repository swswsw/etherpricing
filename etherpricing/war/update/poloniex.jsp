<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.etherpricing.net.*" %>
<%@ page import="com.etherpricing.cache.*" %>
<%@ page import="org.json.*" %>
<%
JSONObject json = RetrieveData.jsonData("https://poloniex.com/public?command=returnTicker");
PriceCache pc = new PriceCache();
JSONObject value = new JSONObject();
if (json != null) {
	JSONObject btceth = json.getJSONObject("BTC_ETH");
	JSONObject usdteth = json.getJSONObject("USDT_ETH");
	
	// we want quoteVolume as the unit is in eth
	PriceCache.Price btcethPrice = 
		new PriceCache.Price("BTC", "ETH", btceth.getDouble("last"), btceth.getDouble("quoteVolume"));
	
	PriceCache.Price usdtethPrice = 
			new PriceCache.Price("USDT", "ETH", usdteth.getDouble("last"), usdteth.getDouble("quoteVolume"));
	
	pc.getPriceList().add(btcethPrice);
	pc.getPriceList().add(usdtethPrice);
	
	value.put("BTC_ETH", btceth);
	value.put("USDT_ETH", usdteth);
	
	CacheManager.save("latest_poloniex", pc);
}
%>
<%=value.toString(2)%>