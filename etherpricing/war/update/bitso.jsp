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
	double last = Double.parseDouble(json.getString("last"));
	double volume = Double.parseDouble(json.getString("volume"));
	result = new PriceCache.Price(currency1, currency2, last, volume, time, exchange);
	return result;
}
%>

<%
final String bitso = "Bitso";
PriceCache.Price ethmxn = retrieveData("https://bitso.com/api/v2/ticker?book=eth_mxn", "ETH", "MXN", bitso);
PriceCache pc = new PriceCache();

if (ethmxn != null) {
	pc.getPriceList().add(ethmxn);
}

if (pc.getPriceList().size() > 0) {
	CacheManager.save("latest_bitso", pc);
}
%>
<%=pc%>