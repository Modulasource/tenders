<%@ include file="/include/new_style/headerDeskUtf8.jspf" %>
<%@page import="org.coin.util.Outils"%>
<%@page import="org.coin.security.PreventInjection"%>
<%@page import="org.coin.bean.conf.Treeview"%>
<%@page import="org.coin.bean.ObjectType"%>
<%@page import="org.coin.db.CoinDatabaseAbstractBean"%>
<%@page import="java.util.*, org.json.*" %>
<%@page import="org.coin.localization.*"%>
<%@page import="org.coin.db.ObjectLocalization"%>
<%@page import="java.sql.Connection"%>
<%@page import="org.coin.db.ConnectionManager"%>
<%@page import="org.coin.util.HttpUtil"%>
<%
	boolean bUsePrevent = false;
	boolean bStripSlashes = false;
	Vector<Language> vLanguage = Language.getAllStaticMemory();
	Vector<Language> vLanguageSelected = new Vector<Language>();
	ObjectLocalization[][] arrOL = null;
	Map<String, ObjectLocalization>[] mapOL = null;
	
	Long lIdTypeObject = HttpUtil.parseLong("lIdTypeObject", request);
	ObjectType objType = ObjectType.getObjectTypeMemory(lIdTypeObject);
	int iPrimaryKeyType = HttpUtil.parseInt("iPrimaryKeyType", request);
	
	for(Language l : vLanguage)
	{
		if(request.getParameter( "language_" + l.getId()) != null)
		{
			vLanguageSelected.add(l);
		}
	}

	Connection conn = ConnectionManager.getConnection();
	
	Vector<CoinDatabaseAbstractBean> vReference = (Vector<CoinDatabaseAbstractBean>)objType.invokeObjectInstanceMethod("getAll");

	switch(iPrimaryKeyType)
	{
	case CoinDatabaseAbstractBean.PRIMARY_KEY_TYPE_LONG:
		arrOL = ObjectLocalization.generateObjectLocalization(lIdTypeObject, conn);
		break;
		
	case CoinDatabaseAbstractBean.PRIMARY_KEY_TYPE_STRING:
		mapOL = ObjectLocalization.generateObjectLocalizationString(lIdTypeObject, conn);
		break;
	}

	for (CoinDatabaseAbstractBean reference : vReference) {
		String sReferenceId = "";
		for (Language lang : vLanguageSelected) {
			ObjectLocalization ol = null;
			switch(iPrimaryKeyType)
			{
			case CoinDatabaseAbstractBean.PRIMARY_KEY_TYPE_LONG:
				sReferenceId = ""+reference.getId();
				if(reference.getId()<arrOL[(int)lang.getId()].length)
				    ol = arrOL[(int)lang.getId()][(int)reference.getId()];
				break;
				
			case CoinDatabaseAbstractBean.PRIMARY_KEY_TYPE_STRING:
				sReferenceId = reference.getIdString();
				ol = mapOL[(int)lang.getId()].get(reference.getIdString());
				break;
			}
			
			
			String sName = "ObjectLocalization_" 
				+ lang.getId()
				+ "_" + sReferenceId;
			
			String sValue = request.getParameter(sName);
			if(bUsePrevent) sValue = PreventInjection.preventStore(sValue);
			if(bStripSlashes) sValue = Outils.stripSlashes(sValue);

			//System.out.println("ref " + reference + " " + lang.getId() + " : " + sValue);
			if(!sValue.equals("") )
			{
				if(ol != null)
				{
					ol.setValueWithEncoding(sValue);
					ol.bUseHttpPrevent = false;
					ol.bUseFieldValueFilter = false;
					ol.store(conn);
				} else {
					ol = new ObjectLocalization();
					ol.setValueWithEncoding(sValue);
					ol.setIdLanguage(lang.getId());
					ol.setIdTypeObject(lIdTypeObject);
					switch(iPrimaryKeyType)
					{
					case CoinDatabaseAbstractBean.PRIMARY_KEY_TYPE_LONG:
						ol.setIdReferenceObject(reference.getId());
						break;
						
					case CoinDatabaseAbstractBean.PRIMARY_KEY_TYPE_STRING:
						ol.setIdReferenceObjectString(reference.getIdString());
						break;
					}
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