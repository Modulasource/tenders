<%@ include file="../../../include/headerXML.jspf" %>

<%@ page import="org.coin.fr.bean.mail.*,modula.*,java.util.*, modula.journal.*, org.coin.bean.*"%>
<%@ include file="../../include/beanSessionUser.jspf" %>
<%
	String sAction = request.getParameter("sAction");
	String sTitle = "";
	int iIdMailType = -1;
	if (request.getParameter("iIdMailType") != null) {
		iIdMailType = Integer.parseInt(request.getParameter("iIdMailType"));
	} else {
		iIdMailType = -1;
	}
	MailType oMailType = null;
	
	if (sAction.equals("create")) {
		sTitle = "Ajouter un mail type";
		oMailType = new MailType();
	}
	if (sAction.equals("store")) {
		sTitle = "Modifier un mail type";
		oMailType = MailType.getMailTypeMemory(iIdMailType);
	}
	String rootPath = request.getContextPath()+"/";
	String sSelected="";
	String sPageUseCaseId = "IHM-DESK-xxx";
%>
<%@ include file="../../include/checkHabilitationPage.jspf" %>
<%@ include file="../../include/headerDesk.jspf" %>
</head>
<body>
<div class="titre_page"><%= sTitle %></div>
<form action="<%= response.encodeURL("modifierMailType.jsp?sAction=" + sAction + "&amp;iIdMailType=" + iIdMailType) %>" method="post" name="formulaire" >
<% String sFormPrefix = ""; %>
<%@ include file="pave/paveMailTypeForm.jspf" %>

	<br />
	<div style="text-align:center">
		<%
		String sSubmitValue = "Ajouter";
		if(sAction.equals("store"))
		{
			sSubmitValue = "Modifier";
		}
		
		%>
		<input type="submit" value="<%= sSubmitValue %>"  />
		<input type="button" value="Annuler" 
			onclick="Redirect('<%= response.encodeURL("afficherTousMailType.jsp") %>')" />
		
	</div> 
</form>
<%@ include file="../../include/footerDesk.jspf"%>
</body>
</html>