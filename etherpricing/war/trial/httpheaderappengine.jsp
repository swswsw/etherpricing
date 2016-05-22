<%--
i want to find out what http header appengine will include in 
a http request (urlfetch) that originated inside appengine
--%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ page import="org.json.*" %>
<%@ page import="com.etherpricing.net.*" %>

<%
JSONObject result = RetrieveData.jsonData("http://localhost:8888/trial/httpheadershow.jsp");
JSONObject resultUrlFetch = Urlfetch.jsonData("http://localhost:8888/trial/httpheadershow.jsp");
%>
<%=result.toString(2)%>
<%=resultUrlFetch.toString(2)%>