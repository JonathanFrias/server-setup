<%--
  Created by IntelliJ IDEA.
  User: guym
  Date: 3/5/13
  Time: 10:40 AM
  To change this template use File | Settings | File Templates.
--%>
<%@tag description="Overall Page template" pageEncoding="UTF-8"%>
<%@attribute name="body" fragment="true" %>
<%@attribute name="header" fragment="true" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<html>
<head>
    <jsp:invoke fragment="header"/>
</head>
<body class="<spring:message code="theme.id"/>-theme">
    <!--[if IE]>
		<style>
			html,
			body,
			.centeredOuter {
				height: 100%;
			}
			.centeredOuter {
				text-align: center;
			}
			/*
			 * inner cell elements vertical align:
			 * using Chris Coyier's "Centering in the unknown" hack (http://css-tricks.com/centering-in-the-unknown/)
			 */
			.centeredOuter:before {
				content: '';
				display: inline-block;
				height: 100%;
				vertical-align: middle;
				margin-right: -0.25em;
			}
			.centeredInner {
				display: inline-block;
				vertical-align: middle;
				width: 70%;
			}
		</style>
		</span>
		<div class="centeredOuter">
			<p class="centeredInner" style="font-size: 1.8em;">
			Internet Explorer is currently not supported, Please use
			<a href="http://www.google.com/chrome">Chrome</a> or
			<a href="http://www.mozilla.org/en-US/firefox/new/">Firefox</a> to run the Management Console.
			</p>
		</div>
	<![endif]-->
    <!--[if !IE]> -->
        <jsp:invoke fragment="body"/>
    <!-- <![endif]-->

</body>
</html>