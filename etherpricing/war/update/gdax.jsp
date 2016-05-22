<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="updateheader.jspf" %>
<%@ page import="java.util.*" %>
<%@ page import="com.etherpricing.net.*" %>
<%@ page import="com.etherpricing.cache.*" %>
<%@ page import="org.json.*" %>
<%
PriceCache pc = new PriceCache();

// we need to use Urlfetch instead of retrievedata, because gdax api requires user-agent.
// otherwise, gdax api will return {"message": "User-Agent header is required."}
// 
// on development server:
// - urlfetch allows us to add user-agent header on local development server.  
// add user-agent to httpurlconnection does not work at all.  (the user-agent is still not filled)
// 
// on deployed server:
// - using urlfetch or httpurlconnection will both work.  appengine automatically fills user agent with special string.  
// see https://cloud.google.com/appengine/docs/java/outbound-requests#request_headers

// get list of symbols
JSONArray products = Urlfetch.jsonArray("https://api.exchange.coinbase.com/products");
List<String> ethSymbols = new ArrayList<String>(20); // most likely just 2.  not likely to be over 20.

// find symbol that starts with ETH
for (int i=0; i<products.length(); i++) {
	JSONObject product = products.getJSONObject(i);
	String symbol = product.getString("id");
	if (symbol.startsWith("ETH")) {
		ethSymbols.add(symbol);
	}
}

//if symbol contains eth, gets the data
for (String symbol:ethSymbols) {
	String url = "https://api.exchange.coinbase.com/products/{symbol}/ticker";
	url = url.replace("{symbol}", symbol);
	JSONObject json = Urlfetch.jsonData(url);
	final long time = System.currentTimeMillis();
	final String gdax = "GDAX";
	
	// eg. symbol is "ETH-USD"
	String[] currencies = symbol.split("-");
	String currency1 = currencies[0].toUpperCase();
	String currency2 = currencies[1].toUpperCase();
	double last = Double.parseDouble(json.getString("price")); // price is in "string"
	double volume = Double.parseDouble(json.getString("volume")); // volume is in "string"
	
	if (json != null) {		
		PriceCache.Price price = 
			new PriceCache.Price(currency1, currency2, last, volume, time, gdax);
		
		pc.getPriceList().add(price);
	}
}

if (pc.getPriceList().size() > 0) {
	CacheManager.save("latest_gdax", pc);
}
%>
<%=pc%>