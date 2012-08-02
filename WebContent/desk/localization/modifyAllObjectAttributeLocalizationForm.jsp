<%@ include file="/include/new_style/headerDeskUtf8.jspf" %>
<%@page import="java.util.*, org.json.*" %>
<%@page import="org.coin.localization.*"%>
<%@page import="org.coin.db.ObjectLocalization"%>
<%@page import="java.sql.Connection"%>
<%@page import="org.coin.db.ConnectionManager"%>
<%@page import="org.coin.util.HttpUtil"%>
<%@page import="org.coin.fr.bean.Pays"%>
<%@page import="org.coin.db.CoinDatabaseAbstractBean"%>
<%@page import="org.coin.bean.ObjectType"%>
<%@page import="org.coin.db.ObjectAttributeLocalization"%>
<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFWorkbook"%>
<%@page import="java.io.InputStream"%>
<%@page import="org.apache.poi.poifs.filesystem.POIFSFileSystem"%>
<%@page import="org.coin.servlet.DownloadLocalizationExcelFileServlet"%>
<%@page import="org.coin.util.Outils"%>
<%

	String sTitle = "Localize matrix";
	
	Vector<Language> vLanguage = Language.getAllStaticMemory();
	Vector<Language> vLanguageSelected = new Vector<Language>();
	FileItem fileItem =  null;
	String sFileName = "";
	Connection conn = ConnectionManager.getConnection();
	long lIdTypeObject = -1;
	ObjectType objType = null;
	Map<String, String>[] mapOL = null;
	Map<String, String>[] mapOLOld = null;
	boolean bUseOldValuesCompare = false;
	 
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
		
			HSSFWorkbook wb = new HSSFWorkbook(fs);
			
			vLanguageSelected = DownloadLocalizationExcelFileServlet.getAllLanguageSelectedFromWorkbook(wb,conn);
			lIdTypeObject = DownloadLocalizationExcelFileServlet.getIdTypeObjectFromWorkbook(wb);
			objType = ObjectType.getObjectTypeMemory(lIdTypeObject);
			

			mapOL = DownloadLocalizationExcelFileServlet
				.prepareAttributeLocalizationMatrixString(wb,objType,conn);
			
			try {
				is.close();
			} catch (Exception e ) {}
			
			mapOLOld = ObjectAttributeLocalization.generateAttributeLocalizationMatrixString((int)lIdTypeObject, conn);
		}
		
	} catch (Exception e) {
		e.printStackTrace();
	}
	
	
	
	boolean bOnlyDisplay = false;
	if(request.getParameter( "form_display") != null)
		bOnlyDisplay = true;
	
	
	if(fileItem == null)
	{
		lIdTypeObject = HttpUtil.parseLong("lIdTypeObject", request);
		objType = ObjectType.getObjectTypeMemory(lIdTypeObject);
		for(Language l : vLanguage)
		{
			if(request.getParameter( "language_" + l.getId()) != null)
			{
				vLanguageSelected.add(l);
			}
		}
	
		mapOL = ObjectAttributeLocalization.generateAttributeLocalizationMatrixString((int)lIdTypeObject, conn);
	}
	
	String[] sAttributeName = objType.getObjectFieldNames();
	ConnectionManager.closeConnection(conn);
%>
</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<div id="fiche">

<form action="<%= response.encodeURL("modifyAllObjectAttributeLocalization.jsp") %>" 
	method="post" 
	accept-charset="UTF-8" >	
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
	
	for (Language lang : vLanguageSelected) {
%>	
			<td><%= lang.getName() %></td>
<%
	}	
%>
		</tr>
<%
	
	for (String sAttribute : sAttributeName) {
%>
		<tr >
			<td><%= sAttribute %></td>		
<%	
		
		for (Language lang : vLanguageSelected) {
			String sAttributeValue = null;
			sAttributeValue = mapOL[(int)lang.getId()].get(sAttribute);
			
			String sAttributeValueOld = null;
			if(bUseOldValuesCompare && mapOLOld!=null) sAttributeValueOld = mapOLOld[(int)lang.getId()].get(sAttribute);
			
			String sName = "";
			String sValue = "";
			String sCellStyle = "";
			sName = "ObjectAttributeLocalization_" 
				+ lang.getId()
				+ "_" + sAttribute;
			
			if(sAttributeValue != null)
			{
				sValue = sAttributeValue;
				
				if(bUseOldValuesCompare && Outils.isNullOrBlank(sAttributeValueOld) ){
					sCellStyle = " style='background-color:#FDF' ";
				}else if(sAttributeValueOld!=null && !sAttributeValue.equals(sAttributeValueOld)){
					sCellStyle = " style='background-color:#99CE8F' ";
				}
			}else if(bUseOldValuesCompare && !Outils.isNullOrBlank(sAttributeValueOld)){
				sValue = sAttributeValueOld;
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
					sValue %>" <%= sCellStyle %> />
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