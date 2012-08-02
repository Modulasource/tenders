<%@ include file="/include/new_style/headerDesk.jspf" %>
<%@page import="java.util.Vector"%>
<%@page import="org.coin.fr.bean.*"%>
<%@page import="org.coin.util.HttpUtil"%>
<%@ include file="include/localization.jspf" %>
<%
	
	Organisation organisation = Organisation.getOrganisation(HttpUtil.parseInt("lId", request));
	int iIdOnglet = HttpUtil.parseInt("iIdOnglet", request,0);


    String sTitle = "";
    sTitle = " <span class='altColor'>Admin paraph : "+organisation.getName() 
        	+ "</span>";

	Onglet.sNotCurrentTabStyle = " class='onglet_non_selectionne' "; 
	Onglet.sCurrentTabStyle =  " class='onglet_selectionne' ";
	Onglet.sNotCurrentTabStyleInCreation = " class='onglet_non_selectionne' ";
	Onglet.sCurrentTabStyleInCreation =  " class='onglet_selectionne' ";
	Onglet.sEnddingTabStyle =  " class='onglet_vide_dernier' ";

	String sURLParam = "&lId="+organisation.getId()+"&nonce=" + System.currentTimeMillis();
	Vector<Onglet> vOnglets = new Vector<Onglet>();
    vOnglets.add( new Onglet(0, false, locTab.getValue(1,"Utilisateurs"), response.encodeURL("displayOrganizationParaphAdmin.jsp?iIdOnglet="+0+sURLParam)) ); 
    vOnglets.add( new Onglet(1, false, locTab.getValue(2,"Documents"), response.encodeURL("displayOrganizationParaphAdmin.jsp?iIdOnglet="+1+sURLParam)) ); 
    vOnglets.add( new Onglet(2, false, locTab.getValue(3,"Signature numérique"), response.encodeURL("displayOrganizationParaphAdmin.jsp?iIdOnglet="+2+sURLParam)) ); 
    vOnglets.add( new Onglet(3, false, locTab.getValue(4,"Bon de commande"), response.encodeURL("displayOrganizationParaphAdmin.jsp?iIdOnglet="+3+sURLParam)) ); 
    vOnglets.add( new Onglet(4, false, locTab.getValue(5,"Divers"), response.encodeURL("displayOrganizationParaphAdmin.jsp?iIdOnglet="+4+sURLParam)) ); 
    vOnglets.add( new Onglet(5, false, locTab.getValue(6,"Poste électronique"), response.encodeURL("displayOrganizationParaphAdmin.jsp?iIdOnglet="+5+sURLParam)) ); 

	Onglet onglet = Onglet.getOnglet(vOnglets,iIdOnglet);
    onglet.bIsCurrent = true;
    
    String sPageUseCaseId = "IHM-DESK-xxx";
	
	sessionUserHabilitation.isHabilitateException(sPageUseCaseId );
%>
<script type="text/javascript">
var rootPath = "<%=rootPath%>";
mt.config.enableAutoRoundPave = false;

window.onload = function(){

	try{
	    var acLinkedFolder = new AjaxComboList("lIdParaphFolder", "getParaphFolderFromNameOrReference");
	} catch (e) {
	    //alert(e);
	}
}
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
	            response.encodeURL(rootPath 
	            		+ "desk/organisation/afficherOrganisation.jsp?iIdOrganisation="
	            				+ organisation.getId()),
	            rootPath+"images/icons/36x36/home.png", 
	            "",
	            "",
	            "",
	            "",
	            true) );
	
	
	out.write( BarBouton.getAllButtonHtmlDesk(vBarBoutons));

%>
</div>
</div>
<script type="text/javascript">
var menuBorder = RUZEE.ShadedBorder.create({corner:4, border:1});
Event.observe(window, 'load', function(){
    menuBorder.render($('menuBorder'));
});
</script>

<script type="text/javascript">
function displaySecretaries() {
	
	parent.addParentTabForced("Chargement ...","<%= response.encodeURL(
            rootPath + "desk/organisation/afficherOrganisation.jsp?iIdOrganisation=" + organisation.getId() 
                + "&iIdOnglet=" + Onglet.ONGLET_ORGANISATION_SERVICE
                + "&bDisplayOrganigramNode=true") %>");
    
}

function displayProofreaders() {
    
    parent.addParentTabForced("Chargement ...","<%= response.encodeURL(
            rootPath + "desk/organisation/afficherOrganisation.jsp?iIdOrganisation=" + organisation.getId() 
                + "&iIdOnglet=" + Onglet.ONGLET_ORGANISATION_SERVICE
                + "&bDisplayOrganigramNode=true") %>");
}

function displayIndividualList() {
    
    parent.addParentTabForced("Chargement ...","<%= response.encodeURL(
            rootPath + "desk/organisation/afficherOrganisation.jsp?iIdOrganisation=" + organisation.getId() 
                + "&iIdOnglet=" + Onglet.ONGLET_ORGANISATION_PERSONNES
                ) %>");
}


function displayAllOrganigramNodeType() {
    
    parent.addParentTabForced("Chargement ...","<%= response.encodeURL(
            rootPath + "desk/organisation/organigramme/displayAllOrganigramNodeType.jsp"
                ) %>");
}


function displayAllParaphFolder() {
    
    parent.addParentTabForced("Chargement ...","<%= response.encodeURL(
            rootPath + "desk/paraph/folder/displayAllParaphFolder.jsp"
                ) %>");
}


function displayAllParaphFolderFormTemplate() {
    
    parent.addParentTabForced("Chargement ...","<%= response.encodeURL(
            rootPath + "desk/organisation/paraph/displayAllParaphFolderFormTemplate.jsp"
                + "?lId=" + organisation.getId()) %>");
}


function displayAllPerson() {
    
    parent.addParentTabForced("Chargement ...","<%= response.encodeURL(
            rootPath + "desk/organisation/afficherOrganisation.jsp"
                + "?iIdOrganisation=" + organisation.getId()
                + "&iIdOnglet=" + Onglet.ONGLET_ORGANISATION_PERSONNES) %>");
}

function displayOrganigram() {
    
    parent.addParentTabForced("Chargement ...","<%= response.encodeURL(
            rootPath + "desk/organisation/afficherOrganisation.jsp"
                + "?iIdOrganisation=" + organisation.getId()
                + "&iIdOnglet=" + Onglet.ONGLET_ORGANISATION_SERVICE ) %>");
}


function openParaphFolderInputForm(sTitle, sAction)
{
    var sUrl = "<%= response.encodeURL(
    		rootPath + "desk/organisation/paraph/inputParaphFolderAdminForm.jsp"
    		+ "?sAction=" ) %>" + sAction;
    
    openModalIframe(null,sTitle, sUrl, "100px", "400px");
   
}

function openModalIframe(obj, sTitle, sUrl, height, width){
    var modal, div ;
    
    try{div = createModalIframe(obj,parent.document,sTitle, sUrl, height, width);}
    catch(e){div = createModalIframe(obj,document, sTitle, sUrl, height, width);}
    
    try {modal = new parent.Control.Modal(false,{contents: div});}
    catch(e) {modal = new Control.Modal(false,{contents: div});}

    modal.container.insert(div);
    modal.open();
}

function createModalIframe(obj, doc, sTitle, sUrl, height, width){
    
    var modal_princ = doc.createElement("div");
    var divControls = doc.createElement("div");
    divControls.className = "modal_controls";
        
    var divTitle = doc.createElement("div");
    divTitle.className = "modal_title";
    divTitle.innerHTML = sTitle;
    
    var img = doc.createElement("img");
    img.style.position = "absolute";
    img.style.top = "3px";
    img.style.right = "3px";
    img.style.cursor = "pointer";
    img.src = "<%= rootPath %>images/icons/close.gif";
    img.onclick = function(){
        try {new parent.Control.Modal.close();}
        catch(e) { Control.Modal.close();}
    }
    
    divControls.appendChild(divTitle);
    divControls.appendChild(img);
    
    var divFrame = doc.createElement("div");
    divFrame.className = "modal_frame_principal";

    var iframe = doc.createElement("iframe");
    iframe.name = "modifyAnnotation";
    iframe.id = "modifyAnnotation";
    iframe.src = sUrl;
    iframe.style.width = "100%";
    iframe.style.height = height;
    iframe.style.border = 0;
    iframe.style.margin = 0;
    iframe.align = "top";
    iframe.frameBorder = "0";
    iframe.border = "1";
    divFrame.appendChild(iframe);

    
    var divOptions = doc.createElement("div");
    divOptions.className = "modal_options";

    
    modal_princ.appendChild(divControls);
    modal_princ.appendChild(divFrame);
    modal_princ.appendChild(divOptions);
    modal_princ.style.width = width;
    
    return modal_princ;
}



</script>


<br />

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
			"Redirect('afficherOrganisation.jsp?lId=" + organisation.getId()) 
			+ "&iIdOnglet=" + iIdOnglet 
			+ "&sAction=store" %>');"><%= localizeButton.getValueModify() %></button>
	</div>
	<br/>
<%
	}
	
	
	if( bDisplayFormButton)
	{

		
%>
<form action="<%= response.encodeURL("modifyOrganizationParaphAdmin.jsp")
    %>" method="post" name="formulaire" id="formulaire" onsubmit="return checkForm();">
	<div align="right" >
	<input type="hidden" name="sAction" value="store" />
	<input type="hidden" name="iIdOnglet" value="<%= iIdOnglet  %>" />
	<input type="hidden" name="lId" value="<%= organisation.getId() %>" />
	
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
            <td class="pave_titre_gauche" colspan="2"><%=locTitle.getValue(1,"Fonctionnalités") %></td>
        </tr>
        <tr>
            <td class="pave_cellule_gauche">OK</td>
            <td class="pave_cellule_droite">
                <a href="javascript:void(0)" onclick="displayAllPerson()" ><%=locButton.getValue(1,"Gestion des utilisateurs") %></a>  
            </td>
        </tr>
        <tr>
            <td class="pave_cellule_gauche">OK</td>
            <td class="pave_cellule_droite">
                <a href="javascript:void(0)" onclick="displayOrganigram()" ><%=locButton.getValue(2,"Gestion de l'organigramme") %></a>  
            </td>
        </tr>
        <tr>
            <td class="pave_cellule_gauche">OK</td>
            <td class="pave_cellule_droite">
                <a href="javascript:void(0)" onclick="displaySecretaries()" ><%=locButton.getValue(3,"Gestion des secrétariats") %></a>  
            </td>
        </tr>
        <tr>
            <td class="pave_cellule_gauche">OK</td>
            <td class="pave_cellule_droite">
                <a href="javascript:void(0)" onclick="displayProofreaders()" ><%=locButton.getValue(4,"Gestion des correctrices") %></a>  
            </td>
        </tr>
        <tr>
            <td class="pave_cellule_gauche">OK</td>
            <td class="pave_cellule_droite">
                <a href="javascript:void(0)" onclick="displayAllOrganigramNodeType()" ><%=locButton.getValue(5,"Fonction des utilisateurs") %></a>  
            </td>
        </tr>
        <tr>
            <td class="pave_cellule_gauche">OK</td>
            <td class="pave_cellule_droite">
                <a href="javascript:void(0)" onclick="displayIndividualList()" ><%=locButton.getValue(6,"Détail d'un utilisateur") %></a>  
            </td>
        </tr>
    </table>
</div>

<%
	}
    
    if( iIdOnglet == 1)
    {
    	
    	String sButtonCaption = "";
%>
    <div>
    <table class="pave" >
        <tr>
            <td class="pave_titre_gauche" colspan="2"><%=locTitle.getValue(1,"Fonctionnalités") %></td>
        </tr>
        <tr><%sButtonCaption = locButton.getValue(7,"Supprimer un document");%>
            <td class="pave_cellule_gauche">OK</td>
            <td class="pave_cellule_droite">
                <a href="javascript:void(0)" onclick="openParaphFolderInputForm('<%=sButtonCaption %>','removeParaphFolder')" ><%=sButtonCaption %></a>  
            </td>
        </tr>
        <tr><%sButtonCaption = locButton.getValue(8,"Clôturer un document");%>
            <td class="pave_cellule_gauche">OK</td>
            <td class="pave_cellule_droite">
                <a href="javascript:void(0)" onclick="openParaphFolderInputForm('<%=sButtonCaption %>','updateState')" ><%=sButtonCaption %></a>  
            </td>
        </tr>
        <tr><%sButtonCaption = locButton.getValue(9,"Annulation dernière signature");%>
            <td class="pave_cellule_gauche">OK</td>
            <td class="pave_cellule_droite">
                <a href="javascript:void(0)" onclick="openParaphFolderInputForm('<%=sButtonCaption %>','removeLastParaph')" ><%=sButtonCaption %></a>  
            </td>
        </tr>
        <tr><%sButtonCaption = locButton.getValue(10,"Gestion des formulaires");%>
            <td class="pave_cellule_gauche"></td>
            <td class="pave_cellule_droite">
                <a href="javascript:void(0)" onclick="displayAllParaphFolderFormTemplate()" ><%=sButtonCaption %></a>  
            </td>
        </tr>
    </table>
</div>

<%
    }
	
    if( iIdOnglet == 2)
    {
%>
    <div>
    <table class="pave" >
        <tr>
            <td class="pave_titre_gauche" colspan="2"><%=locTitle.getValue(1,"Fonctionnalités") %></td>
        </tr>
        <tr>
            <td class="pave_cellule_gauche"></td>
            <td class="pave_cellule_droite"><%=locButton.getValue(11,"Gestion des fonds de page") %></td>
        </tr>
        <tr>
            <td class="pave_cellule_gauche"></td>
            <td class="pave_cellule_droite"><%=locButton.getValue(12,"Gestion des mots clés") %></td>
        </tr>
        <tr>
            <td class="pave_cellule_gauche"></td>
            <td class="pave_cellule_droite"><%=locButton.getValue(13,"Gestion des fusions") %></td>
        </tr>
    </table>
</div>

<%
    }
    
    if( iIdOnglet == 3)
    {
%>
    <div>
    <table class="pave" >
        <tr>
            <td class="pave_titre_gauche" colspan="2"><%=locTitle.getValue(1,"Fonctionnalités") %></td>
        </tr>
        <tr>
            <td class="pave_cellule_gauche"></td>
            <td class="pave_cellule_droite"><%=locButton.getValue(14,"Gestion des services finances") %></td>
        </tr>
        <tr>
            <td class="pave_cellule_gauche"></td>
            <td class="pave_cellule_droite"><%=locButton.getValue(15,"Services Parapheur - Services Finance") %></td>
        </tr>
        <tr>
            <td class="pave_cellule_gauche"></td>
            <td class="pave_cellule_droite"><%=locButton.getValue(16,"Accès aux services finances") %></td>
        </tr>
        <tr>
            <td class="pave_cellule_gauche"></td>
            <td class="pave_cellule_droite"><%=locButton.getValue(17,"Secrétariat gestionnaire finances") %></td>
        </tr>
    </table>
</div>

<%
    }
    
    if( iIdOnglet == 4)
    {
%>
    <div>
    <table class="pave" >
        <tr>
            <td class="pave_titre_gauche" colspan="2"><%=locTitle.getValue(1,"Fonctionnalités") %></td>
        </tr>
        <tr>
            <td class="pave_cellule_gauche"></td>
            <td class="pave_cellule_droite"><%=locButton.getValue(18,"Gestion des messages") %></td>
        </tr>

    </table>
</div>

<%
    }
  
    if( iIdOnglet == 5)
    {
%>
    <div>
    <table class="pave" >
        <tr>
            <td class="pave_titre_gauche" colspan="2"> Test Poste Electronique</td>
        </tr>
        <tr>
            <td class="pave_cellule_gauche">idnote </td>
            <td class="pave_cellule_droite">
                <input type="text" /><br/>
                
            <input type="hidden" 
                    id="lIdParaphFolder" 
                    name="lIdParaphFolder" />
            <button type="button" 
                    id="AJCL_but_lIdParaphFolder" 
                    name="AJCL_but_lIdParaphFolder"
                     ><%=locButton.getValue(19,"Sélectionner le dossier") %></button>                
            </td>
        </tr>
        <tr>
            <td class="pave_cellule_gauche">Poste Electronique </td>
            <td class="pave_cellule_droite">
                 <select name="maileva">
			        <option value="AC">Prise en compte par la Poste Electronique</option>
			        <option value="NAC">Non prise en compte par la Poste Electronique</option>
			        <option value="OK_YES">Remise en poste - Destinataire valide</option>
			        <option value="OK_BAD">Remise en poste - Destinataire non valide</option>
			      </select>
            </td>
		</tr>
       <tr>
            <td class="pave_cellule_gauche">Date - heure (jj/mm/aaaa hh:mm:ss) </td>
            <td class="pave_cellule_droite">
                 <input type="text" name="datemaileva" value="01/02/2009 20:53:51" />
            </td>
        </tr>
       <tr>
            <td class="pave_cellule_gauche"></td>
            <td class="pave_cellule_droite">
                <button type="submit" >Tester (TODO : voir la page testcourrier.asp)</button>
<br/>                
Lecture du fichier paramètre.<br/>
Remplacement des mots clés.<br/>
Ecriture du fichier.<br/>

                
            </td>
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