<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.fr.bean.mail.*" %>
<%@ page import="org.coin.bean.*,modula.marche.*" %>
<%@ page import="modula.graphic.*" %>
<%
	int iIdAffaire = -1;
	String sIdAffaire = null;
	String sPageUseCaseId = "IHM-DESK-AFF-xx";
	String sTitle = "Afficher les publications"; 
	String sHeadTitre = "";
	boolean bAfficherPoursuivreProcedure = false;
	Marche marche;
	sIdAffaire = request.getParameter("iIdAffaire");
	iIdAffaire = Integer.parseInt(sIdAffaire );
	marche = Marche.getMarche(iIdAffaire );
	Vector<Mailing> vMailings = Mailing.getAllMailing(ObjectType.AFFAIRE, marche.getIdMarche());

%>
</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<br/>
<div style="padding:15px">
<%@ include file="/include/new_style/headerAffaireOnlyButtonDisplayAffaire.jspf" %>
<% 
	
	if(sessionUserHabilitation.isHabilitate("IHM-DESK-xxx") )
	{
	
%><table class="pave" >
	<tr>
		<td ><a href="<%= response.encodeURL("modifierMailingForm.jsp?sAction=create&amp;iIdAffaire=" + marche.getIdMarche() ) %>"> Ajouter un mailing</a></td>
	</tr>
</table>
<% 
	} 
%>
<br />
<table class="pave" summary="none">
	<tr>
		<td class="pave_titre_gauche">Liste des publications</td>
	</tr>
	<tr>
		<td colspan="2">

			<table class="liste" summary="none">
				<tr>
					<th >Mail Type</th>
					<th >Mail objet</th>
					<th >Date création</th>
					<th >Date envoi</th>
					<th >&nbsp;</th>
				</tr>
				<% 
				for (int i=0; i < vMailings.size(); i++)
				{
					Mailing mailing = vMailings.get(i);
					MailType mt = MailType.getMailTypeMemory(mailing.getIdMailType());
					int	j = i % 2;
					
					String sDateEnvoi = "";
					if( mailing.getDateEnvoi() != null )
					{
					  sDateEnvoi = org.coin.util.CalendarUtil.getDateFormattee(mailing.getDateEnvoi() );
					}
					String sDateCreation = "";
					if( mailing.getDateCreation() != null )
					{
					  sDateCreation = org.coin.util.CalendarUtil.getDateFormattee(mailing.getDateCreation() );
					}
					%>
				<tr class="liste<%=j%>" 
					 onmouseover="className='liste_over'" 
					 onmouseout="className='liste<%=j%>'" 
					 onclick="Redirect('<%= response.encodeRedirectURL("afficherMailing.jsp?iIdMailing=" + mailing.getIdMailing() ) %>')"> 
					<td style="text-align:left;width:30%" ><%= mailing.getIdMailType() + " - " + mt.getLibelle() %></td>
					<td style="text-align:left;width:20%" ><%= mailing.getMailObjet() %></td>
					<td style="text-align:left;width:10%" ><%= sDateCreation %></td>
					<td style="text-align:left;width:10%" ><%= sDateEnvoi %></td>
					<td style="text-align:left;width:3%" >
						<a href="<%= response.encodeURL("afficherMailing.jsp?iIdMailing=" + mailing.getIdMailing() ) %>">
						<img src="<%=rootPath + modula.graphic.Icone.ICONE_FICHIER_DEFAULT%>"  />
						</a>
					</td>
				</tr>
					<%		
				}
				%>
			</table>
		</td>
	</tr>
</table>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
</html>