
<%@ page import="org.coin.bean.html.*,org.coin.bean.form.*,java.security.cert.*,java.io.*,java.util.*" %>
<%@ include file="../../include/new_style/headerDesk.jspf" %>
<%
	String sTitle = "Macro";
	String sPageUseCaseId = "xxx";
	
	String sAction = request.getParameter("sAction");
	
	String sActionField = "display";
	if(request.getParameter("sActionField")!= null)
		sActionField = request.getParameter("sActionField");
	
	boolean bIsIntegrated = false;
	try{
		bIsIntegrated = Boolean.valueOf(request.getParameter("bIsIntegrated"));
	}catch(Exception e){bIsIntegrated = false;};
	
	boolean bRecurseForm = false;
	try{
		bRecurseForm = Boolean.valueOf(request.getParameter("bRecurseForm"));
	}catch(Exception e){bRecurseForm = false;};
	
	AutoFormFieldMacro macro = null;
	
	// on est tjs relatif à un field ... à voir
	AutoFormFieldMacros macros = null;
	
	if(sAction.equals("create"))
	{
		AutoFormField field = AutoFormField.getAutoFormField(
				Long.parseLong(request.getParameter("iIdAutoFormField"))); 

		macros = new AutoFormFieldMacros();
		macros.setIdAutoFormField(field.getId());
		macro = new AutoFormFieldMacro ();
		macro.setIdAutoFormFieldMacroVisibility(AutoFormFieldMacroVisibility.TYPE_PRIVATE);
		macro.setIdAutoFormFieldMacroType(AutoFormFieldMacroType.TYPE_ON_SUBMIT);
		
		try{
			macro.setIdAutoFormFieldMacroType(
					Integer.parseInt(request.getParameter("iIdAutoFormFieldMacroType")));

		} catch (Exception e) {}
	}

	if(sAction.equals("store"))
	{
		macros = new AutoFormFieldMacros ();
		macros.setIdAutoFormField(Integer.parseInt(request.getParameter("iIdAutoFormField")));
		macro 
			= AutoFormFieldMacro.getAutoFormFieldMacro(
					Integer.parseInt(request.getParameter("iIdAutoFormFieldMacro")));
	}

	sTitle += " "+macro.getName();
	
	HtmlBeanTableTrPave hbTableTr = new HtmlBeanTableTrPave ();
	hbTableTr.bIsForm = true;
	
	AutoFormFieldMacroType type
		= AutoFormFieldMacroType.getAutoFormFieldMacroType(
				macro.getIdAutoFormFieldMacroType()	);

	AutoFormFieldMacroVisibility visibility 
		= AutoFormFieldMacroVisibility.getAutoFormFieldMacroVisibility(
				macro.getIdAutoFormFieldMacroVisibility() );

 %>
<%@ include file="../include/checkHabilitationPage.jspf" %>
<script type="text/javascript">
<!--

	function removeMacro(iIdAutoFormFieldMacro, iIdAutoFormField)
	{
		var sUrl = "<%= response.encodeURL("modifyAutoFormFieldMacro.jsp?" ) %>";
		sUrl += "bRecurseForm=<%= bRecurseForm %>&bIsIntegrated=<%= bIsIntegrated %>&sAction=remove&sActionField=<%= sActionField %>&iIdAutoFormFieldMacro=" + iIdAutoFormFieldMacro 
		+ "&iIdAutoFormField=" + iIdAutoFormField;
		Redirect(sUrl );
	}

	function displayField(iIdAutoFormField)
	{
		var sUrl = "<%= response.encodeURL("displayAutoFormField.jsp?" ) %>";
		sUrl += "bRecurseForm=<%= bRecurseForm %>&bIsIntegrated=<%= bIsIntegrated %>&sAction=<%= sActionField %>&iIdOnglet=4&iIdAutoFormField=" + iIdAutoFormField;
		Redirect(sUrl );
	}

// -->
</script>
</head>
<body >
<%@ include file="../../include/new_style/headerFiche.jspf" %>
<form name="formulaire" action="<%= response.encodeURL("modifyAutoFormFieldMacro.jsp") %>" method="post" >
<div id="fiche">
<div class="sectionTitle"><div>Propriétés de la macro</div></div>
<div class="sectionFrame">
	<input type="hidden" name="iIdAutoFormFieldMacros" value="<%= macros.getId() %>" />
	<input type="hidden" name="iIdAutoFormField" value="<%= macros.getIdAutoFormField() %>" />
	<input type="hidden" name="iIdAutoFormFieldMacro" value="<%= macro.getId() %>" />
	<input type="hidden" name="sAction" value="<%= sAction %>" />
	<input type="hidden" name="bIsIntegrated" value="<%= bIsIntegrated %>" />
	<input type="hidden" name="bRecurseForm" value="<%= bRecurseForm %>" />
	<table summary="none">
		<%= hbTableTr.getHtmlTrInput("Nom :", "sName", macro.getName() ) %>
		<tr>
			<td class="pave_cellule_gauche"> Type : </td>
			<td class="pave_cellule_droite"><%= type.getAllInHtmlSelect("iIdAutoFormFieldMacroType") %></td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche"> Visibility : </td>
			<td class="pave_cellule_droite"><%= visibility.getAllInHtmlInputRadio("iIdAutoFormFieldMacroVisibility") %></td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche"> Javascript : </td>
			<td class="pave_cellule_droite"><textarea name="sJavascript" cols="60" rows="10"><%= macro.getJavascript() %></textarea></td>
		</tr>
	</table>
</div>
</div>
<div id="fiche_footer">
		<input 
			type="submit" 
			value="Valider" 
		 />
		 <%
	if(sAction.equals("store"))
	{
%>
		<input 
			type="button" 
			value="Supprimer" 
			onclick="javascript:removeMacro(<%= macro.getId() + "," + macros.getIdAutoFormField()%>)" />
<%
	} 
%>
<input 
			type="button" 
			value="Annuler" 
			onclick="javascript:displayField(<%= macros.getIdAutoFormField() %>)" />
</div>
</form>
<%@ include file="../../include/new_style/footerFiche.jspf" %>
</body>
</html>