<%@page import="modula.graphic.Onglet"%>

<%@ page import="org.coin.bean.form.*,java.security.cert.*,java.io.*,java.util.*" %>
<%@ include file="../include/beanSessionUser.jspf" %>
<%
	String sUrl = "";
	AutoFormFieldMacro macro = null;
	AutoFormFieldMacros macros = null;

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
	
	if(sAction.equals("create"))
	{
		AutoFormField field = AutoFormField.getAutoFormField(
				Long.parseLong(request.getParameter("iIdAutoFormField"))); 

		macros = new AutoFormFieldMacros();
		macros.setIdAutoFormField(field.getId());
		macro = new AutoFormFieldMacro ();
		macro.setFromForm(request, "");
		macros.setFromForm(request, "");

		macro.create();
		macros.setIdAutoFormFieldMacro(macro.getId());
		macros.create();
		
		sUrl = "displayAutoFormField.jsp?sAction="+sActionField+"&iIdOnglet=4&iIdAutoFormField=" + field.getId() + "&bIsIntegrated=" +bIsIntegrated+"&bRecurseForm=" +bRecurseForm ;
	}

	if(sAction.equals("store"))
	{
		AutoFormField field = AutoFormField.getAutoFormField(
				Long.parseLong(request.getParameter("iIdAutoFormField"))); 
		macro = AutoFormFieldMacro.getAutoFormFieldMacro(
					Integer.parseInt(request.getParameter("iIdAutoFormFieldMacro")));
		macro.setFromForm(request, "");
		macro.store();

		sUrl = "displayAutoFormField.jsp?sAction="+sActionField+"&iIdOnglet=4&iIdAutoFormField=" + field.getId()+ "&bIsIntegrated=" +bIsIntegrated +"&bRecurseForm=" +bRecurseForm ;
	}
	
	if(sAction.equals("storeFieldMacros"))
	{
		AutoFormField field = AutoFormField.getAutoFormField(
				Long.parseLong(request.getParameter("iIdAutoFormField"))); 

		// vider les anciennes valeurs
		macros = new AutoFormFieldMacros ();
		macros.remove(" WHERE id_autoform_field = " + field.getId());
		
		
		Vector vTypes = AutoFormFieldMacroType.getAllAutoFormFieldMacroType();
		for(int i = 0 ; i < vTypes.size(); i++)
		{
			AutoFormFieldMacroType type = (AutoFormFieldMacroType)vTypes.get(i);
			String sItemSelectedParam =  "iIdMacroType_" + type.getId() + "NewSelection";
			String sItemSelected = request.getParameter(sItemSelectedParam);
			if(sItemSelected != null)
			{
				int[] iarrItemId = org.coin.util.Outils.parserChaineVersEntier(sItemSelected, "|");
				if(iarrItemId != null)
				{
					for (int j = 0; j < iarrItemId.length; j++)
					{
						macros = new AutoFormFieldMacros ();
						
						macros.setIdAutoFormFieldMacro(iarrItemId[j]);
						macros.setIdAutoFormField(field.getId());
						macros.setMacroOrder(j+1);
						macros.create();
					}
				}
			}
		}
		
		sUrl = "displayAutoFormField.jsp?sAction="+sActionField
				+"&iIdOnglet="+Onglet.ONGLET_AUTOFORM_FIELD_MACRO
				+"&iIdAutoFormField=" + field.getId()+ "&bIsIntegrated=" +bIsIntegrated 
				+"&bRecurseForm=" +bRecurseForm ;
	}
	
	
	if(sAction.equals("remove"))
	{
		AutoFormField field = AutoFormField.getAutoFormField(
				Long.parseLong(request.getParameter("iIdAutoFormField"))); 
		macro = AutoFormFieldMacro.getAutoFormFieldMacro(
					Integer.parseInt(request.getParameter("iIdAutoFormFieldMacro")));

		// suppression de la macro et des liens associés
		macros = new AutoFormFieldMacros ();
		macros.remove(" WHERE id_autoform_field_macro = " + macro.getId());
		macro.remove();

		sUrl = "displayAutoFormField.jsp?sAction="+sActionField+"&iIdOnglet=4&iIdAutoFormField=" + field.getId()+ "&bIsIntegrated=" +bIsIntegrated+"&bRecurseForm=" +bRecurseForm  ;
		
		

	}	
	
	response.sendRedirect(response.encodeRedirectURL(sUrl + "&nonce=" + System.currentTimeMillis() ));
	
 %>
