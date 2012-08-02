<%@ include file="../../../../../include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.fr.bean.*,java.util.*" %>
<%
	int iIdMailing = Integer.parseInt( request.getParameter("iIdMailing") );
	String sTitle = "Sélectionner une organisation";
	Vector<Organisation> vOrganisations	= Organisation.getAllOrganisations();
	String sAction = request.getParameter("sAction") ;
%>
<script src="<%= rootPath %>include/redirection.js" type="text/javascript"></script>
<script src="<%= rootPath %>include/popup.js" type="text/javascript"></script>
</head>
<body>
<%@ include file="../../../../../include/new_style/headerFichePopUp.jspf" %>
<br/>
<div style="padding:15px">
<table class="pave" summary="none">
	<tr>
		<td >&nbsp;</td>
	</tr>
	<%
	for(int j= 0; j < vOrganisations.size() ; j++)
	{
		Organisation organisation = vOrganisations.get(j);
	 %>
	<tr>
		<td width="50%" style="text-align:left"  ><a href="javascript:Redirect('<%= 
			response.encodeURL("modifierDestinatairesFromOrganisationForm.jsp?iIdMailing="
			 	+ iIdMailing + "&amp;iIdOrganisation=" + organisation.getIdOrganisation() ) 
			%>')" ><%= organisation.getRaisonSociale() %></a></td>
		<td width="30%" style="text-align:left" ><%= organisation.getMailOrganisation() %></td>
		<td width="60%" >&nbsp;</td>
	</tr>
	<%
	}
	 %>
</table>
</div>
<%@ include file="../../../../../include/new_style/footerFiche.jspf" %>
</body>
</html>