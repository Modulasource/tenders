<%@ include file="../../../include/headerXML.jspf" %>

<%@ page import="org.coin.fr.bean.*" %>
<%@page import="org.coin.bean.question.Answer"%>
<%@ include file="../../include/beanSessionUser.jspf" %>
<%
String sTitle = "Suppression de la question ";
String rootPath = request.getContextPath()+"/";

int iIdReponse = -1;
try{iIdReponse = Integer.parseInt(request.getParameter("lIdAnswer"));}
catch (Exception e)	{}
Answer _reponse = Answer.getAnswer(iIdReponse);

String sPageUseCaseId = "IHM-DESK-SELECTION-QR-004";
%>
<%@ include file="../../include/checkHabilitationPage.jspf" %>
<%@ include file="../../include/headerDesk.jspf" %>
</head>
<body>
<div class="titre_page"><%= sTitle %></div>
<form name="formulaire" method="post" action="<%=response.encodeURL("removeAnswer.jsp")%>" >
	<input type="hidden" name="lIdAnswer" value="<%= iIdReponse %>" />
<%
	String sMessTitle = "Attention !";
	String sMess = "Vous allez supprimer une réponse.";
	sMess += "\nContinuez ?";
	String sUrlIcone = modula.graphic.Icone.ICONE_WARNING;	
%>
<%@ include file="../../../include/message.jspf" %>
	<div>
		<input type="submit" name="submit" value="Supprimer" />
		&nbsp;<input type="reset" name="RAZ" value="Annuler" 
		onClick="Redirect('<%=response.encodeRedirectURL(rootPath 
				+ "desk/selection/answer/displayAnswer.jsp?lIdAnswer="+iIdReponse) %>')" />
	</div>
</form>
<%@ include file="../../include/footerDesk.jspf" %>
</body>
</html>