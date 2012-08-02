<%@ include file="../../../../include/headerXML.jspf" %>

<%@ page import="org.coin.fr.bean.*,java.util.*,modula.marche.*,org.coin.fr.bean.mail.*" %>
<%@ include file="../../../include/beanSessionUser.jspf" %>
<%
	String rootPath = request.getContextPath()+"/";
	int iIdAffaire = -1;
	Mailing mailing = null;
	
	int iIdMailing = -1;
	boolean  bReadOnly = true;
	
	iIdMailing = Integer.parseInt( request.getParameter("iIdMailing") );
	mailing = Mailing.getMailing(iIdMailing);
	bReadOnly = false;

	
	String sTitle = "Afficher mailing";
	
	Vector<Organisation> vOrganisationsSelected 
		= MailingDestinataire.getAllOrganisationsAvecAuMoinsUnePersonnePhysiqueSelectedOuOrganisationSelected(
				mailing.getIdMailing());
	
	String sDateEnvoi = "";
	if( mailing.getDateEnvoi() != null )
	{
	  sDateEnvoi = org.coin.util.CalendarUtil.getDateCourte(mailing.getDateEnvoi() )
	  	+ " à " + org.coin.util.CalendarUtil.getHeureMinuteSec(mailing.getDateEnvoi() );
	}
	String sDateCreation = "";
	if( mailing.getDateCreation() != null )
	{
	  sDateCreation = org.coin.util.CalendarUtil.getDateCourte(mailing.getDateCreation() )
	  	+ " à " + org.coin.util.CalendarUtil.getHeureMinuteSec(mailing.getDateCreation() );
	}
	
%>
<%@ include file="../../../include/headerDesk.jspf" %>
<script type="text/javascript" src="<%= rootPath %>include/redirection.js" ></script>
</head>
<body>
<div class="titre_page"><%= sTitle %></div>
<div style="padding-top:15px;">
</div>
<br />
<br />
<%@ include file="pave/paveDestinataires.jspf" %>

<form action="<%= response.encodeURL("modifierMailing.jsp") %>" method="post"  name="formulaire">
<input type="hidden" name="iIdMailing" value="<%= mailing.getIdMailing() %>" />
<input type="hidden" name="iIdObjetReference" value="<%= mailing.getIdObjetReference() %>" />
<input type="hidden" name="iIdTypeObjet" value="<%= mailing.getIdTypeObjet() %>" />
<br />
<table class="pave" summary="none">
	<tr>
		<td class="pave_titre_gauche" colspan="2" >Mailing</td>
	</tr>
	<tr>
		<td  >&nbsp;</td>
	</tr>
	<tr>
		<td class="pave_cellule_gauche">Id Mailing</td>
		<td class="pave_cellule_droite"><%= mailing.getIdMailing() %></td>
	</tr>
	<tr>
		<td class="pave_cellule_gauche">Mail type</td>
		<td class="pave_cellule_droite"><%
				MailType mt = MailType.getMailTypeMemory(mailing.getIdMailType());
				%><%= mt.getIdMailType() + " - " + mt.getObjetType() %>
		</td>
	</tr>
	<tr>
		<td class="pave_cellule_gauche">Expéditeur : </td>
		<td class="pave_cellule_droite"><%= mailing.getMailExpediteur() %></td>
	</tr>
	<tr>
		<td class="pave_cellule_gauche">Objet : </td>
		<td class="pave_cellule_droite"><%= mailing.getMailObjet() %></td>
	</tr>
	<tr>
		<td class="pave_cellule_gauche" style="vertical-align : top" >Corps : </td>
		<td class="pave_cellule_droite"><%= mailing.getMailCorps().replaceAll("\n","<br />") %></td>
	</tr>
	<tr>
		<td class="pave_cellule_gauche">Date création : </td>
		<td class="pave_cellule_droite"><%= sDateCreation %></td>
	</tr>
	<tr>
		<td class="pave_cellule_gauche">Date envoi : </td>
		<td class="pave_cellule_droite"><%= sDateEnvoi  %></td>
	</tr>
	<tr>
		<td >&nbsp;</td>
	</tr>
</table>
<br />
<div style="text-align:center">
	<input type="button" name="modifier" value="Modifier" 
			onclick="Redirect('<%= 
				response.encodeURL("modifierMailingForm.jsp?sAction=store&amp;iIdMailing=" + mailing.getIdMailing() ) %>')" />
	<input type="button" name="retour" value="Retour" 
			onclick="Redirect('<%= 
				response.encodeURL("afficherToutesPublications.jsp?iIdAffaire=" + mailing.getIdObjetReference() ) %>')" />
		
</div>
</form>
<%@ include file="../../../include/footerDesk.jspf" %>
</body>
</html>