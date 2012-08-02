<%@ include file="/include/new_style/headerPublisher.jspf" %>
<%@ page import="org.coin.bean.html.*,org.coin.fr.bean.*" %>
<%@page import="mt.modula.JavascriptVersionModula"%>
<%@page import="mt.modula.affaire.cpf.CodeCpfGroup"%>
<%@page import="org.coin.bean.boamp.BoampCPF"%>
<%@ include file="/publisher_traitement/public/include/beanCandidat.jspf" %>
<% 
	String sFormPrefix = "";
	String sTitle = "Inscription de mon entreprise";
	session.setAttribute("sessionAction", "ajouterEntrepriseForm");
	if (session.isNew() )
	{
		System.out.println("La session n'a pas démarré correctement");
	}
	String sUseCaseIdEntreprise = "IHM-PUBLI-CDT-002";
	String sUseCaseIdGerant = "IHM-PUBLI-CDT-004";
	String sPageUseCaseId = "IHM-PUBLI-CDT-002";
	
	HtmlBeanTableTrPave hbFormulaire = new HtmlBeanTableTrPave();
	hbFormulaire.bIsForm = true;
%>
<script type="text/javascript" src="<%=rootPath %>dwr/interface/CheckAjaxVerifField.js"></script>
<script type="text/javascript" src="<%=rootPath %>include/bascule.js"></script>
<script type="text/javascript" src="<%= rootPath %>include/AjaxVerifField.js?v=<%= JavascriptVersionModula.VERIF_FIELD %>" ></script>
<script type="text/javascript">
<%@ include file="/publisher_traitement/public/organisation/ajouterEntreprise.jspf" %>
</script>
<script type="text/javascript">
<!--



onPageLoad = function() {
		
	try {checkForm();} catch(e) {}

    $("divError").innerHTML = "";
    g_inputBackgroundColorHighlightOn = "#FF7B7B";
    g_inputBackgroundColorHighlightOff = "#FFF";
    
<%
    if(session.getAttribute("sMessageErreur") != null
    && !((String)session.getAttribute("sMessageErreur")).equalsIgnoreCase(""))
    {
%>
    try {showLoginBox(); } catch(e) {}
<%
    }
%>
}

//-->
</script>
<%@ include file="/publisher_traitement/public/include/redirectOnLoad.jspf" %>

</head>
<body onload="cacher('divArticle');"  >
<%@ include file="/publisher_traitement/public/include/header.jspf" %>

<%
/**
 * il faut les laisser ici sinon on a des pointeurs NULL
 */
	organisation = new Organisation();
	candidat = new PersonnePhysique();
%>

<br />

<form action="<%= response.encodeURL(rootPath + "publisher_traitement/public/organisation/ajouterEntreprise.jsp")
%>" method="post" 
    enctype="application/x-www-form-urlencoded" name="formulaire" onsubmit="return checkForm();">



<a name="ancreError">&nbsp;</a>
<div class="rouge" style="text-align:left" id="divError"></div>


<%

//if(Configuration.isEnabledMemory("modula.publisher.subscription.form.specific", false))
{

%>


<div style="padding:20px;">
    <div class="post" style="padding:10px;" >
        <div class="post-title" >
            <div class="post-title-alt" ><%= sTitle %></div>
        </div>
<%
	//Vector<BoampCPF> vCompetences = BoampCPF.getAllStaticMemory();
	Vector<CodeNaf> vCodeNaf = CodeNaf.getAllCodeNafValide();
		
    Vector<BoampCPFItem> vCompetencesOrganisationLibrary = BoampCPFItem.getAllFromTypeAndReferenceObjet(ObjectType.ORGANISATION, organisation.getIdOrganisation());
	Vector<BoampCPF> vCompetencesOrganisation = new Vector<BoampCPF>();
	for(BoampCPFItem itemOrg : vCompetencesOrganisationLibrary){
		vCompetencesOrganisation.add(BoampCPF.getBoampCPFMemory(itemOrg.getIdOwnedObject()));
	}
	Vector<BoampCPF> vCompetences = BoampCPF.getAllStaticMemory();
%>
		<table>
<%@ include file="/publisher_traitement/public/organisation/pave/paveEntrepriseForm.jspf" %>
<%@ include file="/publisher_traitement/public/organisation/pave/paveGerantForm.jspf" %> 
		</table>  

<!-- 
<%

/**
 * TODO_AG : added departement and CodeCpfGroup
 */

%>		
	    <div class="post-title" >
            <div class="post-title-alt" >Veille de marchés : Choisissez parmi les activités
             et les départements suivants</div>
        </div>	
        <table>
		    <tr><td colspan="2">&nbsp;</td></tr>
		    <tr >
		        <td class="pave_cellule_droite" colspan="3">
		              Un à trois domaines d'activités 
		            <div class="rouge" style="text-align:left">
                        Pour choisir plusieurs activités ou département dans la liste , maintenez 
                        la touche [Control] ou	[CTRL] enfoncée.
		            </div>
		            <br/>
		        </td>
		    </tr>
		    <tr>
                  <td ><b>Domaines d'activités</b><font color="#ff0000">*</font></td>
                  <td style="width: 20px" >&nbsp;</td>
                  <td ><b>Départements</b><font color="#ff0000">*</font></td>
            </tr>
		    <tr>
                  <td >
<%
	Vector<CodeCpfGroup> vCodeCpfGroup =  CodeCpfGroup.getAllStaticMemory(false);
%>
                   <select name="listCodeCpfGroup" id="listCodeCpfGroup" multiple="multiple" size="12" style="width: 250px"  >
<%
	for(CodeCpfGroup codeCpfGroup  : vCodeCpfGroup )
	{
		   %><option value="<%= codeCpfGroup.getId() %>" ><%= codeCpfGroup.getName() %></option>
		   <%	
	}
%>
				   </select>
			      </td>
                  <td>&nbsp;</td>
                  <td >
<%
    Vector<Departement> vDepartement =  Departement.getAllStaticMemory(false);
%>                  
                  <select name="listDepartement" id="listDepartement" multiple="multiple" size="12" style="width: 250px" >
<%
	String[] sarrAllowedDepartement 
	   = {"01", "04", "05", "06", "07", "13", "26", "38",
		  "42", "69", "73", "74", "83", "84" };

    for(Departement departementTmp  : vDepartement )
    {
    	boolean isDeptAllowed = false;
        for(String sDeptAllowed : sarrAllowedDepartement )
        {
        	if(sDeptAllowed.equals(departementTmp.getIdString())) {
        		isDeptAllowed = true;
        		break;
        	}
        }
        
        if(isDeptAllowed)
        {
           %><option value="<%= departementTmp.getIdString() %>" ><%= 
        	   departementTmp.getIdString() + " - " +departementTmp.getName() %></option>
           <%   
        }
    }
%>

		              </select>
                </td>
            </tr>
        </table> 
        <br/>

    </div>
</div>
 -->
 
        <div style="text-align:center">
            <input type="checkbox" name="CGU" value="CGU" /> &nbsp;
            J'ai lu et j'accepte les 
            <a href="javascript:openModal('<%= 
            response.encodeURL(rootPath+"publisher_portail/public/pagesStatics/infoslegales.jsp?view=limited")
            %>','CGU')">
            conditions générales d'utilisation</a>
        </div>
 
<div style="text-align:center;">
	<button type="submit" >s'inscrire</button>
</div>

<%
} // END if(Configuration.isEnabledMemory("modula.publisher.subscription.form.specific", false))
%>

</form>

<%@include file="/publisher_traitement/public/include/footer.jspf"%>
</body>
</html>