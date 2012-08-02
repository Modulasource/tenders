<%@ include file="/include/new_style/headerDeskUtf8.jspf" %>
<%@page import="org.coin.util.Outils"%>
<%@page import="org.coin.security.PreventInjection"%>
<%@page import="org.coin.db.ObjectAttributeLocalization"%>
<%@page import="org.coin.bean.ObjectType"%>
<%@page import="org.coin.db.CoinDatabaseAbstractBean"%>
<%@page import="java.util.*, org.json.*" %>
<%@page import="org.coin.localization.*"%>
<%@page import="org.coin.db.ObjectLocalization"%>
<%@page import="java.sql.Connection"%>
<%@page import="org.coin.db.ConnectionManager"%>
<%@page import="org.coin.util.HttpUtil"%>
<%
	Vector<Language> vLanguage = Language.getAllStaticMemory();
	Vector<Language> vLanguageSelected = new Vector<Language>();
    boolean bUsePrevent = false;
    boolean bStripSlashes = false;

	long lIdTypeObject = HttpUtil.parseLong("lIdTypeObject", request);
	ObjectType objType = ObjectType.getObjectTypeMemory(lIdTypeObject);
	
	for(Language l : vLanguage)
	{
		if(request.getParameter( "language_" + l.getId()) != null)
		{
			vLanguageSelected.add(l);
		}
	}

	Connection conn = ConnectionManager.getConnection();
	
	Vector<ObjectAttributeLocalization> v = ObjectAttributeLocalization.getAllFromIdObjectType(
            lIdTypeObject,
            conn);  
    String[] sAttributeName = objType.getObjectFieldNames();
    
    Map<String, ObjectAttributeLocalization>[] mapOL = ObjectAttributeLocalization.generateAttributeLocalizationString((int)lIdTypeObject, conn);

	for (String sAttribute : sAttributeName) {
		for (Language lang : vLanguageSelected) {
			ObjectAttributeLocalization ol = mapOL[(int)lang.getId()].get(sAttribute);

			String sName = "";
			sName = "ObjectAttributeLocalization_" 
				+ lang.getId()
				+ "_" + sAttribute;
			
			String sValue = request.getParameter(sName);
			if(bUsePrevent) sValue = PreventInjection.preventStore(sValue);
			if(bStripSlashes) sValue = Outils.stripSlashes(sValue);
			if(!sValue.equals("") )
			{
				if(ol != null)
				{
					ol.setAttributeLabelWithEncoding(sValue);
					ol.store(conn);
				} else {
					ol = new ObjectAttributeLocalization();
					ol.setAttributeLabelWithEncoding(sValue);
					ol.setIdLanguage(lang.getId());
					ol.setIdTypeObject(lIdTypeObject);
					ol.setAttributeName(sAttribute);
					ol.create(conn);
				}
			} else {
				if(ol != null && sValue.equals("") )
				{
					ol.remove(conn);
				}
			}
			
		}
	}
	objType.invokeObjectInstanceMethod("updateLocalization");

	
	ConnectionManager.closeConnection(conn);
	

	response.sendRedirect(
		response.encodeRedirectURL(
				"admin.jsp"));
%>