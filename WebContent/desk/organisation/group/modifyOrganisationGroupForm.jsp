<%@ include file="../../../include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.fr.bean.*,org.coin.bean.*" %>
<%@page import="org.coin.bean.html.HtmlBeanTableTrPave"%>
<%@page import="modula.graphic.Icone"%>
<%@page import="java.util.Vector"%>
<%
	String sTitle = "Modify organization";
	HtmlBeanTableTrPave hbFormulaire = new HtmlBeanTableTrPave();
	hbFormulaire.bIsForm = true;
	
	OrganisationGroup item = 
		OrganisationGroup.getOrganisationGroup(
				Long.parseLong(
					request.getParameter( "lIdOrganisationGroup")));
	
    Pays pays = new Pays();
    try{pays = Pays.getPaysMemory(item.getIdPays());}
    catch(Exception e){pays = new Pays();}

    pays.setAbstractBeanLocalization(sessionLanguage);
    
    String sPageUseCaseId = "IHM-DESK-ORG-GROUP-2"; 
	sessionUserHabilitation.isHabilitateException(sPageUseCaseId);
	
%>
<script type="text/javascript" src="<%= rootPath %>include/AjaxComboList.js?v=<%= JavascriptVersion.AJAX_COMBO_LIST_JS %>"></script>
<script type="text/javascript" src="<%=rootPath %>dwr/interface/OrganisationGroupItem.js"></script>
<script type="text/javascript" src="<%=rootPath %>dwr/interface/OrganisationGroupPersonnePhysique.js"></script>
<script type="text/javascript">
function associateAll(){
    if(isNotNull('<%= item.getIdPays() %>')){
    
        if(confirm("Do you want to associate all business unit of <%=pays.getName()%> ?")){
            location.href = '<%=response.encodeRedirectURL(rootPath 
                + "desk/organisation/group/modifyOrganisationGroupItem.jsp?sAction=createFromCountry&lIdOrganisationGroup="
                        + item.getId()) %>';
        }
    }else{
        alert("this group have not country defined");
    }
}

function removeBU(id){
     if(confirm("Do you want to remove this business unit of <%=item.getName()%> Group ?")){
         location.href = '<%=response.encodeRedirectURL(rootPath 
             + "desk/organisation/group/modifyOrganisationGroupItem.jsp?") %>sAction=remove&lIdOrganisationGroupItem='+id;
     }
}

function removeHQ(id){
     if(confirm("Do you want to remove this HQ Collaborator of <%=item.getName()%> Group ?")){
         location.href = '<%=response.encodeRedirectURL(rootPath 
             + "desk/organisation/group/modifyOrganisationGroupPersonnePhysique.jsp?") %>sAction=remove&lIdOrganisationGroupPersonnePhysique='+id;
     }
}

function onSelectBU(sIdSelect, bShowId){
    var l = document.getElementById(sIdSelect);
    if(l.options.selectedIndex>=0){
        var sValue = "";
        if(bShowId=="true"){
            sValue = l.options[l.options.selectedIndex].value;
        }
        else {
            sValue =l.options[l.options.selectedIndex].text;
        }
        if(confirm("Do you want to associate "+sValue+" business unit ?" )){
            var idOrg = l.options[l.options.selectedIndex].value;
            OrganisationGroupItem.notExistItem(idOrg,<%= item.getId()%>,function() { 
                    location.href = "<%=response.encodeURL("modifyOrganisationGroupItem.jsp?")%>sAction=create&lIdOrganisationGroup=<%= item.getId()%>&lIdOrganisation="+idOrg;
               });
        }
    }
}

function onSelectHQ(sIdSelect, bShowId){
    var l = document.getElementById(sIdSelect);
    if(l.options.selectedIndex>=0){
        var sValue = "";
        if(bShowId=="true"){
            sValue = l.options[l.options.selectedIndex].value;
        }
        else {
            sValue =l.options[l.options.selectedIndex].text;
        }
        if(confirm("Do you want to associate "+sValue+" HQ Collaborator ?" )){
            var idPP = l.options[l.options.selectedIndex].value;
            OrganisationGroupPersonnePhysique.notExistItem(idPP,<%= item.getId()%>,function() { 
                    location.href = "<%=response.encodeURL("modifyOrganisationGroupPersonnePhysique.jsp?")%>sAction=create&lIdOrganisationGroup=<%= item.getId()%>&lIdPersonnePhysique="+idPP;
               });
        }
    }
}

onPageLoad = function(){
    var acBU = new AjaxComboList("lIdBU", "getRaisonSocialeVeolia","left");
    acBU.defineSelectSpecificAction = function(){
        $(acBU.sIdSelect).onchange = function(){
            onSelectBU(acBU.sIdSelect,acBU.bShowId);
        }
    }
    
    var acHQ = new AjaxComboList("lIdHQ", "getPersonnePhysiqueAllType","left");
    acHQ.defineSelectSpecificAction = function(){
        $(acHQ.sIdSelect).onchange = function(){
            onSelectHQ(acHQ.sIdSelect,acHQ.bShowId);
        }
    }
}
</script>
</head>
<body>
<%@ include file="../../../include/new_style/headerFiche.jspf" %>
<br/>
<div style="padding:15px">
<form name="formulaire" method="post" action="<%=response.encodeURL("modifyOrganisationGroup.jsp")%>" >
<input type="hidden" name="lIdOrganisationGroup" value="<%= item.getId() %>" />
<input type="hidden" name="sAction" value="store" />
<table class="pave" >
	<tr>
		<td class="pave_titre_gauche" colspan="2">Group : <%= item.getName() %></td>
	</tr>
	<%= hbFormulaire.getHtmlTrInput("Name :","sName",item.getName(), " size='80' " ) %>
	<tr>
        <td class="pave_cellule_gauche" >Country Restriction :</td>
        <td class="pave_cellule_droite" >
        <%	System.out.println("BOBO"); %>
            <%= pays.getAllInHtmlSelect("sIdPays") %>
             <%	System.out.println("ABA"); %>
        </td>
    </tr>
    <%= hbFormulaire.getHtmlTrInput("External Reference :","sExternalReference",Outils.isNullOrBlank(item.getExternalReference())?"":item.getExternalReference(), " size='80' " ) %>
	<tr>
		<td class="pave_cellule_gauche" >Description :</td>
		<td class="pave_cellule_droite" >
			<textarea rows="5" cols="80" name="sDescription"><%= item.getDescription() %></textarea>
		</td>
	</tr>
	<tr>
		<td class="pave_cellule_gauche" >Creation date :</td>
		<td class="pave_cellule_droite" >
			<%= item.getDateCreation() %>
		</td>
	</tr>
			<tr>
		<td class="pave_cellule_gauche" >Last modification date :</td>
		<td class="pave_cellule_droite" >
			<%= item.getDateModification() %>
		</td>
	</tr>
	
</table>
<br/>
<div align="center">
	<button type="submit" name="submit" >Valid</button>
	&nbsp;
	<button type="button"  
		onclick="Redirect('<%=response.encodeRedirectURL(rootPath 
				+ "desk/organisation/group/displayAllOrganisationGroup.jsp") %>')" 
		>Cancel</button>
</div>
</form>
<br/>
<%
	Vector<OrganisationGroupItem> vOrganisationGroupItem 
		= OrganisationGroupItem.getAllFromIdOrganisationGroup(item.getId());
	
%>
<div id="search">
    <div class="searchTitle">
        <div id="infosSearchLeft" style="float:left">Business Unit associated</div>
        <div id="infosSearchRight" style="float:right;text-align:right;">
        <button type="button" id="AJCL_but_lIdBU" 
            class="<%= CSS.DESIGN_CSS_MANDATORY_CLASS %>" >Associate a new Business Unit</button>
        <button type="button"  
        onclick="associateAll()" 
        >Associate All From Country Restriction</button>
        </div>
        <div style="clear:both"></div>
    </div>
    <table class="dataGrid fullWidth" cellspacing="1">
        <tbody>
            <tr class="header">
                    <td class="cell">Name</td>
                    <td class="cell">Country</td>
                    <td class="cell">City</td>
                    <td class="cell">Phone number</td>
                    <td class="cell">&nbsp;</td>
            </tr>            
            <%
		    for(int i = 0; i < vOrganisationGroupItem.size(); i++)
		    {
		        OrganisationGroupItem bean = vOrganisationGroupItem.get(i);
		        Organisation orga = Organisation.getOrganisation((int)bean.getIdOrganisation());
		        Adresse adr = Adresse.getAdresse(orga.getIdAdresse());
		      %>
                <tr class="line<%=i%2%>" > 
                    <td class="cell" style="width:40%">
                        <a href="<%= response.encodeURL(
                                rootPath +  "desk/organisation/afficherOrganisation.jsp?iIdOrganisation=" 
                                        + orga.getIdOrganisation()) %>">
                            <%= orga.getRaisonSociale() %>
                        </a>
                    </td>
                    <td class="cell" style="width:20%"><%= adr.getIdPays() %></td>
                    <td class="cell" style="width:20%"><%= adr.getCommune() %></td>
                    <td class="cell" style="width:10%"><%= orga.getTelephone() %></td>
                    <td class="cell" style="text-align:right;width:5%">
                        <a href="javascript:removeBU(<%= bean.getId() %>)">
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
<br/>
<%
    Vector<OrganisationGroupPersonnePhysique> vOrganisationGroupPP 
        = OrganisationGroupPersonnePhysique.getAllFromIdOrganisationGroup(item.getId());
    
%>
<div id="search">
    <div class="searchTitle">
        <div id="infosSearchLeft" style="float:left">HQ Collaborators associated</div>
        <div id="infosSearchRight" style="float:right;text-align:right;">
        <button type="button" id="AJCL_but_lIdHQ" 
            class="<%= CSS.DESIGN_CSS_MANDATORY_CLASS %>" >Associate a new HQ Collaborator</button>
        </div>
        <div style="clear:both"></div>
    </div>
    <table class="dataGrid fullWidth" cellspacing="1">
        <tbody>
            <tr class="header">
                <td class="cell">Name</td>
                <td class="cell">Function</td>
                <td class="cell">E-mail</td>
                <td class="cell">Head Quarter</td>
                <td class="cell">&nbsp;</td>
            </tr>      
            <%
	        for (int i = 0; i < vOrganisationGroupPP.size(); i++)
	        {
	        	OrganisationGroupPersonnePhysique bean = vOrganisationGroupPP.get(i);
	            PersonnePhysique personne = PersonnePhysique.getPersonnePhysique(bean.getIdPersonnePhysique());
	            Organisation orgPersonne = Organisation.getOrganisation(personne.getIdOrganisation());
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
				    <td class="cell" style="width:25%"><%= orgPersonne.getRaisonSociale() %></td>
				    <td class="cell" style="text-align:right;width:5%">
				        <a href="javascript:removeHQ(<%= bean.getId() %>)">
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

</div>


<%@ include file="../../../include/new_style/footerFiche.jspf" %>
</body>


<%@page import="org.coin.util.Outils"%></html>