<%@ include file="/include/new_style/headerPublisher.jspf" %>
<%@ include file="/publisher_traitement/public/include/beanCandidat.jspf" %>
<%@page import="java.util.Calendar"%> 
<%
	String sTitle = "Modula Publisher Portail";
	String sPageUseCaseId = "IHM-PUBLI-1";	
%>
<%@ include file="/publisher_traitement/public/include/redirectOnLoad.jspf" %>
</head>
<script type="text/javascript">
<!--


onPageLoad = function() {
   try{ showLoginBox(); } catch (e) {}
}

//-->
</script>
<body>
<%@ include file="/publisher_traitement/public/include/header.jspf" %>

<jsp:include page="public/include/chooseTextHomePage.jsp" flush="false" />

<%@include file="/publisher_traitement/public/include/footer.jspf"%>
</body>
<%@page import="java.util.Calendar;"%>
</html>