<%@ include file="../../../../../include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.fr.bean.*,java.util.*,org.coin.fr.bean.mail.*" %>
<%
	String sAction = request.getParameter("sAction") ;
	int iIdAffaire = -1;
	Mailing mailing = null;
	String sUrlCancel = "";
	
	int iIdMailing = -1;
	boolean  bReadOnly = true;
	if(sAction.equals("create"))
	{
		iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
		mailing = new Mailing();
		mailing.setIdObjetReference(iIdAffaire);
		mailing.setIdTypeObjet(ObjectType.AFFAIRE);
		mailing.setMailExpediteur(sessionUser.getLogin());
		bReadOnly = true;
		sUrlCancel = "afficherToutesPublications.jsp?iIdAffaire=" + mailing.getIdObjetReference();
	}
	
	if(sAction.equals("store"))
	{
		iIdMailing = Integer.parseInt( request.getParameter("iIdMailing") );
		mailing = Mailing.getMailing(iIdMailing);
		bReadOnly = true;
		sUrlCancel  = "afficherMailing.jsp?iIdMailing=" + mailing.getIdMailing() ;
	}

	
	String sTitle = "Afficher mailing";
	
	Vector<Organisation> vOrganisationsSelected 
		= MailingDestinataire.getAllOrganisationsAvecAuMoinsUnePersonnePhysiqueSelectedOuOrganisationSelected(mailing.getIdMailing());
	
	
%>
<script type="text/javascript" src="<%= rootPath %>include/redirection.js" ></script>
<script type="text/javascript" src="<%= rootPath %>include/calendar.js" ></script>
<script type="text/javascript" >
function modifierMailType()
{
	var form = document.formulaire;
	var sUrlTarget = "<%= 
					response.encodeURL("modifierMailing.jsp?sAction=modifierMailType&iIdMailing=" 
					+ iIdMailing + "&nonce=" + System.currentTimeMillis() + "&iIdMailType=") %>";
		
	var item = form.elements["iIdMailType"];
	Redirect(sUrlTarget + item.value);
	
}
</script>
</head>
<body>
<%@ include file="../../../../../include/new_style/headerFichePopUp.jspf" %>
<br/>
<div style="padding:15px">

<br />
<%@ include file="pave/paveDestinataires.jspf" %>

<form action="<%= response.encodeURL("modifierMailing.jsp") %>" method="post"  name="formulaire">
<input type="hidden" name="iIdMailing" value="<%= mailing.getIdMailing() %>" />
<input type="hidden" name="iIdObjetReference" value="<%= mailing.getIdObjetReference() %>" />
<input type="hidden" name="iIdTypeObjet" value="<%= mailing.getIdTypeObjet() %>" />
<input type="hidden" name="sAction" value="<%= sAction %>" />
<br />
<table class="pave" summary="none">
	<tr>
		<td class="pave_titre_gauche" colspan="2" >Mailing</td>
	</tr>
	<tr>
		<td  >&nbsp;</td>
	</tr>
	<tr>
		<td class="pave_cellule_gauche">Mail type</td>
		<td class="pave_cellule_droite">
			<select name="iIdMailType" style="width : 550px">
			<% 
				Vector<MailType> vMailsType = MailType.getAllStaticMemory();
				for(int i = 0; i < vMailsType.size(); i++)
				{
					MailType mt = vMailsType.get(i);
					String sSelected = "";
					if(mailing.getIdMailType() == mt.getIdMailType() )
					{
						sSelected = " selected ";
					}	
			%>
				<option value="<%= mt.getIdMailType() %>" <%=sSelected  %> ><%= mt.getIdMailType() + " - " + mt.getLibelle() %></option>
			<% 	} %>
			</select> 
			<% 	if(sAction.equals("store")) 
				{
			%>
			<input type="button" onclick="javascript:modifierMailType()" value="Sélectionner" />
			<%	} %>
		</td>
	</tr>
	<tr>
		<td class="pave_cellule_gauche">Expéditeur : </td>
		<td class="pave_cellule_droite"><input size="100" type="text" name="sMailExpediteur" value="<%= mailing.getMailExpediteur() %>" /></td>
	</tr>
<%
	if(sAction.equals("store"))
	{

 %>	<tr>
		<td class="pave_cellule_gauche">Objet : </td>
		<td class="pave_cellule_droite"><input size="100" type="text" name="sMailObjet" value="<%= mailing.getMailObjet() %>" /></td>
	</tr>
	<tr>
		<td class="pave_cellule_gauche" style="vertical-align : top" >Corps : </td>
		<td class="pave_cellule_droite"><textarea cols="100" rows="20" name="sMailCorps" ><%= mailing.getMailCorps() %></textarea></td>
	</tr>
<% }
	String sDateEnvoi = "";
	String sHeureEnvoi = "17:00";
	if( mailing.getDateEnvoi() != null )
	{
	  sDateEnvoi = org.coin.util.CalendarUtil.getDateCourte(mailing.getDateEnvoi() );
	  sHeureEnvoi = org.coin.util.CalendarUtil.getHeureMinuteSec(mailing.getDateEnvoi() );
	}
	String sDateCreation = "";
	if( mailing.getDateCreation() != null )
	{
	  sDateCreation = org.coin.util.CalendarUtil.getDateFormattee(mailing.getDateCreation() );
	}
%>
	<tr>
		<td class="pave_cellule_gauche">Date envoi : </td>
		<td class="pave_cellule_droite">
			<input 
				name="tsDateEnvoi" 
				size="15" 
				maxlength="10" 
				class="dataType-date"
				value="<%= sDateEnvoi %>" /> à&nbsp;
			<input 
				size="5" 
				maxlength="5" 
				name="tsHeureEnvoi" 
				value="<%= sHeureEnvoi %>" />
		</td>
	</tr>
	<tr>
		<td class="pave_cellule_gauche">Date création : </td>
		<td class="pave_cellule_droite"><%= sDateCreation %></td>
	</tr>
	<tr>
		<td >&nbsp;</td>
	</tr>
</table>
<br />
<div style="text-align:center">
	<input type="submit" value="Valider" />
	<input type="button" name="retour" value="Retour" 
			onclick="Redirect('<%= 
				response.encodeURL(sUrlCancel ) %>')" />
		
</div>
</form>
</div>
<%@ include file="../../../../../include/new_style/footerFiche.jspf" %>
</body>
<%@page import="org.coin.bean.ObjectType"%>
</html>