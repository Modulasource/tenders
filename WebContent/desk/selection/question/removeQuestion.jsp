<%@ include file="../../../include/headerXML.jspf" %>

<%@page import="org.coin.bean.question.Question"%>
<%@page import="org.coin.bean.question.Answer"%>
<%@ page import="java.util.*" %>
<%@ include file="../../include/beanSessionUser.jspf" %>
<%
String sTitle = "Suppression de la question ";
String rootPath = request.getContextPath()+"/";


int iIdQuestion = -1;
try{iIdQuestion = Integer.parseInt(request.getParameter("lIdQuestion"));}
catch (Exception e)	{}

String sPageUseCaseId = "IHM-DESK-SELECTION-QR-004";

%>
<%@ include file="../../include/checkHabilitationPage.jspf" %>
<%@ include file="../../include/headerDesk.jspf" %>
</head>
<body>
<div class="titre_page"><%= sTitle %></div>
<%
String sMessTitle = "Succès !";
String sMess = "La suppression a bien été effectuée.";
String sUrlIcone = modula.graphic.Icone.ICONE_SUCCES;
Question.removeWithObjectAttached(iIdQuestion);
%>
<%@ include file="../../../include/message.jspf" %>
<div><input type="button" name="retour" value="Retour à la liste" 
	onClick="Redirect('<%=response.encodeRedirectURL(rootPath + "desk/selection/question/displayAllQuestion.jsp") %>')" />
</div>
<%@ include file="../../include/footerDesk.jspf" %>
</body>
</html>