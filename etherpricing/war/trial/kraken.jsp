<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.etherpricing.net.*" %>
<%@ page import="org.json.*" %>
<%
JSONObject json = RetrieveData.jsonData("https://api.kraken.com/0/public/Ticker?pair=ETHXBT,ETHUSD,ETHEUR,ETHCAD,ETHGBP,ETHJPY");

String result = "";
if (json != null) {
	result = json.toString(2);
}

%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>get data from kraken</title>
</head>
<body>
<pre>
<%=result%>
</pre>


</body>
</html>