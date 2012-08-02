<%@page import="org.coin.bean.User"%>
<%@page import="org.coin.db.ConnectionManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="org.coin.util.excel.ImportXLSUtil"%>
<%@page import="org.coin.db.CoinDatabaseAbstractBean"%>
<%@page import="java.util.Vector"%>
<%@page import="org.coin.db.CoinDatabaseAbstractBeanHtmlUtil"%>
<%@page import="org.coin.fr.bean.PersonnePhysiqueCivilite"%>
<%@page import="org.coin.fr.bean.PersonnePhysique"%>
<%@page import="org.coin.bean.ObjectType"%>
<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="org.coin.util.excel.PoiExcelUtil"%>
<%@page import="org.coin.util.excel.ImportXLS"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFRow"%>
<%@page import="org.coin.util.excel.ImportXLSException"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Iterator"%>
<%@page import="org.coin.fr.bean.Organisation"%>
<%@page import="org.coin.util.HttpUtil"%>
<%@ include file="/include/new_style/headerDesk.jspf" %>
<%
    Iterator<?> iter = null;
    try {
    	iter = 	HttpUtil.getItemList(request);
    } catch (Exception e) {}

	long lIdOrganization = HttpUtil.parseLong("lIdOrganization", request);
	boolean bImportFile = HttpUtil.parseBoolean("bImportFile", request, true);
	Organisation organization = Organisation.getOrganisation(lIdOrganization);
	Connection conn = ConnectionManager.getConnection();
	request.setAttribute("conn", conn);
	
	String sTitle = "Synchro Excel Person in organisation " + organization;
	String sEncodingType = "";
    HashMap<String, String> hashMap = new HashMap<String, String>();
	StringBuffer sbHtmlTable = null;

	if(bImportFile)
	{
		sEncodingType = "enctype='multipart/form-data' " ;
	} else {
		/**
		 * create sync file form
		 */
		FileItem itemFieldExcelFile = null;
		 
	    while (iter.hasNext()) {
	        FileItem itemField = (FileItem) iter.next();
	        if (itemField.isFormField()) {

	        	hashMap.put(itemField.getFieldName(), itemField.getString()) ;
	        	
	        } else {
	            if(itemField.getFieldName().equals("fileExcel") )
	            {
	            	itemFieldExcelFile = itemField;
	            }
	    	}
		}
				
	    
	    
		ImportXLS xls = new ImportXLS(){
			
			public int[] computeImportFromExcelRow(HSSFRow row){
				int[] ret = new int[2]; 
				StringBuffer sb = (StringBuffer)this.mapContext.get("buffer");
				StringBuffer sbColumn = new StringBuffer ();
				boolean bIsDataRow = false;
				ret[0] = 2; // iColumnCount
				ret[1] = 0; // iEmptyColumnCount
				Connection conn = (Connection ) this.oContextConn;
				
				PersonnePhysique person = null;
				User user = null;
				long lIdTypeObjectSync = ObjectType.PERSONNE_PHYSIQUE;

				long lIdTypeObject = 0;
				long lIdReferenceObject = 0;

				try {
					lIdTypeObject = Long.parseLong(PoiExcelUtil.getExcelCellValue(row, 1));
					lIdReferenceObject = Long.parseLong(PoiExcelUtil.getExcelCellValue(row, 0));
				} catch (Exception e) {}
				
				if(lIdReferenceObject == 0) {
					boolean bEmptyLine = true;
					for(int i=0 ; i < 15; i++)
					{
						String sVal = PoiExcelUtil.getExcelCellValueOptional(row, 1);
						if(!sVal.equals(""))
						{
							bEmptyLine = false;
							break;
						}
					}
					if(bEmptyLine)
					{
						return ret;
					} else {
						/**
						 * a new one to sync
						 */
						person = new PersonnePhysique();
						lIdTypeObject = lIdTypeObjectSync;
					}
				}
				
				
				try {
					if(person == null)
					{
						person = PersonnePhysique.getPersonnePhysique(lIdReferenceObject, false, conn);
						
						try{
							user = User.getUserFromIdIndividual(person.getId(), false, conn); 
						} catch (Exception ee) {
							user = new User();
						}
					}
					
					String sFormPrefix = "person_" + lIdReferenceObject + "_";
					boolean bUseUndefined = true;
					
					ImportXLSUtil util = new ImportXLSUtil(sFormPrefix, row);
					
					
					String sPersonTitle = PoiExcelUtil.getExcelCellValueOptional(row, 2);
					PersonnePhysiqueCivilite title = null;
					try {
						title = (PersonnePhysiqueCivilite)
						 	CoinDatabaseAbstractBean.getCoinDatabaseAbstractBeanFromName(
								 sPersonTitle,
								 PersonnePhysiqueCivilite.getAllStaticMemory(false));
					} catch(Exception e) {
						title = new PersonnePhysiqueCivilite();
					}
					
					sbColumn.append("<tr>");
					sbColumn.append("<td>" + person.getId() + "</td>");

					sbColumn.append("<td>");
					sbColumn.append(
							CoinDatabaseAbstractBeanHtmlUtil.getHtmlSelect(
									sFormPrefix + "iIdTitle",
									1,
									(Vector) PersonnePhysiqueCivilite.getAllStaticMemory(false),
									title.getId(),
									"",
									bUseUndefined ,
									false,
									"-- unknown : " +  sPersonTitle + " --",
									"")
					);
					sbColumn.append("</td>");

					sbColumn.append(util.getHtmlTrFromExcelRow("sNom", person.getNom(), 3));
					sbColumn.append(util.getHtmlTrFromExcelRow("sPrenom", person.getPrenom(), 4));
					sbColumn.append(util.getHtmlTrFromExcelRow("sFonction", person.getFonction(), 5));
					sbColumn.append(util.getHtmlTrFromExcelRow("sEmail", person.getEmail(), 6));

					sbColumn.append("<td>");
					sbColumn.append(
							CoinDatabaseAbstractBeanHtmlUtil.getHtmlSelect(
									sFormPrefix + "iIdUserStatus",
									1,
									(Vector) PersonnePhysiqueCivilite.getAllStaticMemory(false),
									title.getId(),
									"",
									bUseUndefined ,
									false,
									"-- unknown : " +  sPersonTitle + " --",
									"")
					);
					sbColumn.append("</td>");

					
					sbColumn.append(util.getHtmlTrFromExcelRow("sIdUserStatus", "" + user.getIdUserStatus(), 7));
					sbColumn.append(util.getHtmlTrFromExcelRow("sLogin", user.getLogin(), 8));
					sbColumn.append(util.getHtmlTr("sPassword", "", ""));
					sbColumn.append(util.getHtmlTr("sRole", "", ""));
					sbColumn.append(util.getHtmlTr("sCertificate", "", ""));
					sbColumn.append(util.getHtmlTr("sService", "", ""));
					sbColumn.append(util.getHtmlTr("sPoste", "", ""));
					
					
					
					/*
					sbColumn.append("<td>");
					sbColumn.append("<input type='text' "
							+ "name=\"" + sFormPrefix + "sPrenom" + "\" "
							+ "value=\"" + sPersonFirstName + "\" "
							+ "/>");
					sbColumn.append("</td>");
					*/
					
					sbColumn.append("</tr>");
			
					sb.append(sbColumn);
				} catch (Exception e) {
					e.printStackTrace();
				}
				
				return ret ;	
			}
			
			public void traitmentImportFromExcelRow(HSSFRow row) 
			throws ImportXLSException{
		
			}
			
		};
		
		
		xls.iBreakRow = 2000;
		xls.mapContext.put("buffer",new StringBuffer(""));
		xls.mapContext.put("rootPath",rootPath);
		xls.oContextConn = conn;
		
		InputStream is = itemFieldExcelFile.getInputStream();
		String sRapport = xls.importExcelFile(is,0);
		try {
			is.close();
		} catch (Exception e ) {}
		
		sbHtmlTable = (StringBuffer)xls.mapContext.get("buffer");
					
	}
	
	
	
%>
</head>
<body >
<%@ include file="/include/new_style/headerFiche.jspf" %>
<form action="<%= response.encodeURL(
			rootPath + "desk/organisation/sync/syncPersonForm.jsp"
			+ "?lIdOrganization=" + lIdOrganization 
			+ "&bImportFile=false") %>" 
			method="post" 
			<%= sEncodingType %> >

<%
if(bImportFile)
{
%>
Fichier Excel: <input type="file" name="fileExcel" /><br/>
<%	
} else {
%>	
<table>
<tr>
<th>id</th>
<th>civilité</th>
<th>nom</th>
<th>prénom</th>
<th>fonction</th>
<th>email</th>
<th>statut(type)</th>
<th>identifiant</th>
<th>mot de passe</th>
<th>rôles (groupes)</th>
<th>génération de certificat</th>
<th>service</th>
<th>poste</th>
</tr>
<%= sbHtmlTable.toString() %>
</table>
<%	
}
%>


<button type="submit"><%= localizeButton.getValueSubmit() %></button>
<button type="button" onclick="doUrl('<%= 
		response.encodeURL(
				rootPath + "desk/organisation/afficherOrganisation.jsp"
				+ "?iIdOrganisation=" + lIdOrganization
				+ "&iIdOnglet=" + Onglet.ONGLET_ORGANISATION_PERSONNES )
				%>');"><%= localizeButton.getValueCancel() %></button>


</form>
<%

	ConnectionManager.closeConnection(conn);

%>

<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
</html>