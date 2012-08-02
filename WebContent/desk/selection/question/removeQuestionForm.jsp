<%@ include file="../../../include/headerXML.jspf" %>

<%@page import="org.coin.bean.question.Question"%>
<%@page import="org.coin.bean.question.Answer"%>
<%@ page import="java.util.*,
			org.coin.fr.bean.*" %>
<%@ include file="../../include/beanSessionUser.jspf" %>
<%
String sTitle = "Suppression de la question ";
String rootPath = request.getContextPath()+"/";

PersonnePhysique personne = PersonnePhysique.getPersonnePhysique(sessionUser.getIdIndividual());

int iIdQuestion = -1;
try{iIdQuestion = Integer.parseInt(request.getParameter("lIdQuestion"));}
catch (Exception e)	{}
Question _question = Question.getQuestionMemory(iIdQuestion);

String sPageUseCaseId = "IHM-DESK-SELECTION-QR-004";

%>
<%@ include file="../../include/checkHabilitationPage.jspf" %>
<%@ include file="../../include/headerDesk.jspf" %>
</head>
<body>
<div class="titre_page"><%= sTitle %></div>
<form name="formulaire" method="post" action="<%=response.encodeURL("removeQuestion.jsp")%>" >
	<input type="hidden" name="lIdQuestion" value="<%= iIdQuestion %>" />
<%
String sMessTitle = "Attention !";
String sMess = "Vous allez supprimer une question.";
sMess += "\nContinuez ?";
String sUrlIcone = modula.graphic.Icone.ICONE_WARNING;	
%>
<%@ include file="../../../include/message.jspf" %>
	<div>
		<input type="submit" name="submit" value="Supprimer" />&nbsp;
		<input type="reset" name="RAZ" value="Annuler" 
		onClick="Redirect('<%=response.encodeRedirectURL(
				rootPath + "desk/selection/question/displayQuestion.jsp?lIdQuestion="+iIdQuestion) %>')" />
	</div>
</form>
<%@ include file="../../include/footerDesk.jspf" %>
</body>
<%@page import="org.coin.bean.question.QuestionAnswer"%>
</html>