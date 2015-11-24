<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.etherpricing.net.*" %>
<%@ page import="org.json.*" %>
<%
JSONObject json = RetrieveData.jsonData("https://poloniex.com/public?command=returnTicker");
JSONObject btceth = null;
JSONObject usdteth = null;
if (json != null) {
	btceth = json.getJSONObject("BTC_ETH");
	usdteth = json.getJSONObject("USDT_ETH");
}
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>get data from poloniex</title>
</head>
<body>
<pre>
btc_eth: 
<%=btceth.toString(2)%>

usdt_eth:
<%=usdteth.toString(2)%>
</pre>


</body>
</html>