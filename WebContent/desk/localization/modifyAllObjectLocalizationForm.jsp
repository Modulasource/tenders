<%@ include file="/include/new_style/headerDeskUtf8.jspf" %>
<%@ page import="java.util.*, org.json.*" %>
<%@page import="org.coin.localization.*"%>
<%@page import="org.coin.db.ObjectLocalization"%>
<%@page import="java.sql.Connection"%>
<%@page import="org.coin.db.ConnectionManager"%>
<%@page import="org.coin.util.HttpUtil"%>
<%@page import="org.coin.fr.bean.Pays"%>
<%@page import="org.coin.db.CoinDatabaseAbstractBean"%>
<%@page import="org.coin.bean.ObjectType"%>
<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="java.io.InputStream"%>
<%@page import="org.apache.poi.poifs.filesystem.*"%>
<%@page import="org.coin.servlet.DownloadLocalizationExcelFileServlet"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFWorkbook"%>
<%@page import="org.coin.util.Outils"%>
<%

	String sTitle = "Localize matrix";
	
	Vector<Language> vLanguage = Language.getAllStaticMemory();
	Vector<Language> vLanguageSelected = new Vector<Language>();
	ObjectLocalization[][] arrOL = null;
	ObjectLocalization[][] arrOLOld = null;
	Map<String, ObjectLocalization>[] mapOL = null;
	Map<String, ObjectLocalization>[] mapOLOld = null;
	boolean bUseOldValuesCompare = false;
	
	FileItem fileItem =  null;
	String sFileName = "";
	boolean bOnlyDisplay = false;
	long lIdTypeObject = -1;
	ObjectType objType = null;
	Connection conn = ConnectionManager.getConnection();
	Vector<CoinDatabaseAbstractBean> vReference = null;
	int iPrimaryKeyType = -1;
	
	 
    /**
	 * look for a uploaded file
	 */
	try{
		fileItem = HttpUtil.getFirstFileItem(request);
		if(fileItem != null) {
			bUseOldValuesCompare = true;
			
			sFileName = fileItem.getName();
			InputStream is = fileItem.getInputStream();
			POIFSFileSystem fs = new POIFSFileSystem(is);
		
			// ne marche que pour Execel 2000(pas Excel 5.0)
			HSSFWorkbook wb = new HSSFWorkbook(fs);
			
			vLanguageSelected = DownloadLocalizationExcelFileServlet.getAllLanguageSelectedFromWorkbook(wb,conn);
			lIdTypeObject = DownloadLocalizationExcelFileServlet.getIdTypeObjectFromWorkbook(wb);
			objType = ObjectType.getObjectTypeMemory(lIdTypeObject);
			iPrimaryKeyType = (Integer)objType.invokeObjectInstanceMethod("getPrimaryKeyType");
			
			switch(iPrimaryKeyType)
			{
			case CoinDatabaseAbstractBean.PRIMARY_KEY_TYPE_LONG:
				arrOL = DownloadLocalizationExcelFileServlet.prepareObjectLocalization(wb,objType, conn);
				arrOLOld = ObjectLocalization.generateObjectLocalization(lIdTypeObject, conn);
				break;
				
			case CoinDatabaseAbstractBean.PRIMARY_KEY_TYPE_STRING:
				mapOL = DownloadLocalizationExcelFileServlet.prepareObjectLocalizationString(wb,objType, conn);
				mapOLOld = ObjectLocalization.generateObjectLocalizationString(lIdTypeObject, conn);
				break;
				
			}
			
			try {
				is.close();
			} catch (Exception e ) {}
		}
		
	} catch (Exception e) {
		e.printStackTrace();
	}
	
	
	if(fileItem == null)
	{
		if(request.getParameter( "form_display") != null)
			bOnlyDisplay = true;
		
		lIdTypeObject = HttpUtil.parseLong("lIdTypeObject", request);
		objType = ObjectType.getObjectTypeMemory(lIdTypeObject);
		
		iPrimaryKeyType = (Integer)objType.invokeObjectInstanceMethod("getPrimaryKeyType");
		
		for(Language l : vLanguage)
		{
			if(request.getParameter( "language_" + l.getId()) != null)
			{
				vLanguageSelected.add(l);
			}
		}
	
	
		switch(iPrimaryKeyType)
		{
		case CoinDatabaseAbstractBean.PRIMARY_KEY_TYPE_LONG:
			arrOL = ObjectLocalization.generateObjectLocalization(lIdTypeObject, conn);
			break;
			
		case CoinDatabaseAbstractBean.PRIMARY_KEY_TYPE_STRING:
			mapOL = ObjectLocalization.generateObjectLocalizationString(lIdTypeObject, conn);
			break;
			
		}
		  
	}
	vReference = (Vector<CoinDatabaseAbstractBean>)objType.invokeObjectInstanceMethod("getAll");

	
	ConnectionManager.closeConnection(conn);
%>
</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<div id="fiche">

<form action="<%= response.encodeURL("modifyAllObjectLocalization.jsp") %>" 
	method="post" 
	accept-charset="UTF-8" >	
<input type="hidden" name="iPrimaryKeyType" value="<%= iPrimaryKeyType %>" />
<input type="hidden" name="lIdTypeObject" value="<%= lIdTypeObject %>" />
<input type="hidden" name="System_bUsePreventInjectionFilter" value="false" />
<%
	for (Language lang : vLanguageSelected) {
%>	
<input type="hidden" name="<%= "language_" + lang.getId() %>" />
<%
	}	
%>	
	<div class="dataGridHolder fullWidth">
		<table class="dataGrid fullWidth">
		<tr >
		    <td style="text-align:right;width:30%">Type object : </td>
		    <td><%= objType.getName() %></td>
		</tr>
		<tr >
		    <td style="text-align:right;width:30%">Id object : </td>
		    <td><%= objType.getId() %></td>
		</tr>
		<tr >
		    <td style="text-align:right;width:30%">Action : </td>
		    <td>
		        <% if(!bOnlyDisplay){ %>
		    	<button type="submit" >Submit</button>
		    	<% } %>
		    	<button type="button" onclick="doUrl('<%= response.encodeURL("admin.jsp")
		    			%>')" ><%= localizeButton.getValueCancel() %></button>
		     </td>
		</tr>
		</table>
	</div>

	<br/>
	<br/>

	<div class="dataGridHolder fullWidth">
		<table class="dataGrid fullWidth">
		<tr class="header">
		    <td>Name</td>
<%
	
	for (Language captionValue : vLanguageSelected) {
%>	
			<td><%= captionValue.getName() %></td>
<%
	}	
%>
		</tr>
<%
	
	for (CoinDatabaseAbstractBean reference : vReference) {
		String sReferenceId = "";
%>
		<tr >
			<td><%= reference.getName() %></td>		
<%	
		
		for (Language lang : vLanguageSelected) {
			ObjectLocalization ol = null;
			ObjectLocalization olOld = null;
			switch(iPrimaryKeyType)
			{
			case CoinDatabaseAbstractBean.PRIMARY_KEY_TYPE_LONG:
				sReferenceId = ""+reference.getId();
				if(reference.getId()<arrOL[(int)lang.getId()].length)
					ol = arrOL[(int)lang.getId()][(int)reference.getId()];
				if(bUseOldValuesCompare && arrOLOld!=null && reference.getId()<arrOLOld[(int)lang.getId()].length)
					olOld = arrOLOld[(int)lang.getId()][(int)reference.getId()];
				break;
				
			case CoinDatabaseAbstractBean.PRIMARY_KEY_TYPE_STRING:
				sReferenceId = reference.getIdString();
				ol = mapOL[(int)lang.getId()].get(reference.getIdString());
				if(bUseOldValuesCompare && mapOLOld != null)
					olOld = mapOLOld[(int)lang.getId()].get(reference.getIdString());
				break;
				
			}
			
			
			String sName = "";
			String sValue = "";
			String sCellStyle = "";
			sName = "ObjectLocalization_" 
				+ lang.getId()
				+ "_" + sReferenceId;
			
			if(ol != null && !ol.getValue().equals(""))
			{
				sValue = ol.getValue();
				if(bUseOldValuesCompare && (olOld==null || (olOld!=null && Outils.isNullOrBlank(olOld.getValue())) ) ){
					sCellStyle = " style='background-color:#FDF' ";
				}else if(olOld!=null && olOld.getValue()!=null && !sValue.equals(olOld.getValue())){
					sCellStyle = " style='background-color:#99CE8F' ";
				}
			} else if(bUseOldValuesCompare && olOld!=null && !Outils.isNullOrBlank(olOld.getValue())){
				sValue = olOld.getValue();
			} else {
				sValue = "";
				sCellStyle = " style='background-color:#FDF' ";
			}
			
			%>	
				<td>
				<% if(bOnlyDisplay){ %>
				<label><%= sValue %></label>
				<%}else{ %>
				<input type="text" name="<%= 
					sName %>" value="<%= 
					sValue %>" <%= sCellStyle %> size="40" />
			     <%} %>
			     </td>
			<%
		}	
%>
		</tr >
<%	
	}	
%>
	
	</table>
	</div>
</form>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
</html>