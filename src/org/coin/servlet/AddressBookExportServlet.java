package org.coin.servlet;

import java.io.IOException;
import java.io.OutputStream;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Vector;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.coin.bean.User;
import org.coin.bean.UserHabilitation;
import org.coin.db.CoinDatabaseUtil;
import org.coin.db.CoinDatabaseWhereClause;
import org.coin.db.ConnectionManager;
import org.coin.db.InputStreamDownloader;
import org.coin.fr.bean.Multimedia;
import org.coin.fr.bean.PersonnePhysique;
import org.coin.fr.bean.export.ExportAddressBookXls;
import org.coin.localization.Language;
import org.coin.security.SecureString;
import org.coin.util.HttpUtil;

public class AddressBookExportServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;


	protected void doGet(
			HttpServletRequest request,
			HttpServletResponse response) {


		String sDisposition = "attachement;";
		String sAction = HttpUtil.parseStringBlank("sAction", request);
		if(sAction.equalsIgnoreCase("view"))
			sDisposition = " ; ";

		String sContentType = "application/x-excel";
		String sContentLength ="";
		String sMode = HttpUtil.parseStringBlank("mode", request);
		
		String sFilename = "address_book_list_" + System.currentTimeMillis() + ".xls";
		if(sMode.equalsIgnoreCase("template"))
			sFilename = "address_book_list_template.xls";
		
		Connection conn = null;
		try {
			conn = ConnectionManager.getConnection();
			
			PersonnePhysique item = new PersonnePhysique();
			item.bUseHttpPrevent=false;
			item.bUseEmbeddedConnection=false;
			item.connEmbeddedConnection=conn;
			Vector<PersonnePhysique> vPersonne = new Vector<PersonnePhysique>();
			
			if(!sMode.equalsIgnoreCase("template")){
				if(!sMode.equalsIgnoreCase("all")){
					CoinDatabaseWhereClause wc =
						new CoinDatabaseWhereClause(CoinDatabaseWhereClause.ITEM_TYPE_INTEGER);
		
					wc.addArray(request.getParameter("selected"), ",");			
					
					vPersonne 
						=  item.getAllWithWhereAndOrderByClause(
								" WHERE " + wc.generateWhereClause("id_organisation"), 
								"",
								conn) ;
				}else{
										
					String sRequestSecure = HttpUtil.parseStringBlank("selected", request);
					String sMainAliasTable = HttpUtil.parseStringBlank("sMainAliasTable", request);
					
					String sRequest = SecureString.getSessionPlainString(
							sRequestSecure, 
							request.getSession());

					int iFrom = sRequest.lastIndexOf("FROM");
					int iSelect = sRequest.lastIndexOf("SELECT");
					
					String sStartRequest = sRequest.substring(0, iSelect);
					String sSubRequest = sRequest.substring(iSelect, iFrom);
					String sEndRequest = sRequest.substring(iFrom,sRequest.length());
					
					sSubRequest = sSubRequest.replaceFirst(sMainAliasTable+"."+item.FIELD_ID_NAME
							,PersonnePhysique.getSelectFieldsName(item.SELECT_FIELDS_NAME,sMainAliasTable+".",sMainAliasTable+"_") + ","+sMainAliasTable+"."+item.FIELD_ID_NAME);
										
					String sRecomposedRequest = sStartRequest + sSubRequest + sEndRequest;
					vPersonne = item.getAllWithSqlQuery(
							sRecomposedRequest, 
							conn);
					
					long[] lUnselected = HttpUtil.parseArrayLong("unselected", false, request);
					if(lUnselected.length>0){
						for(long lIdPersonnePhysique : lUnselected){
							CoinDatabaseUtil.remove(lIdPersonnePhysique, vPersonne);
						}
					}
				}
			}
			
			Multimedia template = ExportAddressBookXls.getAddressBookTemplate(conn);
			InputStreamDownloader isd = template.getInputStreamDownloaderMultimediaFile(conn);
						
			long lIdLanguage = 0;
			try{lIdLanguage = HttpUtil.parseLong("langFile", request);}
			catch(Exception e){
				Language lang = (Language)request.getSession().getAttribute("sessionLanguage");
				lIdLanguage = lang.getId();
			}
			User user = (User)request.getSession().getAttribute("sessionUser");
			UserHabilitation userHabilitation = (UserHabilitation)request.getSession().getAttribute("sessionUserHabilitation");

			HSSFWorkbook wb 
			= ExportAddressBookXls.exportExcelFile( 
						isd.is, 
						vPersonne,
						true,
						lIdLanguage,
						conn,
						user,
						userHabilitation);
			
			response.setContentType(sContentType);
			response.setHeader("Content-Disposition", sDisposition+" filename=\"" + sFilename+"\"");
			if(sContentLength != null && !sContentLength.equalsIgnoreCase(""))
				response.addHeader("length-file",sContentLength);
			OutputStream out = response.getOutputStream();
			wb.write(out);
			
			out.close();
			//isd.close(); 
			
		} catch (Exception e) {
			e.printStackTrace();
			try {
				OutputStream outError = response.getOutputStream();
				outError.write(e.getMessage().getBytes());
				outError.flush();
			} catch (IOException e1) {
				e1.printStackTrace();
			}
		} finally {
			try {
				ConnectionManager.closeConnection(conn);
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}


	




	protected void doPost(
			HttpServletRequest request,
			HttpServletResponse response) {
		doGet(request, response);
	}
}
