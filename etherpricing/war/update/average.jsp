<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@include file="updateheader.jspf" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@ page import="com.etherpricing.objectify.ObjectifyManager"%>
<%@ page import="com.etherpricing.net.*" %>
<%@ page import="com.etherpricing.cache.*" %>
<%@ page import="com.etherpricing.model.*" %>
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
 * find xbt's price in another currency using the given bitcoinaverage rates object
 * @return 1xbt=this much currency.  eg. currencySymbol=USD, return 500.  which means 1xbt=500USD
 */
private double findXbtRates(String currencySymbol, JSONObject bitcoinaverageRates) 
	throws JSONException {
	JSONObject rate = bitcoinaverageRates.getJSONObject(currencySymbol);
	return rate.getDouble("last");
}
%>
<%
// calculate weighted average.
// calculate average by averaging the prices and volumes from each exchanges 
// in the cache.

long currentTimeMillis = System.currentTimeMillis();


//get bitcoin to fiat currency rate data
String sBaRates = CacheManager.getString("latest_bitcoinaverage");
JSONObject baRates = null;
if (sBaRates != null) {
	baRates = new JSONObject(sBaRates);
}

// get fiat exchange rate data (not used right now. to remove)
String sFiatRates = CacheManager.getString("latest_openexchangerates");
JSONObject fiatRates = null;
if (sFiatRates != null) {
	fiatRates = new JSONObject(sFiatRates);
}

double totalVolume = 0.0D;
double totalSoFar = 0.0D;

//retrieve price/volume from each cache
String[] exchanges = {
		"latest_bitfinex",
		"latest_poloniex",
		"latest_gatecoin",
		"latest_kraken",
		"latest_yunbi",
		"latest_bittrex",
		//"latest_livecoin",
		"latest_quadrigacx",
		"latest_cex",
		"latest_yobit",
		"latest_btce",
		"latest_gemini",
		"latest_bitso",
		"latest_gdax",
		//"latest_okcoin",
};


// iterate through all prices to calculate weighted average
List<PriceCache> priceCaches = new ArrayList<PriceCache>(100); // probably less than 100 exchanges to read.
ArrayList<PriceCache.Price> allPrices = new ArrayList<PriceCache.Price>(200); // probably don't have more than 200 prices to calculate

for (String exchange:exchanges) {
	PriceCache pc = CacheManager.getPriceCache(exchange);
	priceCaches.add(pc);
	if (pc != null) { allPrices.addAll(pc.getPriceList()); }
}

// iterate all price to find the weighted average
// we will calculate the final average in xbt as most of the volume is in xbt right now. 
// then translating to usd to display.  since most of the people in the beginning would want to see usd price.
for (int i=0; i<allPrices.size(); i++) {
	PriceCache.Price price = allPrices.get(i);
	
	double last = 0.0D;
	double volume = 0.0D;
	// convert non-xbt price to xbt
	if ("BTC".equals(price.getCurrency2()) || "XBT".equals(price.getCurrency2())) {
		last = price.getLast();
		volume = price.getVolume();
	} else {
		double xbtInCurrency2 = 0.0D;
		try {
			String currency2 = price.getCurrency2();
			// use usd rate for usdt
			if ("USDT".equals(currency2)) {
				xbtInCurrency2 = findXbtRates("USD", baRates);
			} else {
				xbtInCurrency2 = findXbtRates(currency2, baRates);
			}			
		} catch (JSONException ex) {
			// conversion rate for currency2 is not found on bitcoinaverage.
		}
		
		if (xbtInCurrency2 != 0.0D) {
			last = price.getLast() / xbtInCurrency2;
			volume = price.getVolume();
		} // if we cannot find the conversion rate, then we don't invlude this price in calcuation.
		
		// eg. currency2 = "USD".  
		// from bitcoinaverage, we can find that xbtInCurrency2 = 1000.00.  that is 1 xbt = 1000 usd
		// price.getLast() is eth's price in usd.
		// so to get last in xbt,   last = price.getLast() / xbtInCurrency2
	}
	
	totalSoFar += (last * volume);
	totalVolume += volume;
}

// avoid divide by 0 problem.  check if denominator is 0.
double average = (totalVolume != 0.0D) ? (totalSoFar / totalVolume) : 0.0D;
double rateUsd = findXbtRates("USD", baRates);
double lastUsd = average * rateUsd;
JSONObject jsonAvg = new JSONObject();
jsonAvg.put("last", average);
jsonAvg.put("volume", totalVolume);
jsonAvg.put("sum", totalSoFar);
jsonAvg.put("lastUsd", lastUsd);
jsonAvg.put("time", currentTimeMillis);

CacheManager.save("latest_average", jsonAvg.toString());
CacheManager.save("price_list", allPrices);

long wholeTime = Minute.calcWholeTime(currentTimeMillis);

Minute minute = new Minute();
minute.id = wholeTime;
minute.average = average;
minute.volume = totalVolume;
minute.sum = totalSoFar;
minute.timeslot = new Date(wholeTime);
minute.timestamp = currentTimeMillis;
minute.avgUsd = lastUsd;
minute.sumUsd = lastUsd * totalVolume;
ObjectifyManager.save(minute);

// not used
if (fiatRates != null) {
	// calculate average and total volume.
	//try {
	//	findRates(currency, fiatRates);
	//} catch (JSONException ex) {
	//	System.out.println("cannot find fiat rates for currency " + currencySymbol);
	//}
}



// load attribute variables for jstl
request.setAttribute("priceCaches", priceCaches);
%>

<c:forEach items="${priceCaches}" var="pc">
   ${pc}
   <hr/>
</c:forEach>

 
<%=(baRates != null) ? baRates.toString(2) : null%>
<hr/>
<%=(fiatRates != null) ? fiatRates.toString(2) : null%>
<hr/>
<%=average%>