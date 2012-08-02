<%@ include file="/include/new_style/headerDesk.jspf" %>
<%@ page import="org.coin.bean.html.*,org.coin.bean.form.*,java.security.cert.*,java.io.*,java.util.*" %>
<%
	String sTitle = "formulaire : ";
	String sPageUseCaseId = "xxx";
	
	int iMaxColumnIndex = 4;
	int iMaxRowIndex = 10;
	int iIdAutoForm = Integer.parseInt(request.getParameter("iIdAutoForm"));
	boolean bRecurseForm = true;
	try {
		if (request.getParameter("bRecurseForm").equals("true"))
		{
			bRecurseForm = true;
		}
		else
		{
			bRecurseForm = false;
		}
	} catch (Exception e) {}

	boolean bIsIntegrated = false;
	try{
		bIsIntegrated = Boolean.valueOf(request.getParameter("bIsIntegrated"));
	}catch(Exception e){bIsIntegrated = false;};
	
	AutoForm autoform = AutoForm.getAutoForm(iIdAutoForm);
	autoform.setRecurseForm(bRecurseForm);
	
	sTitle += " " + autoform.getCaption();
	String sHtmlAllHtmlJavascriptFunctions = ""; 
	String sHtmlAllHtmlJavascriptFunctionEventLink = autoform.getHtmlAllHtmlJavascriptFunctionEventLink();
	
	if(!autoform.isRecurseForm())
	{
		autoform.setEmptyCell("<div align='right' ><a href='javascript:createField($col,$row);' class='autoFormEditLink'><img src='"+rootPath+"images/icons/plus.gif' title='ajouter' /></a></div>");
		autoform.setCaptionPrefix(
				"<a href='javascript:removeField($idField);' class='autoFormEditLink'><img src='"+rootPath+"images/icons/cross.gif' title='supprimer'/></a> "
				+ "<a href='javascript:displayFieldPopup($idField);' class='autoFormEditLink'><img src='"+rootPath+"images/icons/application_edit.gif' title='editer' /></a> " );
	}
	else
	{
		sHtmlAllHtmlJavascriptFunctions = autoform.getHtmlAllHtmlJavascriptFunctions(rootPath,"", true, true,-1);		
	}
	HtmlBeanTableTrPave hbTableTr = new HtmlBeanTableTrPave ();
	hbTableTr.bIsForm = true;
	if(bIsIntegrated) sTitle = "";
	Vector <AutoFormField> vFields = AutoFormField.getAllStaticForIdAutoForm(autoform.getId());
 %>
<%@ include file="/desk/include/checkHabilitationPage.jspf" %>
<script type="text/javascript" src="<%= rootPath %>include/bascule.js" ></script> 
<script type="text/javascript">
function createField(col, row)
{
	var sUrl = "<%= response.encodeURL("modifyAutoFormField.jsp?" ) %>";
	sUrl += "bRecurseForm=false&bIsIntegrated=<%= bIsIntegrated %>&sAction=create&iIdAutoForm=<%= autoform.getId() %>&iPosX=" + col + "&iPosY="  + row;
	
	Redirect(sUrl );
}

function removeField(iIdAutoFormField)
{
	var sUrl = "<%= response.encodeURL("modifyAutoFormField.jsp?" ) %>";
	sUrl += "bRecurseForm=false&bIsIntegrated=<%= bIsIntegrated %>&sAction=remove&iIdAutoFormField=" + iIdAutoFormField;
	Redirect(sUrl );
}

function displayFieldPopup(iIdAutoFormField)
{
	var sUrl = "<%= response.encodeURL("displayAutoFormField.jsp?" ) %>";
	sUrl += "bRecurseForm=false&bIsIntegrated=<%= bIsIntegrated %>&sAction=display&iIdAutoFormField=" + iIdAutoFormField;
	OuvrirPopup(sUrl , 600, 450, 'menubar=no,scrollbars=yes,statusbar=no');
}
function checkFields()
{
	var x = document.getElementById('iSizeX').value;
	var y = document.getElementById('iSizeY').value;
	var sError = "";
	var bReturn = true;
<%
for(int i=0;i<vFields.size();i++)
{
	AutoFormField field = vFields.get(i);
	%>
	
	if(<%=(field.getPosX()+1)%>>x || <%=(field.getPosY()+1)%>>y)
	{
		sError += "le champ \"<%= field.getCaption() %>\" est en dehors de l'espace spécifié<br/>";
		bReturn = false;
	}
	<%
}
%>
document.getElementById("divError").innerHTML = sError ;
return bReturn;
}
<%
	if(!bIsIntegrated) { 
%>
onPageLoad = function() {
	function saveAutoFormData() {
		checkAllData();


<%

/*

    var xmlStr = '<modula action="org.coin.bean.form.storeAutoForm">';
    xmlStr +=  autoform.serialize() ;//produit.serialize();
    xmlStr += '</modula>';
      
    traceXML(xmlStr, 1);
      
    var xmlStr2 = '<modula action="org.coin.bean.form.storeAutoForm">';
    xmlStr2 += ' autoform.serializeDataFromJS() ';
    xmlStr2 += '</modula>';
      
    traceXML(xmlStr2, 2);
    
    
    new Ajax.Request(webService_url, {method:'post', parameters:"sXml="+encodeURIComponent
    	(xmlStr)+"&nocache="+(new Date()), onComplete:function(r){
    	   traceXML(r.responseText, 2);
    	   var root = r.responseXML.documentElement;
    	   Element.hide($('page'));
    	  }});

*/



%>
	  
}

function checkAllData()
{
	var tabInput = document.getElementsByTagName("input");
	var sError = "";
	for(var z=0; z<tabInput.length; z++)
	{
	     if(tabInput[z].value == null || tabInput[z].value == "")
	     {
	     	sError += "le champ "+tabInput[z].name+" n'est pas renseigné<br/>";
	     }
	}
	var tabText = document.getElementsByTagName("textarea");
	for(var z=0; z<tabText.length; z++)
	{
	     if(tabText[z].value == null || tabText[z].value == "")
	     {
	     	sError += "le champ "+tabText[z].name+" n'est pas renseigné<br/>";
	     }
	}
	if(sError != ""){
		var span = document.createElement("span");
		span.style.marginTop= "5px";
		span.style.color="#900";
		span.innerHTML = sError;
		document.body.appendChild(span);
		}
	}
<% 
		if(autoform.isRecurseForm() && !bIsIntegrated)
		{
%>
//	$('saveAutoFormData_btn').onclick = saveAutoFormData;
<%
		}
%>
}
<% 
	} // if(!bIsIntegrated) 
%>
</script>
<link rel="stylesheet" type="text/css" href="<%= rootPath + "include/js/autosuggest/autosuggest.css" %>" />
<script type="text/javascript" src="<%= rootPath + "include/js/autosuggest/autosuggest2.js" %>" ></script>


<script type="text/javascript">
/*  AUTO GENERATED JAVASCRIPT  */
<%= sHtmlAllHtmlJavascriptFunctions %>








/*
function StateSuggestions() {
   this.listItem = [
       "Alabama", "Alaska", "Arizona", "Arkansas",
       "California", "Colorado", "Connecticut",
       "Delaware", "Florida", "Georgia", "Hawaii",
       "Idaho", "Illinois", "Indiana", "Iowa",
       "Kansas", "Kentucky", "Louisiana",
       "Maine", "Maryland", "Massachusetts", "Michigan", "Minnesota", 
       "Mississippi", "Missouri", "Montana",
       "Nebraska", "Nevada", "New Hampshire", "New Mexico", "New York",
       "North Carolina", "North Dakota", "Ohio", "Oklahoma", "Oregon", 
       "Pennsylvania", "Rhode Island", "South Carolina", "South Dakota",
       "Tennessee", "Texas", "Utah", "Vermont", "Virginia", 
       "Washington", "West Virginia", "Wisconsin", "Wyoming"  
   ];
}
StateSuggestions.prototype.requestSuggestions = function (oAutoSuggestControl , bTypeAhead ) {
    var aSuggestions = [];
    var sTextboxValue = oAutoSuggestControl.textbox.value.toLowerCase();
    
    pushSuggestedValueIgnoreCase(aSuggestions, this.listItem, sTextboxValue);

    oAutoSuggestControl.autosuggest(aSuggestions, bTypeAhead);
};

*/

function pushSuggestedValueIgnoreCase(
        aSuggestions,
        listItem,
        sTextboxValue )
{
    if (sTextboxValue.length > 0){
        
        //search for matching states
        for (var i=0; i < listItem.length; i++) { 
            var item = listItem[i];
            var itemLC = item.toLowerCase();
            if (itemLC.indexOf(sTextboxValue) == 0) {
                aSuggestions.push(item);
            } 
        }
    }
    
}


window.onload = function () {
   try{
	    $$(".fournitures_label").each(
	    	    function(item, index){
                    //new AutoSuggestControl(item, new StateSuggestions()
                    new AutoSuggestControl(item, new SuggestFournitures()
	    	    	);    
	        	    
	    });
    } catch (e) {}
}

</script>


 
</head>
<body <%= (bIsIntegrated)?"id=\"formFrame\"":"" %>>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<div id="fiche">
<%
if(!bIsIntegrated){
%>
<div>
<a href="javascript:Redirect('<%= response.encodeURL("displayAllAutoForm.jsp") 
    %>');" />Retour liste des formulaires</a>
</div>
<br/>
<% } %>


<%
	if(!autoform.isRecurseForm())
	{
%>
<div class="sectionTitle"><div>Propriétés</div></div>
<div class="sectionFrame">
	<form name="formulaire" action="<%= response.encodeURL("modifyAutoForm.jsp?sAction=store") %>" method="post" >
	<input type="hidden" name='bIsIntegrated' value='<%= bIsIntegrated %>' />
	<input type="hidden" name='bRecurseForm' value='<%= bRecurseForm %>' />
	<input type="hidden" name='iIdAutoForm' value='<%= autoform.getId() %>' />
	<table >
		<%= (!bIsIntegrated && sessionUserHabilitation.isSuperUser())?hbTableTr.getHtmlTrInput("Nom(HTML) :", "sName",autoform.getName() ):"" %>
		<%= hbTableTr.getHtmlTrInput("Libellé :", "sCaption",autoform.getCaption() ) %>
		<%= hbTableTr.getHtmlTrInput("Nombre de colonnes :", "iSizeX", autoform.getSizeX() ) %>
		<%= hbTableTr.getHtmlTrInput("Nombre de lignes :", "iSizeY", autoform.getSizeY() ) %>
		<tr>
			<td>&nbsp;</td>
			<td>
				<button type="submit" 
				    onclick="return checkFields();" >Mettre à jour</button>
				<div class="rouge" id="divError"></div>
			</td>
		</tr>
	</table>
	</form>
</div>
<%
	}

	String sPrefixInternal = AutoForm.HTML_FORM_PREFIX_INTERNAL;
%>
<form name="formData" action="<%= response.encodeURL("modifyAutoFormData.jsp") %>" method="post" >
<div class="sectionTitle">Composition</div>
<div class="sectionFrame">

<%= autoform.getHtmlForm(rootPath) %>

</div>
</div>
<%
	if(!autoform.isRecurseForm())
	{
%>
<button type="button" onclick="javascript:doUrl('<%= 
                response.encodeURL(
                    rootPath + "desk/AutoFormGenerateDocumentServlet"
                    + "?lIdAutoform="+ autoform.getId() 
                    + "&sDocumentType=xsl")
                %>');" 
>XSL</button>

<button type="button" onclick="javascript:doUrl('<%= 
                response.encodeURL(
                    rootPath + "desk/AutoFormGenerateDocumentServlet"
                    + "?lIdAutoform="+ autoform.getId() 
                    + "&sDocumentType=pdf")
                %>');" 
>PDF</button>

<button type="button" onclick="javascript:doUrl('<%= 
                response.encodeURL(
                    rootPath + "desk/AutoFormGenerateDocumentServlet"
                    + "?lIdAutoform="+ autoform.getId() 
                    + "&sDocumentType=rtf")
                %>');" 
>RTF</button>

<% 
	} else {
%>
    <input type="hidden" name="<%=sPrefixInternal  %>lIdAutoform" value="<%= autoform.getId() %>" />
	<input type="radio" name="<%= sPrefixInternal %>sOutputType" checked="checked" value="xml" /> XML 
	<input type="radio" name="<%= sPrefixInternal %>sOutputType" value="pdf" /> PDF 
	<input type="radio" name="<%= sPrefixInternal %>sOutputType" value="rtf" /> RTF 
    <input type="checkbox" name="<%= sPrefixInternal %>bSaveAllValue" /> Mémoriser valeurs
	<button type="submit" >Enregistrer</button>
<%  
	}


%>
</form>

<div id="fiche_footer">

<%
	
	if(autoform.isRecurseForm() && !bIsIntegrated){
%>
<!-- 
	<button type="button" id="saveAutoFormData_btn" >Enregistrer</button>
 -->
 <% 
	} 
%>
	<button type="button" onclick="javascript:Redirect('<%= 
					response.encodeURL("displayAutoForm.jsp?iIdAutoForm=" 
						+ autoform.getId() + "&amp;bRecurseForm=" + (!bRecurseForm) ) 
						+ "&amp;bIsIntegrated="+ bIsIntegrated
					%>');" 
			><%= bRecurseForm?"Modifier":"Visualiser" %></button>
<% 
	if(bIsIntegrated){
%>
	<button type="button" id="deleteAutoForm_btn" >Supprimer</button> 
<%
	} 
%>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
</html>