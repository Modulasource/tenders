
<%@ page import="modula.graphic.*,org.coin.bean.html.*,org.coin.bean.form.*,java.security.cert.*,java.io.*,java.util.*" %>
<%@ include file="/include/new_style/headerDesk.jspf" %>
<%
	String sTitle = "Champ";
	String sPageUseCaseId = "xxx";
	String sTable = "";
	
	AutoFormField field = AutoFormField.getAutoFormField (Long.parseLong(request.getParameter("iIdAutoFormField"))); 
	sTitle += " "+field.getName();
	boolean bUpdateAndClose = false;
	try {
		if(request.getParameter("bUpdateAndClose").equals("true")) 
			bUpdateAndClose = true;
	} catch (Exception e) {}
	
	boolean bIsIntegrated = false;
	try{
		bIsIntegrated = Boolean.valueOf(request.getParameter("bIsIntegrated"));
	}catch(Exception e){bIsIntegrated = false;};
	
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

	String sAction = request.getParameter("sAction");
	
//	HtmlBeanTabVector vOnglets 
//		= new HtmlBeanTabVector( , request);

    String sUrl = "displayAutoFormField.jsp?sAction=display&amp;iIdAutoFormField=" 
        + field.getId()
        +"&bIsIntegrated="+bIsIntegrated
        +"&bRecurseForm="+bRecurseForm;
    
    int iIdOnglet = HttpUtil.parseInt("iIdOnglet", request , 1);

	Vector<Onglet> vOnglets = new Vector<Onglet>();
    vOnglets.add( new Onglet(Onglet.ONGLET_AUTOFORM_FIELD_GENERAL, false, "Général", response.encodeURL(sUrl + "&iIdOnglet="+Onglet.ONGLET_AUTOFORM_FIELD_GENERAL)) );
    vOnglets.add( new Onglet(Onglet.ONGLET_AUTOFORM_FIELD_VALEUR, false, "Valeur", response.encodeURL(sUrl + "&iIdOnglet="+Onglet.ONGLET_AUTOFORM_FIELD_VALEUR)) );
    if(!bIsIntegrated)
    {
	    vOnglets.add( new Onglet(Onglet.ONGLET_AUTOFORM_FIELD_POSITION, false, "Position", response.encodeURL(sUrl + "&iIdOnglet="+Onglet.ONGLET_AUTOFORM_FIELD_POSITION)) );
    }
    vOnglets.add( new Onglet(Onglet.ONGLET_AUTOFORM_FIELD_MACRO, false, "Macro", response.encodeURL(sUrl + "&iIdOnglet="+Onglet.ONGLET_AUTOFORM_FIELD_MACRO)) );
    Onglet onglet = Onglet.getOnglet(vOnglets,iIdOnglet);
    onglet.bIsCurrent = true;

	HtmlBeanTableTrPave hbTableTr = new HtmlBeanTableTrPave ();
	String sSubmitUrl = "";
	String sActionTarget = "store";
	
	if(sAction.equals("store"))
	{
		hbTableTr.bIsForm = true;
		sSubmitUrl = response.encodeURL("modifyAutoFormField.jsp");

		if(iIdOnglet == Onglet.ONGLET_AUTOFORM_FIELD_MACRO)
		{
			sSubmitUrl = response.encodeURL("modifyAutoFormFieldMacro.jsp");			
			sActionTarget = "storeFieldMacros";
		}
	}
	
	String sIdMacroType = "iIdMacroType_" ;
	
 %>
<%@ include file="../include/checkHabilitationPage.jspf" %>
<script type="text/javascript" src="<%= rootPath %>include/bascule.js" ></script> 
<script type="text/javascript" src="<%= rootPath %>include/cacherDivision.js" ></script> 
<script type='text/javascript' src='<%=rootPath %>dwr/interface/DBDesignerParser.js'></script>
<script type="text/javascript" src="<%=rootPath %>include/component/dbrequest.js"></script>
<script type="text/javascript">
	function updateAndClose()
	{	
		var sUrl = "<%= 
			response.encodeURL(
					"displayAutoForm.jsp?sAction=display&iIdAutoForm=" + field.getIdAutoForm() +"&bIsIntegrated="+bIsIntegrated+"&bRecurseForm="+bRecurseForm
					+ "&nonce=" + System.currentTimeMillis() ) %>";
		window.opener.document.location = sUrl;
		//setTimeout("self.close();",500);
	}


	function doPageOnLoad()
	{
		<%= bUpdateAndClose?"updateAndClose();":"" %>
<% 
	Vector<AutoFormFieldMacroType> vTypes = AutoFormFieldMacroType.getAllAutoFormFieldMacroType();
	for(int i = 0 ; i < vTypes.size(); i++)
	{
		AutoFormFieldMacroType type = vTypes.get(i);
		if(AutoFormFieldMacro.getAllStaticForMacroType(type.getId()).size() > 0)
		{
%>		montrer_cacher('tdMacroType_<%= i %>');
<%
		}
	}
%>	
	} // end doPageOnLoad()
	
	function createMacro(iIdAutoFormField, iIdAutoFormFieldMacroType)
	{
		var sUrl = "<%= response.encodeURL("modifyAutoFormFieldMacroForm.jsp?" ) %>";
		sUrl += "bRecurseForm=<%= bRecurseForm %>&bIsIntegrated=<%= bIsIntegrated %>&sActionField=<%= sAction %>&sAction=create&iIdAutoFormField=" + iIdAutoFormField + "&iIdAutoFormFieldMacroType=" + iIdAutoFormFieldMacroType;
		OuvrirPopup(sUrl , 600, 350, 'menubar=no,scrollbars=yes,statusbar=no');
	}
	
	function displayMacroForm(iIdAutoFormFieldMacro, iIdAutoFormField)
	{
		var sUrl = "<%= response.encodeURL("modifyAutoFormFieldMacroForm.jsp?" ) %>";
		sUrl += "bRecurseForm=<%= bRecurseForm %>&bIsIntegrated=<%= bIsIntegrated %>&sActionField=<%= sAction %>&sAction=store&iIdAutoFormFieldMacro=" + iIdAutoFormFieldMacro + "&iIdAutoFormField=" + iIdAutoFormField;
		OuvrirPopup(sUrl , 600, 350, 'menubar=no,scrollbars=yes,statusbar=no');
	}
	
	function addOption(iIdField)
	{
		var sUrl = "<%= response.encodeURL("modifyAutoFormField.jsp?" ) %>";
		sUrl += "bRecurseForm=<%= bRecurseForm %>&bIsIntegrated=<%= bIsIntegrated %>&sAction=addOption&iIdAutoFormField=" + iIdField +"&iIdOnglet=2";
		
		Redirect(sUrl );
	}
	
	function removeOption(iIdOption)
	{
		var sUrl = "<%= response.encodeURL("modifyAutoFormField.jsp?" ) %>";
		sUrl += "bRecurseForm=<%= bRecurseForm %>&bIsIntegrated=<%= bIsIntegrated %>&sAction=removeOption&iIdAutoFormField=<%= field.getId() %>&iIdOption="+iIdOption+"&iIdOnglet=2";
		
		Redirect(sUrl );
	}
	
	function addSQL(iIdField)
	{
		var db = new mt.component.DBRequest("tables","","<%= sTable %>","","<%= ((field.getIdAutoFormFieldType() == AutoFormFieldType.TYPE_FILELIST)?org.coin.db.DBDesignerParser.DATATYPE_LONGBLOB:0) %>");
		db.addData = function(item){
			var sUrl = "<%= response.encodeURL("modifyAutoFormField.jsp?" ) %>";
			sUrl += "bRecurseForm=<%= bRecurseForm %>&bIsIntegrated=<%= bIsIntegrated %>&sAction=addSQL&iIdAutoFormField=" + iIdField +"&iIdOnglet=2&sSQL="+encodeURIComponent(item);
			Redirect(sUrl);
		}
		db.setSelectName("select");
		db.render();
	}
	
	function removeSQL(iIdSQL)
	{
		var sUrl = "<%= response.encodeURL("modifyAutoFormField.jsp?" ) %>";
		sUrl += "bRecurseForm=<%= bRecurseForm %>&bIsIntegrated=<%= bIsIntegrated %>&sAction=removeSQL&iIdAutoFormField=<%= field.getId() %>&iIdSQL="+iIdSQL+"&iIdOnglet=2";
		
		Redirect(sUrl );
	}
	
	
	function checkForm()
	{
<% 
		if(iIdOnglet == Onglet.ONGLET_AUTOFORM_FIELD_MACRO)
		{
			for(int i = 0 ; i < vTypes.size(); i++)
			{
				AutoFormFieldMacroType type = (AutoFormFieldMacroType ) vTypes.get(i);
				if(AutoFormFieldMacro.getAllStaticForMacroType(type.getId()).size() > 0)
				{
				%><%= HtmlBeanDoubleList.getHtmlJavascriptOnSubmit(sIdMacroType + type.getId() ) %><%
				}
			}
		}
%>		

	} // end checkForm();
	
</script>
</head>
<body onload="javascript:doPageOnLoad()" >
<div class="tabFrame">
<%= Onglet.getAllTabsHtmlDesk(vOnglets) %>
<div class="tabContent">
	<form name="formulaire" onsubmit="javascript:checkForm();"  action="<%= sSubmitUrl %>" >
	<%
	if(sAction.equals("store"))
	{
	%>
	<input type="hidden" name="iIdAutoFormField" value="<%= field.getId() %>" />
	<input type="hidden" name="iIdAutoForm" value="<%= field.getIdAutoForm() %>" />
	<input type="hidden" name="sAction" value="<%= sActionTarget  %>" />
	<input type="hidden" name="iIdOnglet" value="<%= iIdOnglet %>" />
	<input type="hidden" name="bIsIntegrated" value="<%= bIsIntegrated %>" />
	<input type="hidden" name="bRecurseForm" value="<%= bRecurseForm %>" />
	<%
	}%>
	<div style="text-align:right;">
	<%
	if(sAction.equals("store"))
	{
	%>
	<%
	if(iIdOnglet == Onglet.ONGLET_AUTOFORM_FIELD_MACRO)
	{
	%>
	<button 
		type="button" 
		onclick="javascript:createMacro(<%= field.getId() %>,1);" >Ajouter une macro (+)</button>
	<%
	}
	%>	
	<button 
		type="submit" 
	 >Valider</button>
	
	<button 
		type="button" 
		onclick="javascript:window.close()" >Annuler</button>

	<%
	} else { %>
	<button 
		type="button" 
		onclick="javascript:Redirect('<%= 
			response.encodeURL(
					"displayAutoFormField.jsp?sAction=store&amp;iIdAutoFormField=" 
							+ field.getId() + "&amp;iIdOnglet=" + iIdOnglet
							+ "&amp;bIsIntegrated="+bIsIntegrated
							+ "&amp;bRecurseForm="+bRecurseForm) 
			%>')" >Modifier</button>

	<button 
		type="button" 
		onclick="javascript:window.close()" />Fermer</button>
	<% } 

	if(iIdOnglet == Onglet.ONGLET_AUTOFORM_FIELD_GENERAL)
	{
		%>
	<div>
	<table class="formLayout" cellspacing="3">
		<%= hbTableTr.getHtmlTrInput("Nom :", "sName",field.getName() , " size='60' ") %>
		<%= hbTableTr.getHtmlTrInput("Libellé :", "sCaption",field.getCaption() , " size='60' ") %>
		<%= hbTableTr.getHtmlTrSelect("Type :", "iIdAutoFormFieldType", 
				AutoFormFieldType.getAutoFormFieldType(field.getIdAutoFormFieldType()) ) %>
        <%= hbTableTr.getHtmlTrInput("Sous type :", "sSubType",field.getSubType() , " size='60' ") %>
		<%= (!bIsIntegrated)?hbTableTr.getHtmlTrInput("Référence :", "iReference", field.getReference()):"" %>
		</table>
	</div>		
		<%
	}
	else
	{
		%>
	<div class="hide">
	</div>
		<%
	}

	if(iIdOnglet == Onglet.ONGLET_AUTOFORM_FIELD_VALEUR)
	{
		%>
	<div>
	<table class="formLayout" cellspacing="3">
		<%= hbTableTr.getHtmlTrSelect("Type de valeur : ", "iIdAutoFormFieldValueType", 
				AutoFormFieldValueType.getAutoFormFieldValueType(field.getIdAutoFormFieldValueType()) ) %>
		<%= hbTableTr.getHtmlTrInput("Valeur par défaut : ", "sDefaultValue",field.getDefaultValue() ) %>
		<%= hbTableTr.getHtmlTrInput("Valeur minimale : ", "iValueMin",field.getValueMin() ) %>
		<%= hbTableTr.getHtmlTrInput("Valeur maximale : ", "ValueMax",field.getValueMax() ) %>
<% if(!bIsIntegrated){
	//?hbTableTr.getHtmlTrInput("Masque de saisie : ", "sMask",field.getMask(), " size='60'" ):"" 
%>
		<tr>
			<td class="pave_cellule_gauche" >Masque de saisie : </td>
			<td class="pave_cellule_droite" >
<%
	if(hbTableTr.bIsForm)
	{
%>			
				<textarea rows="3" cols="60" name="sMask" ><%= field.getMask()  %></textarea>
<%
	} else {
%>
				<%= field.getMask()  %>	
<%		
	}
%>				
			</td>
		</tr>
<%
	}
	
	if(hbTableTr.bIsForm)
	{
		int x = 0;
		int y = 0;
		int width = 0;
		int height = 0;
		float fFontSize = 0;
		JSONObject obj = null;
		try{
			obj = new JSONObject( field.getMask());
			x = obj.getInt("x");
			y = obj.getInt("y");
			width = obj.getInt("width");
			height = obj.getInt("height");
			fFontSize = obj.getFloat("fontSize");
		} catch (Exception e) {
			e.printStackTrace();
		}
%>
		<tr>
			<td class="pave_cellule_gauche" >(json params)</td>
			<td class="pave_cellule_droite" >
			<input type="checkbox" name="sMask_bUseJsonParam" /> use json param<br/>
			x : <input type="text" size="2" name="sMask_x" value="<%= x %>" /> 
			y : <input type="text" size="2" name="sMask_y" value="<%= y %>" /> 
			width : <input type="text" size="2" name="sMask_width" value="<%= width %>" /> 
			height : <input type="text" size="2" name="sMask_height" value="<%= height %>" />  <br/>
			font-size : <input type="text" size="2" name="sMask_fontSize" value="<%= fFontSize %>" /> 
			</td>
		</tr>
<%
	}
%>		
		<%= hbTableTr.getHtmlTrInput("Longueur max de la valeur : ", "iMaxLength", field.getMaxLength()  ) %>
		<% if(field.getIdAutoFormFieldType() == AutoFormFieldType.TYPE_TEXTAREA){ %>
		<%= hbTableTr.getHtmlTrInput("Nombre de colonnes : ", "iSizeX", field.getSizeX()  ) %>
		<%= hbTableTr.getHtmlTrInput("Nombre de lignes : ", "iSizeY", field.getSizeY()  ) %>
		<%}else{ %>
		<%= hbTableTr.getHtmlTrInput("Taille du champ : ", "iSizeX", field.getSizeX()  ) %>
		<%} %>
        <%= hbTableTr.getHtmlTrInput("Hauteur du champ : ", "iSizeWidth", field.getSizeWidth()  ) %>
        <%= hbTableTr.getHtmlTrInput("Style CSS du champ : ", "sCssStyle", field.getCssStyle(), " size='60'"   ) %>
	</table>
	
	<%
	if(field.getIdAutoFormFieldType()==AutoFormFieldType.TYPE_SELECT
			|| field.getIdAutoFormFieldType()==AutoFormFieldType.TYPE_CHECKBOX
            || field.getIdAutoFormFieldType()==AutoFormFieldType.TYPE_RADIO
            || field.getIdAutoFormFieldType()==AutoFormFieldType.TYPE_SYSTEM
			)
	{
		Vector<AutoFormFieldOption> vOptions = AutoFormFieldOption.getAllFromAutoFormField(field.getId());
	%>
	<br/>
	<div style="padding:2px 0 2px 5px;background-color:#F0F6FF;border-bottom:1px solid #D7E7FF;text-align:left;"
	   ><%= AutoFormFieldType.getAutoFormFieldTypeName(field.getIdAutoFormFieldType()).toUpperCase()
	   %> OPTIONS
	</div>
	<table class="formLayout" cellspacing="3">
<%
	if(sAction.equals("store")){ 
%>
	<tr><td><a href="javascript:addOption(<%= field.getId() %>)" >Ajouter une option</a></td></tr>
<%
	} 

	for(int i=0;i<vOptions.size();i++)
	{
		AutoFormFieldOption option = vOptions.get(i);
		String sFormPrefixOption = "option_"+option.getId()+"_";
%>
    <tr>
        <td style="text-align: left;">

<%
		if(sAction.equals("store")){ 
%>
            valeur  <input name="<%= sFormPrefixOption+"sValue" %>" value="<%= option.getValue() %>" size="5" /> 
            libellé <input name="<%= sFormPrefixOption+"sCaption" %>" value="<%= option.getCaption() %>" size="60" /> 
		<img src="<%= rootPath + Icone.ICONE_SUPPRIMER_NEW_STYLE
		  %>" onclick="removeOption(<%= option.getId() %>)" />
<%
		} else {
%>
            <%= option.getValue() %> : <%= option.getCaption() %>
<%		
		}
%>
        </td>
    </tr>
<%
	}
%>
	</table>
<%	
	}
%>
	
	<%
	if(field.getIdAutoFormFieldType()!=AutoFormFieldType.TYPE_CHECKBOX
			&& field.getIdAutoFormFieldType()!=AutoFormFieldType.TYPE_RADIO)
	{
	Vector<AutoFormFieldSQL> vSQL = AutoFormFieldSQL.getAllFromAutoFormField(field.getId());
	%>
	<br/>
	<div style="padding:2px 0 2px 5px;background-color:#F0F6FF;border-bottom:1px solid #D7E7FF;text-align:left;">SQL</div>
	<table class="formLayout" cellspacing="3">
	<%if(sAction.equals("store")){ %>
	<tr>
	<td><a href="javascript:addSQL(<%= field.getId() %>)" >Ajouter une requete sql</a></td>
	<td><div style="color:#666;font-size:10px;position:relative;top:3px;right:20px;text-align:right">
	Attention pour les presaisies il faut rajouter à la fin de la requête à la main " AND commande_presaisie.id_langue=x" où x = 1 pour FR et x = 6 pour ANG
	</div></td>
	</tr>
	<%} %>
	<%
	for(AutoFormFieldSQL sql : vSQL)
	{
		String sFormPrefixSQL = "sql_"+sql.getId()+"_";
		%>
		<%= hbTableTr.getHtmlTrInput("Requete SQL : ", sFormPrefixSQL+"sSQL",sql.getSQL(),"size=\"70\"" ) %>
		<%if(sAction.equals("store")){ %>
		<tr><td colspan="2"><a href="javascript:removeSQL(<%= sql.getId() %>)" >Supprimer la requete</a></td>
		<%} %>
		<tr><td colspan="2">&nbsp;</td></tr>
		<%
	}
	%>
	</table>
	<div id="tables" class="left">
	</div>
	<br/>
	<div id="data" class="left">
	</div>
	</div>		
		<%
	}
	}
	else
	{
		%>
	<div class="hide">
	</div>
		<%
	}
	
	if(!bIsIntegrated){
	if(iIdOnglet == Onglet.ONGLET_AUTOFORM_FIELD_POSITION)
	{
		%>
	<div>
	<table class="formLayout" cellspacing="3">
		<%= hbTableTr.getHtmlTrSelect("Position du libellé  : ", "iIdAutoFormCaptionPosition", 
				AutoFormPosition.getAutoFormPosition(field.getIdAutoFormCaptionPosition()) ) %>
		<%= hbTableTr.getHtmlTrInput("Position X : ", "iPosX",field.getPosX() ) %>
		<%= hbTableTr.getHtmlTrInput("Position Y : ", "iPosY",field.getPosY() ) %>
		<%= hbTableTr.getHtmlTrInput("Position Libellé DX : ", "iPosDXCaption",field.getPosDXCaption() ) %>
		<%= hbTableTr.getHtmlTrInput("Position Libellé DY : ", "iPosDYCaption",field.getPosDYCaption() ) %>
		<%= hbTableTr.getHtmlTrInput("Position Champ DX : ", "iPosDXField",field.getPosDXField() ) %>
		<%= hbTableTr.getHtmlTrInput("Position Champ DY : ", "iPosDYField",field.getPosDYField() ) %>
	</table>
	</div>		
		<%
	}
	else
	{
		%>
		<div class="hide">
		</div>
		<%
	}
	}

	if(iIdOnglet == Onglet.ONGLET_AUTOFORM_FIELD_MACRO)
	{
		Vector vvMacros = AutoFormFieldMacros.getAllVectorAutoFormFieldMacro(field.getId());
		
		AutoFormFieldMacro macro =null;
%>
<div>
<%
		if(sAction.equals("store"))
		{
			vTypes = AutoFormFieldMacroType.getAllAutoFormFieldMacroType();
			for(int i = 0 ; i < vTypes.size(); i++)
			{
				AutoFormFieldMacroType macroType = (AutoFormFieldMacroType)vTypes.get(i);
				
				// à refaire avec les macros publiques et protégées
				HtmlBeanDoubleList dl = new HtmlBeanDoubleList (sIdMacroType + macroType.getId(), rootPath, 5);
				
				dl.vBeanListSelected = AutoFormFieldMacros.getVectorMacro(macroType.getId(),vvMacros, false); //vMacros ;
				dl.vBeanListAll = AutoFormFieldMacro.getAllStaticForMacroType(macroType.getId());
				
				String sMacroName = macroType.getName();
				if(dl.vBeanListAll.size() > 0)
				{
					sMacroName = "<u>" + macroType.getName() + "</u>";
						
				%>
	<table class="formLayout" cellspacing="3">
		<tr  >
			<td class="pave_titre_gauche" onclick="montrer_cacher('tdMacroType_<%= i %>')" ><%= sMacroName
				  %> </td>
			<td class="pave_titre_droite" ><a href="javascript:createMacro(<%= 
				field.getId() %>,<%= macroType.getId() %>);"> + </a></td>
		</tr>
		<tr>
			<td id="tdMacroType_<%= i %>" colspan="2" class="frame" >
				<%= dl.getHtmlDoubleList() %>
			</td>
		</tr>
	</table>
	<br />
		<%
				}
			}
		}
		else
		{
			for(int i = 0 ; i < vvMacros.size(); i++)
			{
				Vector vMacros = (Vector) vvMacros.get(i);
				// à refaire avec les macros publiques et protégées
				macro = (AutoFormFieldMacro)vMacros.firstElement();
				long lIdAutoFormFieldMacroType = macro.getIdAutoFormFieldMacroType();
		%>
	<table class="formLayout" cellspacing="3">
		<tr>
			<td class="pave_titre_gauche"><%= 
				AutoFormFieldMacroType.getAutoFormFieldMacroTypeName(
					lIdAutoFormFieldMacroType)  %> </td>
			<td class="pave_titre_droite" ><a href="javascript:createMacro(<%= 
				field.getId() %>,<%= lIdAutoFormFieldMacroType %>);"> + </a></td>
		</tr>
		<%
				for(int k = 0 ; k < vMacros.size(); k++)
				{
					macro = (AutoFormFieldMacro) vMacros.get(k);
					
		%>
		<tr>
			<td colspan="2" class="frame">
				<a href="javascript:displayMacroForm(<%= macro.getId() %>,<%= field.getId() %>)" ># <%= macro.getName() %></a>
			</td>
		</tr>
		<%
				}
		%>
		<tr><td colspan="2">&nbsp;</td>
		</tr>
		<tr ><%
				String sHtmlFunction = AutoFormFieldMacro.getHtmlFunction(field, vMacros, "", false);
				//int iNbRows = sHtmlFunction.split("\n").length ;
				//<textarea cols="80" rows="<%= iNbRows>10?"10":""+iNbRows ">
			%>
			<td class="frame" colspan="2"><%= org.coin.util.Outils.replaceNltoBr(sHtmlFunction) %></td>
		</tr>
	</table>
	<br />
		<%
			}
		}
	%>
	</div>
	<%
	}
	else
	{
		%>
		<div class="hide">
		</div>
		<%
	}
	%>
	</form>
</div>
</div>
</body>
<%@page import="org.coin.util.Outils"%>

<%@page import="org.coin.util.HttpUtil"%>
<%@page import="org.json.JSONObject"%></html>