<%@ include file="/include/new_style/headerPublisher.jspf" %>
<%@ page import="org.coin.bean.html.*,modula.graphic.*,org.coin.fr.bean.*,java.util.*" %>
<%@ include file="/publisher_traitement/public/include/beanCandidat.jspf" %> 
<%
	String sFormPrefix = "";
	String sUseCaseIdBoutonAjouterCandidat = "IHM-PUBLI-CDT-010";
	String sTitle = "Profil de " + organisation.getRaisonSociale(); 
	
    String sAction = HttpUtil.parseStringBlank("sAction", request);
    String sMessage = HttpUtil.parseStringBlank("sMessage", request);
	int iIdOnglet = HttpUtil.parseInt("iIdOnglet", request, 0) ;
		
	Adresse adresse = new Adresse();
	Pays pays = new Pays();
	try
	{
		adresse = Adresse.getAdresse(organisation.getIdAdresse());
		pays = Pays.getPays(adresse.getIdPays() );
	}
	catch(Exception e){}
	
	Vector<PersonnePhysique> vPersonnes = PersonnePhysique.getAllFromIdOrganisation(organisation.getIdOrganisation());
	
	Onglet.sNotCurrentTabStyle = " class='onglet_non_selectionne' "; 
	Onglet.sCurrentTabStyle =  " class='onglet_selectionne' ";
	Onglet.sNotCurrentTabStyleInCreation = " class='onglet_non_selectionne' ";
	Onglet.sCurrentTabStyleInCreation =  " class='onglet_selectionne' ";
	Onglet.sEnddingTabStyle =  " class='onglet_vide_dernier' ";

	Vector<Onglet> vOnglets = new Vector<Onglet>();
	vOnglets.add( new Onglet(0, false, "Données administratives", response.encodeURL( "afficherOrganisation.jsp?iIdOnglet=0")) ); 
	vOnglets.add( new Onglet(1, false, "Coordonnées", response.encodeURL("afficherOrganisation.jsp?iIdOnglet=1")) ); 
	vOnglets.add( new Onglet(2, false, "Adresse", response.encodeURL("afficherOrganisation.jsp?iIdOnglet=2")) ); 
	vOnglets.add( new Onglet(3, false, "Comptes utilisateur", response.encodeURL("afficherOrganisation.jsp?iIdOnglet=3"),true) ); 
	vOnglets.add( new Onglet(4, false, "Acheteur public", response.encodeURL("afficherOrganisation.jsp?iIdOnglet=4"), true) ); 
	vOnglets.add( new Onglet(6, false, "Personnes", response.encodeURL("afficherOrganisation.jsp?iIdOnglet=6"), true )); 
	vOnglets.add( new Onglet(7, false, "Commissions", response.encodeURL("afficherOrganisation.jsp?iIdOnglet=7"), true) ); 
	vOnglets.add( new Onglet(8, false, "Transfert", response.encodeURL("afficherOrganisation.jsp?iIdOnglet=8"), true) ); 
	vOnglets.add( new Onglet(9, false, "Paramètres", response.encodeURL("afficherOrganisation.jsp?iIdOnglet=9"),true) ); 
	vOnglets.add( new Onglet(10, false, "Affaires", response.encodeURL("afficherOrganisation.jsp?iIdOnglet=10"), true) ); 
	
	Onglet onglet = vOnglets.get(iIdOnglet);
	onglet.bIsCurrent = true;
	
	if (sessionUser.getIdIndividual() == organisation.getIdCreateur())
	{
		Onglet ongletPersonnes = vOnglets.get(Onglet.ONGLET_ORGANISATION_PERSONNES);
		ongletPersonnes.bHidden = false; 
	}
	
	boolean bDisplayAll = true;
	if(sessionUser.getOrganisation().getIdCodeNaf() == 0
	|| BoampCPFItem.getAllFromTypeAndReferenceObjet(ObjectType.ORGANISATION, sessionUser.getOrganisation().getId()).isEmpty()
	|| CodeNaf.getCodeNaf(sessionUser.getOrganisation().getIdCodeNaf()).getIdCodeNafEtat() == 2) {
		bDisplayAll = false;
	}
	
	String sPageUseCaseId = "IHM-PUBLI-CDT-006";
%>
<%@ include file="/publisher_traitement/public/include/checkHabilitationPage.jspf" %>
<script type="text/javascript" src="<%=rootPath %>dwr/interface/CheckAjaxVerifField.js"></script>
<script type="text/javascript" src="<%=rootPath %>include/bascule.js"></script>
<script type="text/javascript" src="<%= rootPath %>include/AjaxVerifField.js?v=<%= JavascriptVersionModula.VERIF_FIELD %>" ></script>
<%
	if(sAction.equals("store"))	
	{
%>
<script type="text/javascript">
<%@ include file="/publisher_traitement/private/organisation/modifierOrganisation.jspf" %>
</script>
<%
	}

	if(iIdOnglet == Onglet.ONGLET_ORGANISATION_PERSONNES)
	{
%>
<script type="text/javascript">
function checkRemovePP() 
{
	return confirm("Toutes les candidatures et le compte utilisateur de cette personne seront supprimés.\nEtes-vous sûr de vouloir supprimer cette personne?");
}
</script>
<%
	}
%>
</head>
<body >
<%@ include file="/publisher_traitement/public/include/header.jspf" %>
<div class="titre_page"><%= sTitle  %></div>
<div class="tabFrame">
<%= Onglet.getAllTabsHtmlDesk(vOnglets)  %>
<div class="tabContent">
<%
	boolean bDisplayFormButton = false;
	boolean bDisplayButtonModify = false;

	if(( iIdOnglet == Onglet.ONGLET_ORGANISATION_DONNEES_ADMINISTRATIVES )
	|| ( iIdOnglet == Onglet.ONGLET_ORGANISATION_COORDONNEES)
	|| ( iIdOnglet == Onglet.ONGLET_ORGANISATION_ADRESSE))
	{
		if(sAction.equals("store"))	
		{
			bDisplayFormButton = true;
		}
		else
		{
			bDisplayButtonModify = true;
		}
	}
	
	/***
     * TODO_AG : ne pas enlever tant que les WS Alice ne sont pas activés
     */
     /***
      * TODO_AG : ne pas enlever tant que les WS Alice ne sont pas activés
      */
     if(bDisplayButtonModify
     && !Configuration.isEnabledMemory("publisher.portail.addressbook.update", true))
     {
         if(!sessionUserHabilitation.isSuperUser() )
         {
             bDisplayButtonModify = false;
         }
     }   
	
	if( bDisplayButtonModify)
	{
	%>
	<div style="text-align:right">
	<button 
		type="button" 
		onclick="<%= response.encodeURL(
			"Redirect('afficherOrganisation.jsp?") 
			+ "iIdOnglet=" + iIdOnglet 
			+ "&amp;sAction=store" %>');" >Modifier</button>
	</div>
	<br/>
<%
	}
	
	HtmlBeanTableTrPave hbFormulaire = new HtmlBeanTableTrPave();
	hbFormulaire.bIsForm = false;
	
	if( bDisplayFormButton)
	{
		hbFormulaire.bIsForm = true;
%>
	<form action="<%= response.encodeURL(rootPath + "publisher_traitement/private/organisation/modifierOrganisation.jsp?bDisplayAll=" +bDisplayAll)%>" method="post" name="formulaire" onsubmit="return checkForm();">
	<div style="text-align:right">
	<input type="hidden" name="sAction" value="store" />
	<input type="hidden" name="iIdOnglet" value="<%= iIdOnglet  %>" />
	<button type="submit" >Valider</button>
	</div>
	<br/>
	<a name="ancreError"></a>
	<div class="rouge" style="text-align:left" id="divError"></div>
<%
	}
	
	if(!sMessage.equalsIgnoreCase(""))
	{
%>
<div class="rouge" style="text-align:left" id="message"><%= sMessage %></div>
<br />
<%
	}

	if( iIdOnglet == Onglet.ONGLET_ORGANISATION_DONNEES_ADMINISTRATIVES)
	{
		Vector<BoampCPFItem> vCompetencesOrganisationLibrary = BoampCPFItem.getAllFromTypeAndReferenceObjet(ObjectType.ORGANISATION, organisation.getIdOrganisation());
		Vector<BoampCPF> vCompetencesOrganisation = new Vector<BoampCPF>();
		for(BoampCPFItem itemOrg : vCompetencesOrganisationLibrary){
			vCompetencesOrganisation.add(BoampCPF.getBoampCPFMemory(itemOrg.getIdOwnedObject()));
		}
		
		if(sAction.equals("store"))
		{
			%><%@ include file="/publisher_traitement/private/organisation/pave/paveOrganisationDonneesAdministrativesForm.jspf" %><br/><%
			
			%><%@ include file="/publisher_traitement/private/organisation/pave/paveCompetenceForm.jspf" %><%
		}
		else
		{
			%><%@ include file="/publisher_traitement/private/organisation/pave/paveOrganisationDonneesAdministratives.jspf" %><%
		}		
	} 

	if( iIdOnglet == Onglet.ONGLET_ORGANISATION_COORDONNEES)
	{
		if(sAction.equals("store"))
		{
			%><%@ include file="/publisher_traitement/private/organisation/pave/paveOrganisationCoordonneesForm.jspf" %><%
		}
		else
		{
			%><%@ include file="/publisher_traitement/private/organisation/pave/paveOrganisationCoordonnees.jspf" %><%
		}		
	}
	
	if( iIdOnglet == Onglet.ONGLET_ORGANISATION_ADRESSE)
	{
		String sPaveAdresseTitre = "Adresse";
		if(sAction.equals("store"))
		{
			%><%@ include file="/publisher_traitement/private/organisation/pave/paveAdresseForm.jspf" %><%
		}
		else
		{
			%><%@ include file="/publisher_traitement/private/organisation/pave/paveAdresse.jspf" %><%
		}		
	}

	if( iIdOnglet == Onglet.ONGLET_ORGANISATION_PERSONNES)
	{
%> 
	<div style="text-align:right">	
	<button type="button" onclick="javascript:Redirect('<%= 
		response.encodeURL( rootPath + sPublisherPath 
				+ "/private/organisation/ajouterPersonnePhysiqueForm.jsp")
				%>')" >Ajouter une personne</button>
	</div>
	<br />
<div class="post">
    <div class="post-title">
        <table class="fullWidth" cellpadding="0" cellspacing="0">
        <tr>
            <td>
                <strong style="color:#36C">Personnes associées à l'organisme</strong>
            </td>
            <td class="right">
                <strong style="color:#B00">&nbsp;</strong>
            </td>
        </tr>
        </table>
    </div>
  <br/>
  <div class="post-footer post-block" style="margin-top:0">
    <table class="fullWidth">
 		<tr>
			<td>
				<table class="liste" >
					<tr>
						<th>Personne publique</th>
						<th>Fonction</th>
						<th>E-mail</th>
						<th>Commune</th>
						<th>&nbsp;</th>
						<th>&nbsp;</th>
					</tr>
<%
		for (int i = 0; i < vPersonnes.size(); i++)
		{
			PersonnePhysique personne = vPersonnes.get(i);
			
			Adresse adressePersonne = null;
			try{adressePersonne = Adresse.getAdresse(personne.getIdAdresse());}
			catch(Exception e){adressePersonne = new Adresse();}
			
			int j = i % 2;
            %><%@ include file="/publisher_traitement/private/organisation/pave/paveListItemPersonnePhysiqueInOrganisation.jspf" %><%
		}
%>
				</table> 
			</td>
		</tr>
	</table>

<%
	}

	if( bDisplayFormButton)
	{
	%>
	</form>
	<%
	}
	%>


</div>
	
<%@include file="/publisher_traitement/public/include/footer.jspf"%>
</body>
<%@page import="org.coin.bean.boamp.BoampCPFItem"%>
<%@page import="org.coin.bean.boamp.BoampCPF"%>
<%@page import="org.coin.util.HttpUtil"%>

<%@page import="mt.modula.JavascriptVersionModula"%></html>