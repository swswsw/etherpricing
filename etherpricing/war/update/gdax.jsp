<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="updateheader.jspf" %>
<%@ page import="java.util.*" %>
<%@ page import="com.etherpricing.net.*" %>
<%@ page import="com.etherpricing.cache.*" %>
<%@ page import="org.json.*" %>
<%
PriceCache pc = new PriceCache();

// get list of symbols
JSONArray symbols = RetrieveData.jsonArray("https://api.bitfinex.com/v1/symbols");
List<String> ethSymbols = new ArrayList<String>(20); // most likely just 2.  not likely to be over 20.

// find symbol that starts with ETH
for (int i=0; i<symbols.length(); i++) {
	String symbol = symbols.getString(i);
	if (symbol.startsWith("eth")) {
		ethSymbols.add(symbol);
	}
}

//if symbol contains eth, gets the data
for (String symbol:ethSymbols) {
	JSONObject json = RetrieveData.jsonData("https://api.bitfinex.com/v1/pubticker/" + symbol);
	final long time = System.currentTimeMillis();
	final String bitfinex = "Bitfinex";
	
	// eg. symbol is "ethusd"
	String currency1 = symbol.substring(0, 3).toUpperCase(); // take first 3 characters
	String currency2 = symbol.substring(3).toUpperCase(); // take last 3 characters
	double last = Double.parseDouble(json.getString("last_price")); // last_price is in "string"
	double volume = Double.parseDouble(json.getString("volume")); // volume is in "string"
	
	if (json != null) {		
		PriceCache.Price price = 
			new PriceCache.Price(currency1, currency2, last, volume, time, bitfinex);
		
		pc.getPriceList().add(price);
	}
}

if (pc.getPriceList().size() > 0) {
	CacheManager.save("latest_bitfinex", pc);
}
%>
<%=pc%>