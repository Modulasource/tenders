<%@ include file="/include/new_style/headerDesk.jspf" %>
<%@page import="java.util.Vector"%>
<%@page import="org.coin.fr.bean.*"%>
<%@page import="org.coin.util.HttpUtil"%>

<%
	
	PersonnePhysique personne = PersonnePhysique.getPersonnePhysique(HttpUtil.parseInt("lId", request));
	int iIdOnglet = HttpUtil.parseInt("iIdOnglet", request,0);


    String sTitle = "";
    if(sessionUser.getIdIndividual() == personne.getIdPersonnePhysique())
        sTitle = personne.getCivilitePrenomNomOptional() ;
    else
        sTitle = " <span class='altColor'>"+personne.getCivilitePrenomNomOptional() 
        	+ "</span>";

	Onglet.sNotCurrentTabStyle = " class='onglet_non_selectionne' "; 
	Onglet.sCurrentTabStyle =  " class='onglet_selectionne' ";
	Onglet.sNotCurrentTabStyleInCreation = " class='onglet_non_selectionne' ";
	Onglet.sCurrentTabStyleInCreation =  " class='onglet_selectionne' ";
	Onglet.sEnddingTabStyle =  " class='onglet_vide_dernier' ";

	String sURLParam = "&lId="+personne.getId()+"&nonce=" + System.currentTimeMillis();
	Vector<Onglet> vOnglets = new Vector<Onglet>();
    vOnglets.add( new Onglet(0, false, "Général", response.encodeURL("displayIndividualParaphAdmin.jsp?iIdOnglet="+0+sURLParam)) ); 
    vOnglets.add( new Onglet(1, false, "Mon profil", response.encodeURL("displayIndividualParaphAdmin.jsp?iIdOnglet="+1+sURLParam)) ); 
 
	Onglet onglet = Onglet.getOnglet(vOnglets,iIdOnglet);
    onglet.bIsCurrent = true;
    
    String sPageUseCaseId = "IHM-DESK-xxx";
	
	sessionUserHabilitation.isHabilitateException(sPageUseCaseId );
%>
<script type="text/javascript">
var rootPath = "<%=rootPath%>";
mt.config.enableAutoRoundPave = false;
</script>
</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<br/>
<div id="menuBorder" class="sb" style="padding:3px 10px 3px 10px;margin:0 20px 0 20px;">
    <div class="fullWidth">
<%
	Vector<BarBouton> vBarBoutons = new Vector<BarBouton>();
	
	
	vBarBoutons.add( 
	        new BarBouton(5,
	            "Retour ",
	            response.encodeURL(rootPath + "desk/organisation/afficherPersonnePhysique.jsp?iIdPersonnePhysique=" + personne.getIdPersonnePhysique()),
	            rootPath+"images/icons/36x36/user_male.png", 
	            "",
	            "",
	            "",
	            "",
	            true) );
	
	
	out.write( BarBouton.getAllButtonHtmlDesk(vBarBoutons));

%>
</div>
</div>
<script>
var menuBorder = RUZEE.ShadedBorder.create({corner:4, border:1});
Event.observe(window, 'load', function(){
    menuBorder.render($('menuBorder'));
});
</script>
<br />

page en réflexion ... voir plutôt celle de l'organisation

<div class="tabFrame">
<%= Onglet.getAllTabsHtmlDesk(vOnglets) %>
<div class="tabContent">
<%
	boolean bDisplayFormButton = false;
	boolean bDisplayButtonModify = false;
	
	if( bDisplayButtonModify)
	{
	%>
	<div align="right" >
	<button 
		type="button" 
		onclick="<%= response.encodeURL(
			"Redirect('afficherPersonnePhysique.jsp?lId=" + personne.getIdPersonnePhysique()) 
			+ "&iIdOnglet=" + iIdOnglet 
			+ "&sAction=store" %>');"><%= localizeButton.getValueModify() %></button>
	</div>
	<br/>
<%
	}
	
	
	if( bDisplayFormButton)
	{

		
%>
<form action="<%= response.encodeURL("modifyIndividualParaphAdmin.jsp")%>" method="post" name="formulaire" id="formulaire" onsubmit="return checkForm();">
	<div align="right" >
	<input type="hidden" name="sAction" value="store" />
	<input type="hidden" name="iIdOnglet" value="<%= iIdOnglet  %>" />
	<input type="hidden" name="lId" value="<%= personne.getId() %>" />
	
	<button type="submit"><%= localizeButton.getValueSubmit() %></button>
	</div>
	<br/>
	<%
	}

	
	
    if( iIdOnglet == 0)
    {
%>
	<div>
    <table class="pave" >
        <tr>
            <td class="pave_titre_gauche" colspan="2"> Fonctionnalités</td>
        </tr>
        <tr>
            <td class="pave_cellule_gauche"><input type="checkbox" /></td>
            <td class="pave_cellule_droite">Créer une note ??</td>
        </tr>
        <tr>
            <td class="pave_cellule_gauche"><input type="checkbox" /></td>
            <td class="pave_cellule_droite">Envoyer une note ??</td>
        </tr>
    </table>
</div>

<%
	}
    
    
    if( iIdOnglet == 1)
    {
%>
	<div>
    <table class="pave" >
        <tr>
            <td class="pave_titre_gauche" colspan="2">Mon profil </td>
        </tr>
        <tr>
            <td class="pave_cellule_gauche"><input type="checkbox" /></td>
            <td class="pave_cellule_droite">Ne plus recevoir de mails de notifications (TODO)</td>
        </tr>
        <tr>
            <td class="pave_cellule_gauche"><input type="checkbox" /></td>
            <td class="pave_cellule_droite">Désactiver le mode en ligne sans notifications (TODO)</td>
        </tr>
    </table>
</div>

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
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
</html>