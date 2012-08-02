
<%@ page import="org.coin.bean.form.*,java.security.cert.*,java.io.*,java.util.*" %>
<%@ include file="../include/beanSessionUser.jspf" %>
<%
	String rootPath = request.getContextPath()+"/";
	long lIdAutoForm = -1;
	String sUrl = "";
	String sAction = request.getParameter("sAction");

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
		AutoForm autoform = new AutoForm (); 
		
		autoform.create();
		autoform.setName("Form_" + autoform.getId());
		autoform.setCaption("Formulaire " + autoform.getId());
		autoform.setMaxRowIndex(3);
		autoform.setMaxColumnIndex(2);
		autoform.store();
		
		lIdAutoForm = autoform.getId();
		sUrl = rootPath+"desk/form/displayAutoForm.jsp?iIdAutoForm=" + lIdAutoForm + "&bIsIntegrated="+bIsIntegrated+ "&bRecurseForm="+bRecurseForm ;
	}
	
	if(sAction.equals("store"))
	{
		AutoForm autoform = AutoForm.getAutoForm(Integer.parseInt(request.getParameter("iIdAutoForm")) ) ; 
		
		autoform.setFromForm(request, "");
		autoform.store();
		
		lIdAutoForm = autoform.getId();
		sUrl = rootPath+"desk/form/displayAutoForm.jsp?iIdAutoForm=" + lIdAutoForm + "&bIsIntegrated="+bIsIntegrated+ "&bRecurseForm="+bRecurseForm;
	}
	
	if(sAction.equals("remove"))
	{
		AutoForm autoform = AutoForm.getAutoForm(Integer.parseInt(request.getParameter("iIdAutoForm")) ) ; 
		autoform.removeWithObjectAttached();
		sUrl = rootPath+"desk/form/displayAllAutoForm.jsp?";
	}	
	
	response.sendRedirect(response.encodeRedirectURL( sUrl + "&nonce=" + System.currentTimeMillis()));
	
 %>
