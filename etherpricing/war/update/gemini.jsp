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
JSONArray symbols = RetrieveData.jsonArray("https://api.gemini.com/v1/symbols");
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
	JSONObject json = RetrieveData.jsonData("https://api.gemini.com/v1/pubticker/" + symbol);
	final long time = System.currentTimeMillis();
	final String gemini = "Gemini";
	
	// eg. symbol is "ethusd"
	String currency1 = symbol.substring(0, 3).toUpperCase(); // take first 3 characters
	String currency2 = symbol.substring(3).toUpperCase(); // take the remaining characters
	double last = Double.parseDouble(json.getString("last")); // last_price is in "string" 
	double volume = json.getJSONObject("volume").getDouble(currency1); // currency is in uppercase, note their inconsistency in lower and upper case.  volume is NOT in "string"
	
	if (json != null) {		
		PriceCache.Price price = 
			new PriceCache.Price(currency1, currency2, last, volume, time, gemini);
		
		pc.getPriceList().add(price);
	}
}

if (pc.getPriceList().size() > 0) {
	CacheManager.save("latest_gemini", pc);
}
%>
<%=pc%>