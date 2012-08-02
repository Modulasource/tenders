<%@page import="java.util.ArrayList"%>
<%@page import="java.util.HashMap"%>
<%@page import="org.coin.util.HttpUtil"%>

<%@page import="org.coin.fr.bean.Organisation"%>
<%@page import="org.coin.fr.bean.Adresse"%>
<%@page import="org.coin.bean.html.HtmlBeanTableTrPave"%>
<%@page import="org.coin.fr.bean.OrganisationClasseProfit"%>

<%@ include file="/include/new_style/headerDesk.jspf" %>

<%
    String sAction = HttpUtil.parseStringBlank("sAction", request);

	Organisation organisation = null;
	try { 
		organisation = Organisation.getOrganisation(Integer.parseInt(request.getParameter("iIdOrganisation")));
	} catch(Exception e) {
		organisation = new Organisation();
	}
    organisation.setAbstractBeanLocalization(sessionLanguage);
    Adresse adresse = null;
    try {
    	adresse = Adresse.getAdresse(organisation.getIdAdresse());
    } catch(Exception e) {
    	adresse = new Adresse();
    }
        
    if(!sAction.equals("store")) {
        organisation.setFromFormUpdateBoampInfo(request, "");
        organisation.store();
    }
    
    
    OrganisationClasseProfit ocp = new OrganisationClasseProfit(organisation.getIdOrganisationClasseProfit());

    HtmlBeanTableTrPave hbFormulaire = new HtmlBeanTableTrPave();
    hbFormulaire.bIsForm = true;

%>
<script type="text/javascript" src="<%= rootPath %>include/verification.js"></script>
<script type="text/javascript">
<%@ include file="pave/updateBoampInformationForm.jspf" %>
</script>
</head>
<body>
<div style="padding:15px">
<% 
if(sAction.equals("store")) {
%>
    <form action="<%= response.encodeURL(rootPath + "desk/organisation/updateBoampInformationForm.jsp?iIdOrganisation="+organisation.getIdOrganisation()) %>" method="post" name="formulaire" id="formulaire" onsubmit="return checkForm();"> 
        <table class="pave">
            <tr>
                <td class="pave_titre_gauche" colspan="2">Données administrative de votre entreprise</td>
            </tr>
            <tr><td colspan="2">&nbsp;</td></tr>
            <tr><td colspan="2">Le BOAMP change son mode de fonctionnement, afin de continuer à envoyer vos avis par MODULA merci de compléter les éléments suivants : </td></tr>            
            <tr><td colspan="2">&nbsp;</td></tr>
            <tr><td colspan="2">
			    <a name="ancreError"></a>
			    <div class="rouge" style="text-align:left" id="divError"></div>
		    </td></tr>
		    <tr><td colspan="2">&nbsp;</td></tr>
            <tr>
		        <td class="pave_cellule_gauche" ><%= organisation.getSiretLabel() %> :</td>
		        <td class="pave_cellule_droite" >
		        <%
		        ArrayList<HashMap<String, String>> listSiret = organisation.getSiretValueForm(adresse.getIdPays());
		        for(HashMap<String, String> mapSiret : listSiret){
		        %>
		            <input type="text" name="<%= mapSiret.get("name") %>" 
		            id="<%= mapSiret.get("id") %>" 
		            size="<%= mapSiret.get("size") %>" 
		            maxlength="<%= mapSiret.get("maxlength") %>" 
		            value="<%= mapSiret.get("value") %>" />
		        <%}%>
		        </td>
		    </tr>
		    <%= hbFormulaire.getHtmlTrSelect("Classe profit :","iIdOrganisationClasseProfit",ocp) %>
		    <tr><td colspan="2">&nbsp;</td></tr>
		    <tr><td colspan="2" style="text-align:center"><button type="submit" ><%= localizeButton.getValueSave() %></button></td></tr>
            <tr><td colspan="2">&nbsp;</td></tr>
        </table>    
    </form>    
<%
} else {
%>
    <table class="pave">
        <tr>
            <td class="pave_titre_gauche" colspan="2">Données administrative de votre entreprise</td>
        </tr>
        <tr><td colspan="2">&nbsp;</td></tr>
        <tr><td colspan="2">Les informations concernant votre compte ont correctement été mises à jour.</td></tr>            
        <tr><td colspan="2">&nbsp;</td></tr>
        <tr><td colspan="2" style="text-align:center"><button onclick="closeModal()"><%= localizeButton.getValueCloseWindow() %></button></td></tr>
        <tr><td colspan="2">&nbsp;</td></tr>
    </table>
<%
}
%>
</body>
</html>