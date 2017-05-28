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
	JSONObject ticker = json.getJSONObject("ticker");
	result = new PriceCache.Price(currency1, currency2, ticker.getDouble("last"), ticker.getDouble("vol"), time, exchange);
	return result;
}
%>

<%
final String huobi = "Huobi";
PriceCache.Price ethcny = retrieveData("https://api.huobi.com/staticmarket/ticker_eth_json.js", "ETH", "CNY", huobi);
PriceCache.Price ethusd = retrieveData("https://api.huobi.com/usdmarket/ticker_eth_json.js", "ETH", "USD", huobi);
PriceCache pc = new PriceCache();
if (ethcny != null) {
	pc.getPriceList().add(ethcny);
}

if (ethusd != null) {
	pc.getPriceList().add(ethusd);
}

if (pc.getPriceList().size() > 0) {
	CacheManager.save("latest_huobi", pc);
}
%>
<%=pc%>