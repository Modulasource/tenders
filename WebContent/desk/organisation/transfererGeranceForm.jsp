<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.db.*,org.coin.bean.html.*,java.util.*,org.coin.fr.bean.*" %>
<%
	String sTitle = "Transférer la gérance de l'organisation ";

	Organisation organisation = null;
	PersonnePhysique gerant = null;
	int iIdOrganisation = -1;
	iIdOrganisation = Integer.parseInt(request.getParameter("iIdOrganisation"));
	organisation = Organisation.getOrganisation( iIdOrganisation);
	gerant = PersonnePhysique.getPersonnePhysique(organisation.getIdCreateur());
	sTitle += organisation.getRaisonSociale();
	
	HtmlBeanTableTrPave hbFormulaire = new HtmlBeanTableTrPave();
	hbFormulaire.bIsForm = false;
%>
</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<br/>
<div style="padding:15px">
<form action="<%=response.encodeRedirectURL("transfererGerance.jsp")%>" method="post" name="formulaire">
<input type="hidden" name="iIdOrganisation" value="<%=organisation.getIdOrganisation()%>" />
	<table class="pave" >
		<tr>
			<td class="pave_titre_gauche" colspan="2">G&eacute;rant actuel :</td>
		</tr>
		<%= hbFormulaire.getHtmlTrInput("Membre :","",gerant.getCivilitePrenomNom()) %>
	</table>
	<br />
	<% hbFormulaire.bIsForm = true; %>
	<table class="pave" >
		<tr>
			<td class="pave_titre_gauche" colspan="2">Nouveau g&eacute;rant</td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche">Transférer la gérance au membre :</td>
			<td class="pave_cellule_droite">
			<% Vector vPersonnes = PersonnePhysique.getAllFromIdOrganisation(organisation.getIdOrganisation()); %>
			<%= CoinDatabaseAbstractBeanHtmlUtil.getHtmlSelect("choixMembre",1,(Vector<CoinDatabaseAbstractBean>)vPersonnes,gerant.getId()) %>
			</td>
		</tr>
	</table>
	<br />
	<div style="text-align:center">
		<button type="submit" name="submit">Transférer la gérance</button>&nbsp;
		<button type="reset" 
			name="RAZ" 
			onclick="Redirect('<%=response.encodeRedirectURL("afficherOrganisation.jsp?iIdOrganisation="
					+organisation.getIdOrganisation())%>')" >Annuler</button>
	</div>
</form>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
</html>

