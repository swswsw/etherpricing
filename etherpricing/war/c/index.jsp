<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@page import="org.json.*"%>
<%@page import="com.etherpricing.cache.CacheManager"%>

<%!

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
//fetch data from cache and display.
String sAverage = CacheManager.getString("latest_average");
JSONObject jsonAverage = new JSONObject(sAverage);
String sBitcoinAverage = CacheManager.getString("");
double last = jsonAverage.getDouble("last");
double btcRate = last;


//get bitcoin to fiat currency rate data
String sBaRates = CacheManager.getString("latest_bitcoinaverage");
JSONObject baRates = null;
if (sBaRates != null) {
	baRates = new JSONObject(sBaRates);
}

double usdRate = findXbtRates("USD", baRates);
double gbpRate = findXbtRates("GBP", baRates);
double eurRate = findXbtRates("EUR", baRates);
double cadRate = findXbtRates("CAD", baRates);
double audRate = findXbtRates("AUD", baRates);
%>

<!DOCTYPE html>
<html>
	<head>
		<title>Ether pricing calculator</title>
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<link rel="stylesheet" type="text/css" href="index.css">
		<link href='http://fonts.googleapis.com/css?family=Dosis:300' rel='stylesheet' type='text/css'>
		

		
	</head>

	<body>
		<div class="containerDiv">
			<div class="bodyHeader">
				<div class="logoDiv" onclick="window.location.href='/'">
					<span>Ξther₱ricing</span>
				</div>
				<div class="titleDiv">
					<span>Calculator</span>
				</div>


			</div>
			
			<div class="bodyValues">
				<!-- 
				<div class="exchangesDiv">
				an average of <br>
				<span class="tickSpan">&#10004;</span> Poloniex
				<span class="tickSpan">&#10004;</span> Kraken
				<span class="tickSpan">&#10004;</span> Bitfinex
				<span class="tickSpan">&#10004;</span> GDAX
				<span class="tickSpan">&#10004;</span> BTC-e
				and more...
				</div>
				-->
				<div class="currDiv">
					<input type="text" class="inputStandard" id="currInput" value="1" onchange="currConvert(this.value)" onkeyup="currConvert(this.value)">
					<input type="text" class="inputGrey" value="ETH" disabled>
				</div>
				<div class="equalsDiv">
					<span class="bodyEquals">=</span>
				</div>
				<div class="fiatDiv">
				    <input type="text" class="inputStandard" id="fiatInput" value="<%=btcRate%>" onchange="fiatConvert(this.value)" onkeyup="fiatConvert(this.value)">
					<select class="selectGrey" id="selectBox" onchange="currConvert(this.value)">
					  <option value="BTC">BTC</option>
					  <option value="USD">USD</option>
					  <option value="GBP">GBP</option>
					  <option value="EUR">EUR</option>
					  <option value="CAD">CAD</option>
					  <option value="AUD">AUD</option>
					</select>
				</div>
			</div>
		</div>
		<script type="text/javascript">
			var varAverage = <%=btcRate%>;
			var usdRate = <%=usdRate%>;
			var gbpRate = <%=gbpRate%>;
			var eurRate = <%=eurRate%>;
			var cadRate = <%=cadRate%>;
			var audRate = <%=audRate%>;
			
			function fiatConvert(Value)
			{
				var fiatAmount = document.getElementById("fiatInput").value;
				var currValue = document.getElementById("currInput");
				if (document.getElementById('selectBox').value=='BTC') {
				var value = fiatAmount / varAverage;
				currValue.value = value.toFixed(8);
				} else if (document.getElementById('selectBox').value=='USD') {
					var value = (fiatAmount / varAverage) / usdRate;
					currValue.value = value.toFixed(8);
				} else if (document.getElementById('selectBox').value=='GBP') {
					var value = (fiatAmount / varAverage) / gbpRate;
					currValue.value = value.toFixed(8);
				} else if (document.getElementById('selectBox').value=='EUR') {
					var value = (fiatAmount / varAverage) / eurRate;
					currValue.value = value.toFixed(8);
				} else if (document.getElementById('selectBox').value=='CAD') {
					var value = (fiatAmount / varAverage) / cadRate;
					currValue.value = value.toFixed(8);
				} else if (document.getElementById('selectBox').value=='AUD') {
					var value = (fiatAmount / varAverage) / audRate;
					currValue.value = value.toFixed(8);
				}
				$('#currInput').autoGrow(30);
		    	$('#fiatInput').autoGrow(30);
			}
		</script>
		<script type="text/javascript">
			function currConvert(Value)
			{
				var amount = document.getElementById("currInput").value;
				var fiatValue = document.getElementById("fiatInput");
				var value = amount * varAverage;
				if (document.getElementById('selectBox').value=='BTC') {
					var value = amount * varAverage;
					fiatValue.value = value.toFixed(8);
				} else if (document.getElementById('selectBox').value=='USD') {
					var value = (amount * varAverage) * usdRate;
					fiatValue.value = value.toFixed(4);
				} else if (document.getElementById('selectBox').value=='GBP') {
					var value = (amount * varAverage) * gbpRate;
					fiatValue.value = value.toFixed(4);
				} else if (document.getElementById('selectBox').value=='EUR') {
					var value = (amount * varAverage) * eurRate;
					fiatValue.value = value.toFixed(4);
				} else if (document.getElementById('selectBox').value=='CAD') {
					var value = (amount * varAverage) * cadRate;
					fiatValue.value = value.toFixed(4);
				} else if (document.getElementById('selectBox').value=='AUD') {
					var value = (amount * varAverage) * audRate;
					fiatValue.value = value.toFixed(4);
				}
				
				$('#currInput').autoGrow(30);
		    	$('#fiatInput').autoGrow(30);
			}
		</script>
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
		<script src="/js/jquery-autogrow.min.js"></script>
		<script type="text/javascript">
		    $('#currInput').autoGrow(30);
		    $('#fiatInput').autoGrow(30);
		</script>
	
	<script>
	  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
	  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
	  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
	  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');
	
	  ga('create', 'UA-73381669-1', 'auto');
	  ga('send', 'pageview');
	
	</script>
	
	</body>

</html>