<%@ include file="../../../include/headerXML.jspf" %>

<%@ page import="org.coin.fr.bean.*" %>
<%@page import="org.coin.bean.question.Answer"%>
<%@ include file="../../include/beanSessionUser.jspf" %>
<%
String sTitle = "Suppression du groupe ";
String rootPath = request.getContextPath()+"/";

int iIdAnswerGroup = -1;
try{iIdAnswerGroup = Integer.parseInt(request.getParameter("iIdAnswerGroup"));}
catch (Exception e)	{}

String sPageUseCaseId = "IHM-DESK-SELECTION-QR-004";
%>
<%@ include file="../../include/checkHabilitationPage.jspf" %>
<%@ include file="../../include/headerDesk.jspf" %>
</head>
<body>
<div class="titre_page"><%= sTitle %></div>
<form name="formulaire" method="post" action="<%=response.encodeURL("removeAnswerGroup.jsp")%>" >
	<input type="hidden" name="iIdAnswerGroup" value="<%= iIdAnswerGroup %>" />
<%
	String sMessTitle = "Attention !";
	String sMess = "Vous allez supprimer un groupe.";
	sMess += "\nContinuez ?";
	String sUrlIcone = modula.graphic.Icone.ICONE_WARNING;	
%>
<%@ include file="../../../include/message.jspf" %>
	<div>
		<input type="submit" name="submit" value="Supprimer" />
		&nbsp;<input type="reset" name="RAZ" value="Annuler" 
		onClick="Redirect('<%=response.encodeRedirectURL(rootPath 
				+ "desk/selection/answer_group/displayAnswerGroup.jsp?iIdAnswerGroup="+iIdAnswerGroup) %>')" />
	</div>
</form>
<%@ include file="../../include/footerDesk.jspf" %>
</body>
</html>