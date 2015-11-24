<%@page import="java.net.SocketTimeoutException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@ page import="com.etherpricing.net.*" %>
<%@ page import="org.json.*" %>
<%
JSONObject json = null;
try {
	json = RetrieveData.jsonData("https://www.gatecoin.com/api/Public/LiveTickers");
} catch (SocketTimeoutException ex) {
	// sometimes, timeout can occur
	throw ex;
}

List<JSONObject> ethTickers = new ArrayList<JSONObject>(5);
if (json != null) {
	JSONArray tickers = json.getJSONArray("tickers");
	if (tickers != null) {
		int length = tickers.length();
		for (int i=0; i<length; i++) {
			JSONObject ticker = tickers.getJSONObject(i);
			String currencyPair = ticker.getString("currencyPair");
			if (currencyPair != null) {
				if (currencyPair.startsWith("ETH") || currencyPair.endsWith("ETH")) {
					ethTickers.add(ticker);
				}
			}
		}
	}
}
%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>get data from gatecoin</title>
</head>
<body>

<% 
int size = ethTickers.size();
for (int i=0; i<size; i++) { 
	JSONObject ethTicker = ethTickers.get(i);
%>
<pre>
<%=ethTicker.toString(2)%>
</pre>
<% 
}
%>


</body>
</html>