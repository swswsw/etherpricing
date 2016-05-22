<%@ page trimDirectiveWhitespaces="true" %>
<%@ page import="java.util.*" %>
<%@ page import="org.json.*" %>
<%
JSONObject result = new JSONObject();
Enumeration eNames = request.getHeaderNames();
while (eNames.hasMoreElements()) {
   String name = (String) eNames.nextElement();
   String value = request.getHeader(name);
   result.put(name, value);
}
%>
<%=result.toString(2)%>