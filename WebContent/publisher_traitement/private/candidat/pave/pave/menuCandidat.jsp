<%@ include file="/include/headerXML.jspf" %>

<%@ page import="modula.*,modula.graphic.*,java.util.*,org.coin.fr.bean.*" %>
<%@ include file="/publisher_traitement/public/include/beanSessionUser.jspf" %>
<%@ include file="/publisher_traitement/public/include/beanCandidat.jspf" %> 
<%@ include file="/include/publisherType.jspf"%>  
<%

	String rootPath = request.getContextPath()+"/";
	int iNbCandidatures = Candidature.getAllCandidatureFromUser(sessionUser.getIdIndividual()).size();
	
	Vector<BarBouton> vBarBoutons = new Vector<BarBouton>();
	vBarBoutons.add( new BarBouton(0,"Liste des petites annonces",
					response.encodeURL(rootPath + sPublisherPath + "/private/candidat/indexCandidat.jsp"),
					rootPath+"images/icones/liste_marche.gif",
					"this.src='"+rootPath+"images/icones/liste_marche_over.gif'",
					"this.src='"+rootPath+"images/icones/liste_marche.gif'",
					"",true) );
	vBarBoutons.add( new BarBouton(1,"Mes dossiers ("+iNbCandidatures+")",
					response.encodeURL(rootPath + sPublisherPath + "/private/candidat/accederDossierEnCours.jsp"),
					rootPath+"images/icones/affaire.gif",
					"this.src='"+rootPath+"images/icones/affaire_over.gif'",
					"this.src='"+rootPath+"images/icones/affaire.gif'",
					"",true) );
	vBarBoutons.add( new BarBouton(2,"Mon profil",
					response.encodeURL(rootPath + sPublisherPath + "/private/organisation/afficherPersonnePhysique.jsp"),
					rootPath+"images/icones/profil_candidat.jpg",
					"this.src='"+rootPath+"images/icones/profil_candidat_over.jpg'",
					"this.src='"+rootPath+"images/icones/profil_candidat.jpg'",
					"",true) );
	vBarBoutons.add( new BarBouton(3,"Profil de l'entreprise",
					response.encodeURL(rootPath + sPublisherPath + "/private/organisation/afficherOrganisation.jsp"),
					rootPath+"images/icones/organisation_candidate.jpg",
					"this.src='"+rootPath+"images/icones/organisation_candidate_over.jpg'",
					"this.src='"+rootPath+"images/icones/organisation_candidate.jpg'",
					"",true) );
	if (sessionUser.getIdIndividual() == organisation.getIdCreateur())
	{
		vBarBoutons.add( new BarBouton(4,"Transférer la gérance de l'organisme",
				response.encodeURL(rootPath + sPublisherPath + "/private/organisation/transfererGeranceOrganisationForm.jsp"),
				rootPath+"images/icones/transferer_gerance.gif",
				"this.src='"+rootPath+"images/icones/transferer_gerance_over.gif'",
				"this.src='"+rootPath+"images/icones/transferer_gerance.gif'",
				"",true) );
	}
%>
<table class="menu_secondaire" cellspacing="2">
	<tr>
<%		
		for(int i=0;i<vBarBoutons.size();i++)
		{
			BarBouton bouton = vBarBoutons.get(i);
			if(bouton.bVisible)
			{
			%>
			<%= bouton.getHtmlPublisher() %>
			<%
			}
		}

%>
		<td style="text-align:right;font-size:11px;">
		<br />	
		<a href="<%= response.encodeURL(rootPath + sPublisherPath + "/private/organisation/afficherPersonnePhysique.jsp") %>">
			<%= candidat.getCivilitePrenomNom() +" " %> 
		</a>
		<br />
		<a href="<%= response.encodeURL(rootPath + sPublisherPath + "/private/organisation/afficherOrganisation.jsp")%>">
			<%= organisation.getRaisonSociale() %>
		</a>
		<br /><br />
		<img src="<%=rootPath+"images/deco.gif" %>" style="vertical-align:middle"/>
		<a href="<%= response.encodeURL(rootPath + sPublisherPath + "/logout.jsp")%>" style="color:red">D&eacute;connexion</a><br /> <br /><br />
		</td>
	</tr>
</table>
<br />