
<%@ page import="org.coin.bean.form.*,java.security.cert.*,java.io.*,java.util.*" %>
<%@ include file="../include/beanSessionUser.jspf" %>
<%
	String rootPath = request.getContextPath()+"/";
	long lIdAutoForm = -1;
	String sUrl = "";
	String sAction = request.getParameter("sAction");
	AutoForm autoform = AutoForm.getAutoForm(Integer.parseInt(request.getParameter("iIdAutoForm")) ) ; 
	String sSQL = "";
	if(sAction.equals("create"))
	{
		Vector<AutoFormField> vFormFields = autoform.getAllFields(true);
		for (int i = 0; i < vFormFields.size(); i++) {
			AutoFormField field = vFormFields.get(i);
			field.setValue(request, "");
		}

		TypedDataEntered tde = new TypedDataEntered(1, autoform.getId());
		tde.setFieldsVector(vFormFields);
		sSQL = tde.computeSqlQueryInsertInto();
		
		lIdAutoForm = autoform.getId();
		sUrl = "displayAutoForm.jsp?iIdAutoForm=" + lIdAutoForm ;
	}
	
	if(sAction.equals("store"))
	{
	}
	
	if(sAction.equals("remove"))
	{
	}	
	
	if(sAction.equals("serialize"))
	{
		sSQL = autoform.serialize(); 
	}
	if(sAction.equals("serializeData"))
	{
		sSQL = autoform.serializeDataFromForm(request); 
	}
	
	//response.sendRedirect(response.encodeRedirectURL( sUrl + "&nonce=" + System.currentTimeMillis()));
	
 %>
<%= org.coin.util.Outils.getTextToHtml(sSQL ) %>