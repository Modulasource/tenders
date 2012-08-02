<%@ include file="/include/new_style/headerPublisher.jspf" %>
<%@ page import="org.coin.security.*,org.coin.bean.html.*,modula.algorithme.*,modula.graphic.*,org.coin.fr.bean.*,modula.*, java.sql.*, java.util.*, modula.candidature.*" %>
<%@ include file="/publisher_traitement/public/include/beanCandidat.jspf" %> 
<%
	String sFormPrefix = "";
	PersonnePhysique personne = candidat;
	if (organisation.getIdCreateur() == candidat.getIdPersonnePhysique()){
		try 
		{
			String sPP = request.getParameter("pp");
			personne = PersonnePhysique.getPersonnePhysique(Integer.parseInt(
                    SecureString.getSessionPlainString(
                            sPP,session)));
		} 
		catch (Exception e) 
		{
			personne = candidat;
		}
	}
	else{
		personne = candidat;
	}
	String sPPParamSecure = SecureString.getSessionSecureString(Long.toString(personne.getId()),session);
	
	User user = null;
	try	{user = User.getUserFromIdIndividual(personne.getIdPersonnePhysique() );}
	catch (Exception e) {}
	
	Adresse adresse = new Adresse();
	Pays pays = new Pays();
	Pays nationalite = new Pays();
	try
	{
		adresse = Adresse.getAdresse(personne.getIdAdresse());
		pays = Pays.getPays(adresse.getIdPays() );
		nationalite = Pays.getPays(personne.getIdNationalite() );
	}
	catch(Exception e){}
	
    String sAction = HttpUtil.parseStringBlank("sAction", request);
    String sMessage = HttpUtil.parseStringBlank("sMessage", request);
    int iIdOnglet = HttpUtil.parseInt("iIdOnglet", request, 0) ;

	
	Onglet.sNotCurrentTabStyle = " class='onglet_non_selectionne' "; 
	Onglet.sCurrentTabStyle =  " class='onglet_selectionne' ";
	Onglet.sNotCurrentTabStyleInCreation = " class='onglet_non_selectionne' ";
	Onglet.sCurrentTabStyleInCreation =  " class='onglet_selectionne' ";
	Onglet.sEnddingTabStyle =  " class='onglet_vide_dernier' ";

	Vector<Onglet> vOnglets = new Vector<Onglet>();
	String sAddParam = "&pp="+sPPParamSecure+"&nonce=" + System.currentTimeMillis();
	vOnglets.add( new Onglet(Onglet.ONGLET_PERSONNE_PHYSIQUE_DONNEES_ADMINISTRATIVES, false, "Données administratives",response.encodeURL("afficherPersonnePhysique.jsp?iIdOnglet="+Onglet.ONGLET_PERSONNE_PHYSIQUE_DONNEES_ADMINISTRATIVES+sAddParam)) ); 
	vOnglets.add( new Onglet(Onglet.ONGLET_PERSONNE_PHYSIQUE_ADRESSE, false, "Adresse", response.encodeURL("afficherPersonnePhysique.jsp?iIdOnglet="+Onglet.ONGLET_PERSONNE_PHYSIQUE_ADRESSE+sAddParam)) ); 
	vOnglets.add( new Onglet(Onglet.ONGLET_PERSONNE_PHYSIQUE_ORGANISATION, false, "Organisation", response.encodeURL("afficherPersonnePhysique.jsp?iIdOnglet="+Onglet.ONGLET_PERSONNE_PHYSIQUE_ORGANISATION+sAddParam), true));  
	//vOnglets.add( new Onglet(3,false,"","",true));
	vOnglets.add( new Onglet(Onglet.ONGLET_PERSONNE_PHYSIQUE_CERTIFICATS, false, "Certificats", response.encodeURL("afficherPersonnePhysique.jsp?iIdOnglet="+Onglet.ONGLET_PERSONNE_PHYSIQUE_CERTIFICATS+sAddParam), true)); 
	//vOnglets.add( new Onglet(5,false,"","",true));
	if(user != null)
		vOnglets.add( new Onglet(Onglet.ONGLET_PERSONNE_PHYSIQUE_COMPTE_UTILISATEUR, false, "Compte utilisateur", response.encodeURL("afficherPersonnePhysique.jsp?iIdOnglet="+Onglet.ONGLET_PERSONNE_PHYSIQUE_COMPTE_UTILISATEUR+sAddParam)) );  
	//vOnglets.add( new Onglet(7,false,"","",true));
	vOnglets.add( new Onglet(Onglet.ONGLET_PERSONNE_PHYSIQUE_CANDIDATURES,false,"Candidatures",response.encodeURL("afficherPersonnePhysique.jsp?iIdOnglet="+Onglet.ONGLET_PERSONNE_PHYSIQUE_CANDIDATURES+sAddParam), true));
	//vOnglets.add( new Onglet(Onglet.ONGLET_PERSONNE_PHYSIQUE_VEILLE_MARCHE,false,"Veille de marchés",response.encodeURL("afficherPersonnePhysique.jsp?iIdOnglet="+Onglet.ONGLET_PERSONNE_PHYSIQUE_VEILLE_MARCHE+sAddParam)));

	Onglet onglet = Onglet.getOnglet(vOnglets,iIdOnglet);
	onglet.bIsCurrent = true;
	
	String sTitle = "Profil de "+personne.getCivilitePrenomNom();
	if(sessionUser.getIdIndividual() == personne.getIdPersonnePhysique())
	{
		sTitle = "Mon profil";
	}
	String sPageUseCaseId = "IHM-PUBLI-CDT-006";
%>
<%@ include file="/publisher_traitement/public/include/checkHabilitationPage.jspf" %>
<script type="text/javascript" src="<%= rootPath %>include/bascule.js" ></script>
<script type="text/javascript" src="<%=rootPath %>dwr/interface/CheckAjaxVerifField.js"></script>
<script type="text/javascript" src="<%= rootPath %>include/AjaxVerifField.js?v=<%= JavascriptVersionModula.VERIF_FIELD %>" ></script>
<%
	if(sAction.equals("store"))	
	{
%>
<%@ include file="/publisher_traitement/private/organisation/modifierPersonnePhysique.jspf" %>
<%
	}
%>
</head>
<body>
<%@ include file="/publisher_traitement/public/include/header.jspf" %>
<div class="titre_page"><%= sTitle  %></div>
<div class="tabFrame">
<%= Onglet.getAllTabsHtmlDesk(vOnglets)  %>
<div class="tabContent">
<%
	boolean bDisplayFormButton = false;
	boolean bDisplayButtonModify = false;

	if(( iIdOnglet == Onglet.ONGLET_PERSONNE_PHYSIQUE_DONNEES_ADMINISTRATIVES)
	|| ( iIdOnglet == Onglet.ONGLET_PERSONNE_PHYSIQUE_ADRESSE)
	|| ( iIdOnglet == Onglet.ONGLET_PERSONNE_PHYSIQUE_COMPTE_UTILISATEUR)
	|| ( iIdOnglet == Onglet.ONGLET_PERSONNE_PHYSIQUE_VEILLE_MARCHE)
	)
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
			"Redirect('afficherPersonnePhysique.jsp?")
			+ "pp="+sPPParamSecure
			+ "&amp;iIdOnglet=" + iIdOnglet 
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
	<form action="<%= response.encodeURL(rootPath + "publisher_traitement/private/organisation/modifierPersonnePhysique.jsp")%>" method="post" name="formulaire" onsubmit="return checkForm();">
	<div style="text-align:right">
	<input type="hidden" name="sAction" value="store" />
	<input type="hidden" name="iIdOnglet" value="<%= iIdOnglet  %>" />
	<input type="hidden" name="pp" value="<%= sPPParamSecure %>" />
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

	if( iIdOnglet == Onglet.ONGLET_PERSONNE_PHYSIQUE_DONNEES_ADMINISTRATIVES)
	{
		if(sAction.equals("store"))
		{
			%><%@ include file="/publisher_traitement/private/organisation/pave/pavePersonnePhysiqueInfosForm.jspf" %><%
		}
		else
		{
			%><%@ include file="/publisher_traitement/private/organisation/pave/pavePersonnePhysiqueInfos.jspf" %><%
		}
	}
	
	if( iIdOnglet == Onglet.ONGLET_PERSONNE_PHYSIQUE_ADRESSE)
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
	
	if( iIdOnglet == Onglet.ONGLET_PERSONNE_PHYSIQUE_COMPTE_UTILISATEUR)
	{
		if(sAction.equals("store"))
		{
			%><%@ include file="/publisher_traitement/private/organisation/pave/paveCompteUtilisateurForm.jspf" %><%
		}
		else
		{
			%><%@ include file="/publisher_traitement/private/organisation/pave/paveCompteUtilisateur.jspf" %><%
		}
	}
	

	if( bDisplayButtonModify)
	{
	%>
	<div style="text-align:right">
	<button 
		type="button" 
		onclick="<%= response.encodeURL(
			"Redirect('afficherPersonnePhysique.jsp?") 
			+ "pp="+sPPParamSecure
			+ "&amp;iIdOnglet=" + iIdOnglet 
			+ "&amp;sAction=store" %>');" >Modifier</button>
	</div>
	<br/>
<%
	}
	if( bDisplayFormButton)
	{
		hbFormulaire.bIsForm = true;
%>
	<br/>
	<div style="text-align:right">
		<button type="submit" >Valider</button>
	</div>
<%
	}
%>
</div>

<%@include file="/publisher_traitement/public/include/footer.jspf"%>
</body>

<%@page import="org.coin.util.HttpUtil"%>

<%@page import="mt.modula.JavascriptVersionModula"%></html>