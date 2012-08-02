<%@page import="mt.modula.html.HtmlDecachetage"%>
<%@page import="modula.graphic.Icone"%>
<script type="text/javascript">

<%
	HtmlDecachetage htmlDecachetage = (HtmlDecachetage) request.getAttribute("htmlDecachetage");
	boolean bAppletAuthentificationUser = htmlDecachetage.bAuthentificationUser;
	boolean bAppletACValidation = htmlDecachetage.bACValidation;
	String sAppletUserAgent = request.getHeader("User-Agent");

	
%>

function setProxyParam(jsonProxyParam){
    // TODO
}


//-->
</script>
<jsp:include page="/test/javascriptAppletCommon.jsp">
<jsp:param value="<%=bAppletAuthentificationUser %>" name="bAppletAuthentificationUser" />
<jsp:param value="<%=bAppletACValidation %>" name="bAppletACValidation" />
</jsp:include>
