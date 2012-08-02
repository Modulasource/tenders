<%@ include file="../../../include/headerXML.jspf" %>

<%@ include file="../../include/beanSessionUser.jspf" %>
<%@page import="org.coin.bean.question.Answer"%>
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
<%
AnswerGroup.removeWithObjectAttached(iIdAnswerGroup);

String sMessTitle = "Succès !";
String sMess = "La suppression a bien été effectuée.";
String sUrlIcone = modula.graphic.Icone.ICONE_SUCCES;	
%>
<%@ include file="../../../include/message.jspf" %>
<div><input type="button" name="retour" value="Retour à la liste" 
	onClick="Redirect('<%=response.encodeRedirectURL(
			rootPath + "desk/selection/answer_group/displayAllAnswerGroup.jsp") %>')" />
</div>
<%@ include file="../../include/footerDesk.jspf" %>
</body>
<%@page import="org.coin.bean.question.AnswerGroup"%>
</html>