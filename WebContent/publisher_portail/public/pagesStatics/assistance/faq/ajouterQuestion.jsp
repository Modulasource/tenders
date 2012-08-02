<%@ include file="/include/new_style/headerPublisher.jspf" %>

<%@page import="modula.graphic.Icone"%>
<%@page import="modula.faq.FAQ"%>
<%@ include file="/publisher_traitement/public/include/beanCandidat.jspf" %>
<%
	String sTitle = "FAQ - Foire Aux Questions";
    String sPageUseCaseId = "IHM-PUBLI-3";  
%>
<%@ include file="/publisher_traitement/public/include/redirectOnLoad.jspf" %>

</head>
<body>
<%@ include file="/publisher_traitement/public/include/header.jspf" %>
<%

	String sQuestion="";
	int idType;
	try{
		sQuestion = request.getParameter("question"); 
		FAQ faq = new FAQ();
		faq.setQuestion(sQuestion);
		faq.create();
		String sMessTitle = "";
		String sMess = "Votre question a bien été prise en compte. L'administrateur y répondra dans les meilleurs délais.<br />Merci.";
		String sUrlIcone = Icone.ICONE_SUCCES;	
%>
	<%@ include file="/include/message.jspf" %>
	<div style="text-align:center"><a href="faq.jsp">Retour à la Foire aux Questions</a></div>
<%
	}
	catch (Exception e) {
		out.println("pas de question");	
		return;
	}
%>                
<%@include file="/publisher_traitement/public/include/footer.jspf"%>
</body>
</html>