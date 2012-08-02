<%@ include file="../../../include/headerXML.jspf" %>

<%@ page import="org.coin.fr.bean.mail.*,modula.*,java.util.*, modula.journal.*, org.coin.bean.*"%>
<%@ include file="../../include/beanSessionUser.jspf" %>
<%
	String sAction = request.getParameter("sAction");
	String sTitle = "";
	int iIdMailType = -1;
	if (request.getParameter("iIdMailType") != null) {
		iIdMailType  = Integer.parseInt(request.getParameter("iIdMailType"));
	} else {
		iIdMailType  = -1;
	}
	MailType oMailType = null;
	
	sTitle = "Type d'évenement";
	oMailType = MailType.getMailTypeMemory(iIdMailType );
	
	String rootPath = request.getContextPath()+"/";
	String sSelected="";
	String sPageUseCaseId = "IHM-DESK-xxx";
%>
<%@ include file="../../include/checkHabilitationPage.jspf" %>
<%@ include file="../../include/headerDesk.jspf" %>
<script type="text/javascript">

function removeMailType()
{
	if( !confirm("Voulez-vous vraiment supprimer ce mail type ?") ) 
	{
		return;
	}
	Redirect('<%=
		response.encodeRedirectURL(
				"modifierMailType.jsp?sAction=remove&iIdMailType=" + iIdMailType  ) %>');
}
</script>
</head>
<body>
<div class="titre_page"><%= sTitle %></div>
<form action="<%= response.encodeURL("modifierMailTypeForm.jsp?sAction=store&amp;iIdMailType=" + iIdMailType  )%>" method="post" name="formulaire" >
<% String sFormPrefix = ""; %>
<%@ include file="pave/paveMailType.jspf"%>

	<br />
	<div style="text-align:center">
		<input type="submit" value="Modifier" />
		<input type="button" value="Retour" 
			onclick="Redirect('<%= response.encodeURL("afficherTousMailType.jsp") %>')" />
<%
	if(sessionUserHabilitation.isSuperUser())
	{
%>
		<input type="button" value="Supprimer" 
			onclick="javascript:removeMailType()"/> Fonction Super Admin
<%
	}
%>	
		
	</div> 
</form>
<%@ include file="../../include/footerDesk.jspf"%>
</body>
</html>