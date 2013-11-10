<%@taglib prefix="layout" tagdir="/WEB-INF/tags/layout" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%--
  User: guym
  Date: 3/5/13
  Time: 10:40 AM
--%>
<%@tag description="Overall Page template" pageEncoding="UTF-8"%>
<%@attribute name="body" fragment="true" %>
<%@attribute name="header" fragment="true" %>

<layout:scaffold>
    <jsp:attribute name="body">
        <jsp:invoke fragment="body"/>
    </jsp:attribute>

    <jsp:attribute name="header">
        <title><spring:message code="product.name"/> - Login </title>
        <link rel="stylesheet" href="/stylesheets/login.css">
        <script type="text/javascript" src="/public/javascripts/jquery/jquery-1.8.1.min.js"></script>
        <jsp:invoke fragment="header"/>
    </jsp:attribute>

</layout:scaffold>

