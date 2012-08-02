
<%@page import="org.json.JSONObject"%>
<%@page import="org.coin.util.HttpUtil"%>
<%@ page import="modula.graphic.*,org.coin.bean.html.*,org.coin.bean.form.*,java.security.cert.*,java.io.*,java.util.*" %>
<%
	String sUrl = "";
	int iIdOnglet = HtmlBeanTabVector.getCurrentIndex(request);
	String sAction = request.getParameter("sAction");
	
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

	if(sAction .equals("create"))
	{
		AutoForm autoform = AutoForm.getAutoForm(Long.parseLong(request.getParameter("iIdAutoForm")));

		AutoFormField field = new AutoFormField(); 
		field.setIdAutoFormFieldValueType(AutoFormFieldValueType.TYPE_STRING);
		field.setIdAutoFormFieldType(AutoFormFieldType.TYPE_INPUT);
		field.setIdAutoFormCaptionPosition(AutoFormPosition.TYPE_LEFT);
		field.setIdAutoForm(autoform.getId());
		field.setReference(0);
		
		field.setPosX(Integer.parseInt(request.getParameter("iPosX")));
		field.setPosY(Integer.parseInt(request.getParameter("iPosY")));
		
		field.create();
		field.setName("field_" + field.getId());
		field.setCaption("Libellé " + field.getId());
		field.store();
		
		sUrl = "displayAutoForm.jsp?iIdAutoForm=" + autoform.getId()+"&bIsIntegrated="+bIsIntegrated+"&bRecurseForm="+bRecurseForm ;
	}
	
	if(sAction.equals("store"))
	{
		AutoFormField field = AutoFormField.getAutoFormField (Long.parseLong(request.getParameter("iIdAutoFormField"))); 
		field.setFromFormIdentifier(request, "");
		if(iIdOnglet == Onglet.ONGLET_AUTOFORM_FIELD_GENERAL)
		{
			field.setFromFormTabGeneral(request, "");
		}
		if(iIdOnglet == Onglet.ONGLET_AUTOFORM_FIELD_VALEUR)
		{
			field.setFromFormTabField(request, "");
			boolean sMask_bUseJsonParam = HttpUtil.parseBooleanCheckbox("sMask_bUseJsonParam", request, false);
			System.out.println("sMask_bUseJsonParam : " + sMask_bUseJsonParam);
			if(sMask_bUseJsonParam)
			{
				/**
				 * compute JSON typping mask 
				 */
				JSONObject obj = new JSONObject();
				HttpUtil.putJSON("sMask_", "x", obj, request);
				HttpUtil.putJSON("sMask_", "y", obj, request);
				HttpUtil.putJSON("sMask_", "width", obj, request);
				HttpUtil.putJSON("sMask_", "height", obj, request);
				HttpUtil.putJSON("sMask_", "fontSize", obj, request);
				field.setMask(obj.toString());
			}
			
		}
		if(iIdOnglet == Onglet.ONGLET_AUTOFORM_FIELD_POSITION)
		{
			field.setFromFormTabPosition(request, "");
		}
		
		
		
		field.store();
		sUrl = "displayAutoFormField.jsp?iIdAutoFormField=" + field.getId() 
				+ "&sAction=" + "display"
				+ "&iIdOnglet=" + iIdOnglet
				+ "&bUpdateAndClose=true"
				+ "&bIsIntegrated="+bIsIntegrated
				+ "&bRecurseForm="+bRecurseForm;
		
	}
	
	if(sAction.equals("addOption"))
	{
		long lIdField = Long.parseLong(request.getParameter("iIdAutoFormField")); 
		AutoFormField field = AutoFormField.getAutoFormField (lIdField); 
		AutoFormFieldOption option = new AutoFormFieldOption();
		option.create();
		option.setIdAutoFormField(lIdField);
		if(field.getIdAutoFormFieldType() == AutoFormFieldType.TYPE_SELECT)
			option.setName("field_"+lIdField+"_option_"+option.getId());
		else
			option.setName(field.getName());
		option.setCaption("Option "+option.getId());
		option.store();
		
		sUrl = "displayAutoFormField.jsp?iIdAutoFormField=" + lIdField
				+ "&sAction=store"
				+ "&iIdOnglet=" + iIdOnglet
				+ "&bUpdateAndClose=true"
				+ "&bIsIntegrated="+bIsIntegrated
				+ "&bRecurseForm="+bRecurseForm;
		
	}
	
	if(sAction.equals("addSQL"))
	{
		long lIdField = Long.parseLong(request.getParameter("iIdAutoFormField")); 
		String sSQL = request.getParameter("sSQL");
		AutoFormFieldSQL sql = new AutoFormFieldSQL();
		sql.setIdAutoFormField(lIdField);
		sql.setSQL(sSQL);
		sql.create();
		
		sUrl = "displayAutoFormField.jsp?iIdAutoFormField=" + lIdField
				+ "&sAction=store"
				+ "&iIdOnglet=" + iIdOnglet
				+ "&bUpdateAndClose=true"
				+ "&bIsIntegrated="+bIsIntegrated
				+ "&bRecurseForm="+bRecurseForm;
	}
	
	if(sAction.equals("removeOption"))
	{
		long lIdField = Long.parseLong(request.getParameter("iIdAutoFormField")); 
		long lIdOption = Long.parseLong(request.getParameter("iIdOption")); 
		new AutoFormFieldOption().remove(lIdOption);
		
		sUrl = "displayAutoFormField.jsp?iIdAutoFormField=" + lIdField
				+ "&sAction=store"
				+ "&iIdOnglet=" + iIdOnglet
				+ "&bUpdateAndClose=true"
				+ "&bIsIntegrated="+bIsIntegrated
				+ "&bRecurseForm="+bRecurseForm;
		
	}
	
	if(sAction.equals("removeSQL"))
	{
		long lIdField = Long.parseLong(request.getParameter("iIdAutoFormField")); 
		long lIdSQL = Long.parseLong(request.getParameter("iIdSQL")); 
		new AutoFormFieldSQL().remove(lIdSQL);
		
		sUrl = "displayAutoFormField.jsp?iIdAutoFormField=" + lIdField
				+ "&sAction=store"
				+ "&iIdOnglet=" + iIdOnglet
				+ "&bUpdateAndClose=true"
				+ "&bIsIntegrated="+bIsIntegrated
				+ "&bRecurseForm="+bRecurseForm;
		
	}
	
	
	if(sAction.equals("remove"))
	{
		AutoFormField field = AutoFormField.getAutoFormField (Long.parseLong(request.getParameter("iIdAutoFormField"))); 
		sUrl = "displayAutoForm.jsp?iIdAutoForm=" + field.getIdAutoForm()+"&bIsIntegrated="+bIsIntegrated+"&bRecurseForm="+bRecurseForm ;
		field.removeWithObjectAttached();
	}	
	
	response.sendRedirect(response.encodeRedirectURL(sUrl + "&nonce=" + System.currentTimeMillis() ));
%>
