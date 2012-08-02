<%@ include file="../../../../../include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.fr.bean.*,java.util.*,org.coin.fr.bean.mail.*" %>
<%
	int iIdMailing = Integer.parseInt( request.getParameter("iIdMailing") );
	int iIdOrganisation = Integer.parseInt( request.getParameter("iIdOrganisation") );
	String bsClosePopUp = request.getParameter("bClosePopUp") ;
	String sClosePopUp = ""; 
	Organisation organisation = Organisation.getOrganisation(iIdOrganisation );
	String sUrlRetour = "afficherMailing.jsp?iIdMailing=" + iIdMailing + "&amp;nonce=" + System.currentTimeMillis();	
	String sTitle = "Choisir les destinataires de l'envoi pour l'organisation " + organisation.getRaisonSociale();
	
	Vector vPersonnesPhysique = PersonnePhysique.getAllFromIdOrganisation(organisation.getIdOrganisation());
	Vector<MailingDestinataire> vMailingDestinatairePersonnesPhysiqueSelected 
		= MailingDestinataire.getAllForPersonnePhysiqueSelected(iIdMailing, organisation.getIdOrganisation());
	
	MailingDestinataire mdOrganisation 
		= MailingDestinataire.getOrganisationSelected(iIdMailing, organisation.getIdOrganisation());
	
	String sEmail = organisation.getMailOrganisation() ;
	String sCheckBoxDisable = "";
	String sCheckBoxChecked = "";

	if(mdOrganisation != null)
	{
		sCheckBoxChecked = " checked ";
	}
	
	if(sEmail == null || sEmail.equals(""))
	{
		sEmail = "<i>[Pas de mail]</i>";
		sCheckBoxDisable = " disabled ";
	}
	
	if(bsClosePopUp != null && bsClosePopUp.equals("true"))
	{
		sClosePopUp = "onload='closeAndUpdate()' "	;
	}
%>
<script type="text/javascript" src="<%= rootPath %>include/redirection.js" ></script>
<script type="text/javascript" >
function closeAndUpdate()
{
	RedirectURL('<%= response.encodeURL(sUrlRetour ) %>');
}

</script>
</head>
<body <%= sClosePopUp  %> >
<%@ include file="../../../../../include/new_style/headerFichePopUp.jspf" %>
<br/>
<div style="padding:15px">
<form action="<%= response.encodeURL("modifierDestinatairesFromOrganisation.jsp") %>" method="post"  name="formulaire">
<input type="hidden" name="iIdMailing" value="<%= iIdMailing %>" />
<input type="hidden" name="iIdOrganisation" value="<%= organisation.getIdOrganisation() %>" />
<br />
<table class="pave" summary="none">
	<tr>
		<td >&nbsp;</td>
	</tr>
	<tr>
		<td width="1%" ><input type="checkbox" name="bOrganisationChecked" <%=sCheckBoxDisable %> <%=sCheckBoxChecked  %> /></td>
		<td width="1%" style="text-align:left" >&nbsp;</td>
		<td width="40%" style="text-align:left"  ><%= organisation.getRaisonSociale() %></td>
		<td width="30%" style="text-align:left" ><%= sEmail %></td>
		<td width="60%" >&nbsp;</td>
	</tr>
	<%
	for(int i= 0; i < vPersonnesPhysique.size() ; i++)
	{
		PersonnePhysique personne = (PersonnePhysique ) vPersonnesPhysique.get(i);
		sEmail = personne.getEmail() ;
		sCheckBoxDisable = "";
		sCheckBoxChecked = "";
		if (MailingDestinataire.isPersonnePhysiqueInMailingDestinataire(personne.getIdPersonnePhysique(), vMailingDestinatairePersonnesPhysiqueSelected ))
		{
			sCheckBoxChecked = " checked ";
		}
		if(sEmail .equals(""))
		{
			sEmail = "<i>[Pas de mail]</i>";
			sCheckBoxDisable = " disabled ";
		}
		
	 %>
	<tr>
		<td >&nbsp;</td>
		<td style="text-align:left" ><input type="checkbox" name="iIdPersonnePhysique" <%=sCheckBoxDisable %> value="<%= personne.getIdPersonnePhysique() %>" <%=sCheckBoxChecked  %> /></td>
		<td style="text-align:left" ><%= personne.getPrenom() + " " + personne.getNom() %></td>
		<td style="text-align:left" ><%= sEmail %></td>
		<td >&nbsp;</td>
	</tr>
	<%
	}
	 %>
	<tr>
		<td >&nbsp;</td>
	</tr>
</table>
<div style="text-align:center">
	<button type="submit" >Valider</button>
	<button type="button" name="retour"
			onclick="closeAndUpdate()" >Retour</button>
		
</div>
</form>
</div>
<%@ include file="../../../../../include/new_style/footerFiche.jspf" %>
</body>
</html>