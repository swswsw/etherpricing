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
final String cex = "cex.io";
PriceCache.Price ethbtc = retrieveData("https://cex.io/api/ticker/ETH/BTC", "ETH", "BTC", cex);
PriceCache.Price ethusd = retrieveData("https://cex.io/api/ticker/ETH/USD", "ETH", "USD", cex);
PriceCache pc = new PriceCache();
if (ethbtc != null) {
	pc.getPriceList().add(ethbtc);
}

if (ethusd != null) {
	pc.getPriceList().add(ethusd);
}

if (pc.getPriceList().size() > 0) {
	CacheManager.save("latest_cex", pc);
}
%>
<%=pc%>