<%@ include file="../../../include/new_style/headerDesk.jspf" %>

<%@page import="org.coin.util.HttpUtil"%>
<%@page import="org.coin.bean.html.HtmlBeanTableTrPave"%>
<%@page import="org.coin.fr.bean.OrganisationDepot"%>
<%@page import="org.coin.fr.bean.Adresse"%>
<%@page import="org.coin.fr.bean.Pays"%>
<%@page import="org.coin.fr.bean.Organisation"%>
<%@page import="modula.graphic.Onglet"%>
<%@page import="java.util.Vector"%>
<%@page import="org.coin.fr.bean.PersonnePhysique"%>
<%@page import="org.coin.fr.bean.OrganisationDepotPersonnePhysique"%>
<%@page import="modula.graphic.Icone"%>
<%@page import="org.coin.fr.bean.OrganisationGroupPersonnePhysique"%>
<%@ include file="../pave/localizationObject.jspf" %>
<%
	HtmlBeanTableTrPave hbFormulaire = new HtmlBeanTableTrPave();
	hbFormulaire.bIsForm = false;

    String sAction = HttpUtil.parseString("sAction",request,"");
    long lIdOrganisationDepot = HttpUtil.parseLong("lIdOrganisationDepot",request,0);
    long lIdOrganisation = HttpUtil.parseLong("lIdOrganisation",request,0);
    
    PersonnePhysique personneUser = PersonnePhysique.getPersonnePhysique(sessionUser.getIdIndividual());
    Organisation org = null;
    OrganisationDepot depot = null;
    Adresse adresse = null;
    Pays pays = null;
	
    if(sAction.equalsIgnoreCase("create")){
    	hbFormulaire.bIsForm = true;
    	depot = new OrganisationDepot();
    	depot.setName(localizeButton.getValue(62,"New")+" "+locTitle.getValue(31,"Location"));
    	depot.setIdOrganisation(lIdOrganisation);
    	
    	org = Organisation.getOrganisation(lIdOrganisation);
    	adresse = Adresse.getAdresse(org.getIdAdresse());
    	
    	/** 
    	 * Pour en créée une nouvelle à partie de l'organisation
    	 */
    	adresse.setId(0);
    }else{
    	depot = OrganisationDepot.getOrganisationDepot(lIdOrganisationDepot);
    	org = Organisation.getOrganisation(depot.getIdOrganisation());
    	
    	try {
        	 adresse = Adresse.getAdresse((int)depot.getIdAdresse());
        } catch (CoinDatabaseLoadException e) {
        	 adresse = new Adresse();
        	 adresse.setAdresseLigne1("Attention pas d'adresse en bdd !!!");
        }
    }
    
	pays = Pays.getPaysMemory(adresse.getIdPays());
   
    
   
    adresse.setAbstractBeanLocalization(sessionLanguage);
    pays.setAbstractBeanLocalization(sessionLanguage);
    depot.setAbstractBeanLocalization(sessionLanguage);
    personneUser.setAbstractBeanLocalization(sessionLanguage);
    
    if(sAction.equalsIgnoreCase("store")){
    	hbFormulaire.bIsForm = true;
    }
    
    String sTitle = locTitle.getValue(31,"Location")+" : <span class='altColor'>"+depot.getName() +"</span>";
    String sPaveAdresseTitre = locTabs.getValue(3,"General address");
    String sFormPrefix = "";
    
    boolean bDisplayRemoveButton = false;
    if(sessionUserHabilitation.isHabilitate("IHM-DESK-ORG-DEPOT-4" ))
    {
    	bDisplayRemoveButton = true;
    	
    } else if(sessionUserHabilitation.isHabilitate("IHM-DESK-ORG-DEPOT-11" )
        && OrganisationGroupPersonnePhysique.isOrganisationHerarchical(
        		personneUser, 
        		org)){
        bDisplayRemoveButton = true;
        
    } else if (sessionUserHabilitation.isHabilitate("IHM-DESK-ORG-DEPOT-6" )
    		&& personneUser.getIdOrganisation() == org.getId()) {
    	bDisplayRemoveButton = true;
    }
%>
<script type="text/javascript" src="<%= rootPath %>include/AjaxComboList.js?v=<%= JavascriptVersion.AJAX_COMBO_LIST_JS %>"></script>
<script type="text/javascript" src="<%=rootPath %>dwr/interface/OrganisationDepotPersonnePhysique.js"></script>
<script type="text/javascript">
function removeLocation(){
    if(confirm("<%= locMessage.getValue(24,"Do you want to delete %1 Location ?").replaceAll("%1",depot.getName()) %>")){
        location.href='<%= response.encodeURL(
            "modifyOrganisationDepot.jsp?lIdOrganisation=" + depot.getIdOrganisation() 
            + "&lIdOrganisationDepot=" + depot.getId() 
            + "&sAction=remove") %>';
    }
}
function removePersonnel(id){
     if(confirm("<%= locMessage.getValue(25,"Do you want to remove this collaborator of %1 Location ?").replaceAll("%1",depot.getName()) %>")){
         location.href = '<%=response.encodeRedirectURL( 
             "modifyOrganisationDepot.jsp?") %>sAction=removePP&lIdOrganisationDepot=<%= depot.getId() %>&lIdOrganisationDepotPersonnePhysique='+id;
     }
}
function onSelectPP(sIdSelect, bShowId){
    var l = document.getElementById(sIdSelect);
    if(l.options.selectedIndex>=0){
        var sValue = "";
        if(bShowId=="true"){
            sValue = l.options[l.options.selectedIndex].value;
        }
        else {
            sValue =l.options[l.options.selectedIndex].text;
        }
        var msg = "<%= locMessage.getValue(26,"Do you want to associate %1 ?") %>";
        msg = msg.replace("%1", sValue);
        if(confirm(msg)){
            var idPP = l.options[l.options.selectedIndex].value;
            OrganisationDepotPersonnePhysique.notExistItem(idPP,<%= depot.getId()%>,function() { 
                location.href = "<%=response.encodeURL("modifyOrganisationDepot.jsp?")%>sAction=createPP&lIdOrganisationDepot=<%= depot.getId()%>&lIdPersonnePhysique="+idPP;
            });
        }
    }
}
onPageLoad = function(){
    <% if(!sAction.equalsIgnoreCase("create")){%>    
    var ac = new AjaxComboList("addPP", "getOrganisationDepotPersonnePhysique_<%= depot.getIdOrganisation() %>","left");
    ac.defineSelectSpecificAction = function(){
        $(ac.sIdSelect).onchange = function(){
            onSelectPP(ac.sIdSelect,ac.bShowId);
        }
    }
    <%}%>
}
</script>
</head>
<body>
<%@ include file="../../../include/new_style/headerFiche.jspf" %>
<div style="padding:15px">
<form action="<%= response.encodeURL("modifyOrganisationDepot.jsp")%>" method="post">
    <input type="hidden" name="sAction" value="<%= sAction %>" />
    <input type="hidden" name="lIdOrganisation" value="<%= depot.getIdOrganisation()  %>" />
    <input type="hidden" name="lIdOrganisationDepot" value="<%= depot.getId()  %>" />
    
	<table class="pave" summary="none">
	    <tr>
	        <td class="pave_titre_gauche" colspan="2"><%= locTabs.getValue(1,"Administrative data") %></td>
	    </tr>
	    <tr><td colspan="2">&nbsp;</td></tr>
	    <% 
	    OrganisationDepotType depotType = new OrganisationDepotType(); 
	    try{depotType = OrganisationDepotType.getOrganisationDepotTypeMemory(depot.getIdOrganisationDepotType());}
	    catch(Exception e){}
	    %>
        <%= hbFormulaire.getHtmlTrInput(depot.getNameLabel()+" :","sName",depot.getName(),"") %>
        <%= hbFormulaire.getHtmlTrSelect(depot.getIdOrganisationDepotTypeLabel()+" :", "lIdOrganisationDepotType",depotType) %>
        <%= hbFormulaire.getHtmlTrInput(depot.getReferenceLabel()+" :","sReference",depot.getReference(),"") %>
        <%= hbFormulaire.getHtmlTrInput(depot.getEmailLabel()+" :","sEmail",depot.getEmail(),"") %>
        <%= hbFormulaire.getHtmlTrInput(depot.getPhoneLabel()+" :","sPhone",depot.getPhone(),"") %>
        <%= hbFormulaire.getHtmlTrInput(depot.getFaxLabel()+" :","sFax",depot.getFax(),"") %>

	    <tr><td colspan="2">&nbsp;</td></tr>
	</table>
	<br/>
	<%if(hbFormulaire.bIsForm){try{ %>
    <%@ include file="../pave/paveAdresseForm.jspf" %>
    <%}catch(Exception e){e.printStackTrace();}}else{ %>
    <%@ include file="../pave/paveAdresse.jspf" %>
    <%} %>
    
    <% if(!sAction.equalsIgnoreCase("create")){ %>
    <br/>
    <div id="search">
	    <div class="searchTitle">
	        <div id="infosSearchLeft" style="float:left"><%= locBloc.getValue(10,"Location collaborators") %></div>
	        <div id="infosSearchRight" style="float:right;text-align:right;">
	        <button type="button" id="AJCL_but_addPP" 
            class="<%= CSS.DESIGN_CSS_MANDATORY_CLASS %>" ><%= locAddressBookButton.getValue(32,"Associate a new Location Personnel") %></button>
	        </div>
	        <div style="clear:both"></div>
	    </div>
	    <table class="dataGrid fullWidth" cellspacing="1">
	        <tbody>
	            <tr class="header">
	                <td class="cell"><%= personneUser.getNomLabel() %></td>
	                <td class="cell"><%= personneUser.getFonctionLabel() %></td>
	                <td class="cell"><%= personneUser.getEmailLabel() %></td>
	                <td class="cell"><%= depot.getIdOrganisationLabel() %></td>
	                <td class="cell">&nbsp;</td>
	            </tr>
	                        
	        <%
	        Vector<OrganisationDepotPersonnePhysique> vPersonnes = OrganisationDepotPersonnePhysique.getAllFromDepot(depot.getId());
	        for (int i = 0; i < vPersonnes.size(); i++)
	        {
	            PersonnePhysique personne = PersonnePhysique.getPersonnePhysique(vPersonnes.get(i).getIdPersonnePhysique());
	            int j = i % 2;
	            %>
	            <tr class="line<%=j %>" > 
                    <td class="cell" style="width:25%">
                     <a href="<%= response.encodeURL(
                                rootPath +  "desk/organisation/afficherPersonnePhysique.jsp?iIdPersonnePhysique=" 
                                        + personne.getId()) %>">
                            <%= personne.getPrenomNom() %>
                        </a>
                    </td>
                    <td class="cell" style="width:20%"><%= personne.getFonction() %></td>
                    <td class="cell" style="width:25%"><a href="mailto:<%= personne.getEmail() %>" target="_blank"><%= personne.getEmail() %></a></td>
                    <td class="cell" style="width:25%"><%= org.getRaisonSociale() %></td>
                    <td class="cell" style="text-align:right;width:5%">
                        <a href="javascript:removePersonnel(<%= vPersonnes.get(i).getId() %>)">
                        <img src="<%= rootPath+ Icone.ICONE_SUPPRIMER_NEW_STYLE%>" alt="Delete" title="Delete"/>
                        </a>
                    </td>
                </tr>
	        <%
	        }
	        %>
	        </tbody>
	    </table>
	</div>
    <%} %>
    
     <br/>
    <div id="fiche_footer" >
<% if(hbFormulaire.bIsForm ){ %>
    <button type="submit"><%= localizeButton.getValueSave() %></button>
<%} %>
<% if(!hbFormulaire.bIsForm){%>
    <button 
        type="button"
        onclick="location.href='<%= response.encodeURL(
            "displayOrganisationDepot.jsp?lIdOrganisation=" + depot.getIdOrganisation() 
            + "&lIdOrganisationDepot=" + depot.getId() 
            + "&sAction=store") %>';"><%= localizeButton.getValueModify() %></button>
<% } %>
<% if(!sAction.equalsIgnoreCase("create") && bDisplayRemoveButton ){ %>
     <button type="button" onclick="removeLocation()"><%= localizeButton.getValueDelete() %></button>
<% } %>

    <button 
    type="button"
    onclick="location.href='<%= response.encodeURL(rootPath +
        "desk/organisation/afficherOrganisation.jsp?iIdOrganisation=" + depot.getIdOrganisation()
        		+ "&iIdOnglet="+Onglet.ONGLET_ORGANISATION_DEPOTS) %>';">
        <%= localizeButton.getValueCancel() %></button>
    </div>
    
</form>

<%@ include file="../../../include/new_style/footerFiche.jspf" %>
</body>
<%@page import="org.coin.db.CoinDatabaseLoadException"%>

<%@page import="org.coin.fr.bean.OrganisationDepotType"%></html>