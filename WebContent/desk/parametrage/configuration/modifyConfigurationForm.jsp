<%@ include file="/include/new_style/headerDesk.jspf" %>
<%@page import="java.util.Vector"%>
<%@page import="org.coin.bean.param.ObjectParameterTemplate"%>
<%@page import="org.coin.bean.ObjectType"%>
<%@page import="org.coin.bean.html.*" %>
<% 
	String sTitle = "Configuration : "; 


	Configuration item = null;
	String sPageUseCaseId = "IHM-DESK-PARAM-CONF-2";
	
	String sAction = request.getParameter("sAction");
	if(sAction.equals("create"))
	{
		item = new Configuration();
		sTitle += "<span class=\"altColor\">Nouvelle Configuration</span>"; 
	}
	
	if(sAction.equals("store"))
	{
		item = Configuration.getConfigurationMemory(request.getParameter("sId"));
		sTitle += "<span class=\"altColor\">"+item.getIdString()+"</span>"; 
	}

	HtmlBeanTableTrPave pave = new HtmlBeanTableTrPave();
	pave.bIsForm = true;
	sessionUserHabilitation.isHabilitateException(sPageUseCaseId);

	
%>
</head>
<body>
<script type="text/javascript">
function removeItem()
{
	if(!confirm("Etes-vous sûr de vouloir supprimer ce paramètre ?"))
		return;

	doUrl('<%=
			response.encodeURL(rootPath
					+"desk/parametrage/configuration/modifyConfiguration.jsp?sAction=remove&sId=" 
							+ item.getIdString() ) %>');
}

function toggleObjectParameterTemplateAllreadyUsed()
{
    $$(".opt_instanciate").each(
            function(item, index){
                Element.toggle(item);
    });
}
</script>

<%@ include file="/include/new_style/headerFiche.jspf" %>
<form action="<%= response.encodeURL("modifyConfiguration.jsp") %>" method="post" name="formulaire">
<div id="fiche">

		<input type="hidden" name="sAction" value="<%= sAction %>" />
		<input type="hidden" name="sOldId" value="<%= item.getIdString() %>" />
		<table class="formLayout" cellspacing="3">
<%
	if(sAction.equals("create"))
	{
%>
            <tr>
                <td class="pave_cellule_gauche">Template :</td>
                <td class="pave_cellule_droite">
    <input 
        checked="checked" 
        type="checkbox" 
        onclick="Element.toggle('optList');" /> Utiliser les templates de paramètre
    &nbsp;&nbsp;&nbsp;
    <input 
        checked="checked" 
        type="checkbox" 
        onclick="toggleObjectParameterTemplateAllreadyUsed();" /> Masquer les paramètres déjà utilisés.
    <div id="optList" style="width:530px; height: 100px;overflow: auto;border: 1px solid #AAF;">
        <table cellpadding="0" cellspacing="0">
<%
	    Vector<ObjectParameterTemplate> v = ObjectParameterTemplate.getAllObjectParameterTemplateMemory(ObjectType.CONFIGURATION);
	    for(ObjectParameterTemplate opt : v)
	    {
	        String sOPTClass = "opt_not_instanciate";
	        String sOPTStyle = "";
	        try {
	            Configuration c = Configuration.getConfigurationMemory(opt.getParamName());
	            sOPTClass = "opt_instanciate";
	            sOPTStyle = "style='display:none'";
	        } catch (Exception e) {
	        }
%>
            <tr class="<%= sOPTClass %>" <%= sOPTStyle %> >
                <td style="border: 1px solid #AAF;padding: 2px;" 
                    >
                    <span style="cursor: pointer;"
                        onclick="$('sId').value=this.innerHTML;" ><%= opt.getParamName() %></span>
                </td>
                <td style="border: 1px solid #AAF;padding: 2px;"><%= Outils.getTextToHtml(opt.getName() ) %></td>
            </tr>
<%      
    }
%>        
        </table>
    </div>


                </td>
            </tr>
<%
	}
%>
		<%= pave.getHtmlTrInput("Code :", "sId", item.getIdString(),"size=\"100\"") %>
		<%= pave.getHtmlTrInput("Valeur :", "sName", item.getName(),"size=\"100\"") %>
			<tr>
				<td class="pave_cellule_gauche">Description :</td>
				<td class="pave_cellule_droite">
					<textarea cols="97" rows="15" name="sDescription"><%= 
						item.getDescription() %></textarea></td>
			</tr>
            <tr>
                <td class="pave_cellule_gauche">Filtre html :</td>
                <td class="pave_cellule_droite">
                    <input type="radio" name="bUseFieldValueFilter" value="true" checked="checked" /> oui
                    <input type="radio" name="bUseFieldValueFilter" value="false" /> non
                </td>
            </tr>
		</table>
</div>
<div id="fiche_footer">
	<button type="submit" ><%= localizeButton.getValueSubmit() %></button>
	<%if(sAction.equals("store"))
	{ %>
	<button type="button" onclick="javascript:removeItem();">
			<%= localizeButton.getValueDelete() %></button>
	<%} %>
	<button type="button" onclick="javascript:doUrl('<%=
			response.encodeURL(rootPath+"desk/parametrage/configuration/displayAllConfiguration.jsp") %>');" >
			<%= localizeButton.getValueCancel() %></button>
</div>
</form>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
</html>
