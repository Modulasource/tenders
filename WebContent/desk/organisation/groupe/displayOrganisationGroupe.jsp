<%@ include file="../../../include/new_style/headerDesk.jspf" %>

<%@page import="modula.graphic.Onglet"%>
<%@ page import="java.util.Vector"%>
<%@ page import="org.coin.bean.html.*,org.coin.fr.bean.*" %>
<%@page import="org.coin.db.CoinDatabaseAbstractBeanHtmlUtil"%>
<%

	Organisation organisation = null;



	ObjectGroup ogOrganisationGroupe
		= ObjectGroup.getObjectGroup(
			Long.parseLong(request.getParameter("lIdObjectGroup")));




	organisation = Organisation.getOrganisation( (int)ogOrganisationGroupe.getIdReferenceObject());
	String sTitle = "Groupe " + ogOrganisationGroupe.getNom() + " ";
	sTitle += organisation.getRaisonSociale();


	Vector<PersonnePhysique> vPPMembre = new Vector<PersonnePhysique> ();
	Vector<ObjectGroupItem> vMembreItem = null;
	PersonnePhysique membreResponsable = null;




	if(ogOrganisationGroupe.getIdTypeObjectHead() != ObjectType.PERSONNE_PHYSIQUE)
	{
		throw new Exception("Le responsable doit être une personne physique");
	}

	try{
		membreResponsable = PersonnePhysique.getPersonnePhysique(ogOrganisationGroupe.getIdReferenceObjectHead());
	} catch (Exception e) {
		// le service n'a pas de membre affecté
		membreResponsable = new PersonnePhysique();
	}
	vMembreItem
		= ObjectGroupItem.getAllObjectGroupItemFromIdObjectGroup(ogOrganisationGroupe.getId() );

	vPPMembre
		= ObjectGroupItem.getAllPersonnePhysique(vMembreItem	);


	Vector vPPMembreDispo
		= PersonnePhysique.getAllWithWhereAndOrderByClauseStatic(
				" WHERE id_organisation=" + organisation.getId(),
				"");



%>

<script type="text/javascript">
function addMembre()
{
	var id = document.getElementById("membreToAdd");

	doUrl("<%= response.encodeURL("modifyOrganisationGroupeMembre.jsp?"
			+ "lIdObjectGroup=" + ogOrganisationGroupe.getId()
		  )
			%>&sAction=addMembre&lIdPersonnePhysiqueMembre=" + id.value);
}

</script>
</head>
<body>
<%
	HtmlBeanTableTrPave hbFormulaire = new HtmlBeanTableTrPave();
	hbFormulaire.bIsForm = false;



%>

<%@ include file="../../../include/new_style/headerFiche.jspf" %>
<div style="padding:15px">

<div class="dataGridHolder fullWidth">
<div id="fiche">
	<table class="pave">
		<tr>
			<td class="title" colspan="2">Service</td>
		</tr>
		<%= hbFormulaire.getHtmlTrInput("Nom :", "sNom", ogOrganisationGroupe.getNom() ) %>
		<%= hbFormulaire.getHtmlTrInput("Description :", "sDescription", ogOrganisationGroupe.getDescription() ) %>
		<%= hbFormulaire.getHtmlTrInput("Alias :", "sAlias", ogOrganisationGroupe.getAlias() ) %>
		<%= hbFormulaire.getHtmlTrInput("Email :", "sEmail", ogOrganisationGroupe.getEmail() ) %>

		<tr class="header">
			<td>
				Responsable :
			</td>
			<td>
			<%= membreResponsable.getCivilitePrenomNomOptional()%>
			</td>
		</tr>

	</table>
	<br />
	<button type="reset" name="Modifier" onclick="Redirect('<%=
		response.encodeRedirectURL("modifyOrganisationGroupeForm.jsp?sAction=store&amp;lIdObjectGroup="
				+ogOrganisationGroupe.getId())
		%>')" >Modifier</button>
	<button type="reset" name="Supprimer" onclick="Redirect('<%=
		response.encodeRedirectURL("modifyOrganisationGroupe.jsp?sAction=remove&amp;lIdObjectGroup="
				+ogOrganisationGroupe.getId() )
		%>')" >Supprimer</button>
	<button type="reset" onclick="Redirect('<%=
		response.encodeRedirectURL("../afficherOrganisation.jsp?iIdOrganisation="
				+organisation.getIdOrganisation()+"&amp;iIdOnglet=" + Onglet.ONGLET_ORGANISATION_GROUP)
		%>')" >Retour</button>
</div>
</div>
<% 	hbFormulaire.bIsForm = true;
 %>
<div id="fiche">

		<div class="dataGridHolder fullWidth">
		<table class="dataGrid fullWidth">
			<tr>
				<td> Les membres : </td>
			</tr>
			<tr>
				<td>
					<table class="dataGrid fullWidth">
						<tr class="header">
							<td>Nom</td>
							<td>Téléphone</td>
							<td>Email</td>
							<td>&nbsp;</td>
						</tr>
<%
	for (int i =0; i < vPPMembre.size(); i++)
	{
		ObjectGroupItem itemMembre = vMembreItem.get(i);
		PersonnePhysique membre= vPPMembre.get(i);
		int j = i % 2;
		String sUrlDisplay = rootPath
				+"desk/organisation/afficherPersonnePhysique.jsp?iIdPersonnePhysique="
				+ membre.getId();

		String sUrlRemove = rootPath
			+"desk/organisation/groupe/modifyOrganisationGroupeMembre.jsp?sAction=remove&amp;lIdObjectGroupItem="
			+ itemMembre.getId()
			+ "&amp;lIdObjectGroup="+ ogOrganisationGroupe.getId();


%>
					<tr class="liste<%=j %>"
						onmouseover="className='liste_over'"
						onmouseout="className='liste<%=j %>'"
						>
						<td style="width:25%"><%= membre.getCivilitePrenomNomFonction()%></td>
						<td style="width:25%"><%= membre.getTelBureau()%></td>
						<td style="width:25%"><%= membre.getEmail()%></td>
						<td style="text-align:right;width:5%">
							<a class="image" href="<%= response.encodeURL(sUrlRemove ) %>">
								<img src="<%=rootPath+"images/delete.gif" %>" alt="Supprimer" title="Supprimer"/>
							 </a>
							<a class="image" href="<%= response.encodeURL(sUrlDisplay ) %>">
								<img src="<%=rootPath+"images/icons/default.gif" %>" alt="<%= localizeButton.getValueDisplay() %>" title="<%= localizeButton.getValueDisplay() %>"/>
							 </a>
						</td>
					</tr>
<%
		}
%>

						</table>

				</td>
			</tr>

							<tr class="header">
								<td>
									<button type='reset'
										name='AjouterMembre'
										onclick='javascript:addMembre();'
									 >Ajouter</button>

								<%= CoinDatabaseAbstractBeanHtmlUtil.getHtmlSelect(
										"membreToAdd",
										1,
										vPPMembreDispo,
										0L,
										"",
										false,
										false) %>
								</td>
							</tr>

		</table>

		</div>
		</div>

	<br />
</div>


<div id="fiche_footer">
</div>
</div>
<%@ include file="../../../../include/new_style/footerFiche.jspf" %>


</body>
<%@page import="org.coin.bean.ObjectType"%>
</html>

