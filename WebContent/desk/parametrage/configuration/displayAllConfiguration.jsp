<%@ include file="/include/new_style/headerDesk.jspf" %>
<%@ page import="org.coin.bean.conf.*,java.util.*" %>
<%@page import="org.coin.db.CoinDatabaseAbstractBean"%>
<%@page import="org.coin.bean.param.ObjectParameterTemplate"%>
<%@page import="org.coin.bean.param.ObjectParameterTemplateState"%>
<%@page import="org.coin.bean.ObjectType"%>
<%@page import="org.coin.bean.param.ObjectParameterTemplateType"%>
<% 

	// TODO : pas de TRACE QUERY dans  Configuration.getAllStaticMemory() ???
	Vector<Configuration> vItems = Configuration.getAllStaticMemory();
	String sTitle = "Configuration : <span class=\"altColor\">"+vItems.size()+"</span>"; 
	String sPageUseCaseId = "IHM-DESK-PARAM-CONF-1";
	sessionUserHabilitation.isHabilitateException(sPageUseCaseId);

%>
<script type="text/javascript">

function editParam(sParamName)
{
    Element.toggle("span_form_" + sParamName);
    Element.toggle("span_display_" + sParamName);
}


function removeParam(sUrlRemove)
{
    if(confirm("Etes vous sûr ?")){
        doUrl(sUrlRemove);
    }
}


function doUrl(url)
{		
	window.location.href = url ;
}


function displayConfiguration(id) {
	location.href = "<%=
		response.encodeURL(
				rootPath
				+"desk/parametrage/configuration/modifyConfigurationForm.jsp")%>?sAction=store&sId="+id;
}
</script>
</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<div id="fiche">
	<div class="right">
		<button type="button" onclick="javascript:doUrl('<%=
			response.encodeURL(
					rootPath+"desk/parametrage/configuration/modifyConfigurationForm.jsp?sAction=create") 
					%>');" >Ajouter</button>
	
		<button type="button" onclick="Redirect('<%= 
		    response.encodeURL(
		        rootPath + "desk/parametrage/object/displayAllObjectParameterTemplate.jsp?")
		%>')" ><%= "Afficher les templates de paramètre" %></button>
		
		<button type="button" onclick="Redirect('<%= 
		    response.encodeURL(
		        rootPath + "desk/parametrage/object/displayAllObjectParameterTemplateGroup.jsp?")
		%>')" ><%= "Afficher les groupes de paramètre" %></button>
				
	</div>
	<br />
	<div class="dataGridHolder fullWidth">
		<table class="dataGrid fullWidth">
			<tr class="header">
                <td>&nbsp;</td>
                <td>Code</td>
				<td>Valeur</td>
			</tr>
<%
for (int i=0; i < vItems.size(); i++) {
	Configuration item = vItems.get(i);


    String sParamTemplateInfo = null;
    ObjectParameterTemplate otm = null;
    try {
        otm  = ObjectParameterTemplate.getObjectParameterTemplateMemory(ObjectType.CONFIGURATION, item.getIdString());
        ObjectParameterTemplateState otmState = null;
        String sIconSrc = rootPath + "images/icons/link.gif";
        String sDescription = otm.getName();

        try {
            otmState = ObjectParameterTemplateState 
               .getObjectParameterTemplateStateMemory(
                       otm.getIdObjectParameterTemplateState());
            

            switch ((int)otmState.getId())
            {
            case ObjectParameterTemplateState.STATE_ACTIVATED: 
                sIconSrc = rootPath + "images/icons/link.gif";
                break;
            case ObjectParameterTemplateState.STATE_DEACTIVATED: 
                sIconSrc = rootPath + "images/icons/icon_remove.png";
                sDescription = otmState.getName() + ": " + sDescription;
                break;
            case ObjectParameterTemplateState.STATE_ARCHIVED: 
                sIconSrc = rootPath + "images/icons/icon_remove.png";
                sDescription = otmState.getName() + ": " + sDescription;
                break;
            case ObjectParameterTemplateState.STATE_DEPRECATED: 
                sIconSrc = rootPath + "images/icons/warning.png";
                sDescription = otmState.getName() + ": " + sDescription;
                break;
            }
        } catch (Exception ee) {
            ee.printStackTrace();
        }
        
        sParamTemplateInfo = "<img src=\"" + sIconSrc + "\" "
          + " title=\"" + sDescription + "\" "
          + " alt=\"" + sDescription + "\" "
          + "/>";
    } catch (Exception e) {
        sParamTemplateInfo = "";
    }

	
	
%>
					<tr class="liste<%=i%2%>" 
						onmouseover="className='liste_over'" 
						onmouseout="className='liste<%=i%2%>'" 
						>
						<td>
                            <%= sParamTemplateInfo %>
						</td>
				    	<td style="width:50%">
                          <span style="cursor: pointer;"
                           onclick="javascript:displayConfiguration('<%= item.getIdString()  %>');" >
				    	   <%= item.getIdString() %>
                          </span>
				    	</td>
				    	<td style="width:50%">


          <span id="<%= "span_display_" + item.getIdString() %>" 
              style="cursor: pointer;" 
              onclick="editParam('<%= item.getIdString() %>');" >
            <%= item.getName() %>
          </span>
          <span id="<%= "span_form_" + item.getIdString() %>" style="display: none;">
              <form action="<%= response.encodeURL(rootPath+ "desk/parametrage/configuration/modifyConfiguration.jsp") %>" >
                  <input type="hidden" name="sAction" value="store" />
                  <input type="hidden" name="sOldId" value="<%= item.getIdString() %>" />
                  <input type="hidden" name="sId" value="<%= item.getIdString() %>" />
                  
<%
        int iCurrentInputType = ObjectParameterTemplateType.HTML_INPUT_TYPE_INPUT;
        if(otm != null)
        {   
            iCurrentInputType 
             = ObjectParameterTemplateType.getHtmlInputType(
                     otm.getIdObjectParameterTemplateType());
        }

        switch(iCurrentInputType )
        {
        case ObjectParameterTemplateType.HTML_INPUT_TYPE_INPUT:
%>                
            <input name="sName" size="40" value="<%= item.getName() %>" />
<%
            break;
        case ObjectParameterTemplateType.HTML_INPUT_TYPE_TEXTAREA:
            /**
             * normal mode
             */
%>                
                  <textarea rows="2" name="sName" style="width:99%"><%= item.getName() %></textarea>
<%
            break;
        case ObjectParameterTemplateType.HTML_INPUT_TYPE_SELECT:
            Vector<String> vValue 
                = ObjectParameterTemplateType.getAllHtmlSelectValue(
                        otm.getIdObjectParameterTemplateType());
            
%>                
                <select  name="sName" >
<%
            for(String sVal : vValue)
            {
%>
                    <option value="<%= sVal %>" <%= sVal.equals( item.getName())?"selected='selected'":"" %> ><%= sVal %></option>
<%              
            }
%>                    
                </select>
<%
            break;
        }
        
%>                  


                  <button type="submit">Valider</button>
                  <button type="button" onclick="editParam('<%= item.getIdString() %>');" >Annuler</button>
              </form>
          </span>
				    	</td>
				  	</tr>
<%
}
%>
				</table>
	</div>
	</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
</html>
