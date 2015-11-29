<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@ page import="com.etherpricing.net.*" %>
<%@ page import="com.etherpricing.cache.*" %>
<%@ page import="org.json.*" %>
<%!
/**
 * return the fiat rates given the currency symbol
 */
private double findRates(String currencySymbol, JSONObject fiatRates)
	throws JSONException {
	JSONObject rates = fiatRates.getJSONObject("rates");
	return rates.getDouble(currencySymbol);
}

/**
 *
 */
//private double findXbtRates(String currencySymbol, )
%>
<%
// calculate weighted average.
// calculate average by averaging the prices and volumes from each exchanges 
// in the cache.

// retrieve price/volume from each cache
// find average
PriceCache pcPoloniex = CacheManager.getPriceCache("latest_poloniex");
PriceCache pcGatecoin = CacheManager.getPriceCache("latest_gatecoin");
PriceCache pcKraken = CacheManager.getPriceCache("latest_kraken");

//get bitcoin to usd rate data
PriceCache pcBitcoinaverage = CacheManager.getPriceCache("latest_bitcoinaverage");
double btcusd = -1D;
if (pcBitcoinaverage != null) {
	if (pcBitcoinaverage.getPriceList().size() > 0) {
		PriceCache.Price btcusdPrice = pcBitcoinaverage.getPriceList().get(0);
		btcusd = btcusdPrice.getLast();
	}
}

// get fiat exchange rate data (may not be used right now)
String sFiatRates = CacheManager.getString("latest_openexchangerates");
JSONObject fiatRates = null;
if (sFiatRates != null) {
	fiatRates = new JSONObject(sFiatRates);
}

double totalVolume = 0.0D;
double totalSoFar = 0.0D;

// iterate through all prices to calculate weighted average
List<PriceCache.Price> allPrices = new ArrayList<PriceCache.Price>(50); // probably don't have more than 50 prices to calculate
if (pcPoloniex != null) { allPrices.addAll(pcPoloniex.getPriceList()); }
if (pcGatecoin != null) { allPrices.addAll(pcGatecoin.getPriceList()); }
if (pcKraken != null) { allPrices.addAll(pcKraken.getPriceList()); }

// iterate all price to find the weighted average
// we will calculate the final average in xbt as most of the volume is in xbt right now. 
// then translating to usd to display.  since most of the people in the beginning would want to see usd price.
for (int i=0; i<allPrices.size(); i++) {
	PriceCache.Price price = allPrices.get(i);
	totalVolume += price.getVolume();
	totalSoFar += (price.getLast() * price.getVolume());
	// convert non-xbt price to xbt
	
}

// avoid divide by 0 problem.  check if denominator is 0.
double average = (totalVolume != 0.0D) ? (totalSoFar / totalVolume) : 0.0D;

if (fiatRates != null) {
	// calculate average and total volume.
	//try {
	//	findRates(currency, fiatRates);
	//} catch (JSONException ex) {
	//	System.out.println("cannot find fiat rates for currency " + currencySymbol);
	//}
}




%>

<%=pcPoloniex%>
<hr/>
<%=pcGatecoin%>
<hr/>
<%=pcKraken%>
<hr/>
<%=pcBitcoinaverage%>
<hr/>
<%=(fiatRates != null) ? fiatRates.toString(2) : ""%>
<h4/>
<%=average%>