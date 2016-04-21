<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="updateheader.jspf" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.logging.*" %>
<%@ page import="com.etherpricing.net.*" %>
<%@ page import="com.etherpricing.cache.*" %>
<%@ page import="org.json.*" %>
<%! 
private static final Logger log = Logger.getLogger("cex_jsp");

private static PriceCache.Price retrievePrice(String currency1, String currency2, long time, String exchange) {
	PriceCache.Price price = null;
	try {
		JSONObject json = RetrieveData.jsonData("https://cex.io/api/ticker/" + currency1 + "/" + currency2);
		
		if (json != null) {
			double last = Double.parseDouble(json.getString("last"));
			double volume = Double.parseDouble(json.getString("volume"));
			price = new PriceCache.Price(currency1, currency2, last, volume, time, exchange);
		}
	} catch (IOException ex) {
		log.log(Level.WARNING, ex.getMessage(), ex);
	} catch (HttpResponseCodeException ex) {
		log.log(Level.WARNING, ex.getMessage(), ex);
	}
	
	return price;	
}
%>
<%


final long time = System.currentTimeMillis();
final String cex = "cex.io"; 
PriceCache pc = new PriceCache();

PriceCache.Price ethbtc = retrievePrice("ETH", "BTC", time, cex);
PriceCache.Price ethusd = retrievePrice("ETH", "USD", time, cex);

if (ethbtc != null) { pc.getPriceList().add(ethbtc); }
if (ethusd != null) { pc.getPriceList().add(ethusd); }

CacheManager.save("latest_cex", pc);
%>
<%=pc%>