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
	double last = Double.parseDouble(ticker.getString("last"));
	double volume = Double.parseDouble(ticker.getString("vol"));
	result = new PriceCache.Price(currency1, currency2, last, volume, time, exchange);
	return result;
}
%>

<%
final String okcoin = "OKCoin";
PriceCache.Price ethcny = retrieveData("https://www.okcoin.cn/api/v1/ticker.do?symbol=eth_cny", "ETH", "CNY", okcoin);
//PriceCache.Price ethusd = retrieveData("https://www.okcoin.com/api/v1/ticker.do?symbol=eth_usd", "ETH", "USD", okcoin);
PriceCache pc = new PriceCache();
if (ethcny != null) {
	pc.getPriceList().add(ethcny);
}

//if (ethusd != null) {
//	pc.getPriceList().add(ethusd);
//}

if (pc.getPriceList().size() > 0) {
	CacheManager.save("latest_okcoin", pc);
}
%>
<%=pc%>