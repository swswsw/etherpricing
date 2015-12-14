<?xml version="1.0" encoding="UTF-8" ?>
<%@ page import="java.util.*" %>
<%@ page import="java.util.logging.*" %>
<%
// called every ten min to see what time it calls every hours
long millis = System.currentTimeMillis();
Date date = new Date(millis);
System.out.println(millis);
System.out.println(date);

Logger log = Logger.getLogger(this.getServletName());
log.warning(String.valueOf(millis));
log.info(date.toString());
%>