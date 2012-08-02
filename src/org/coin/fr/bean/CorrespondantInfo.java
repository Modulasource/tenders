package org.coin.fr.bean;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Vector;
import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;
import org.coin.db.CoinDatabaseAbstractBean;
import org.coin.db.CoinDatabaseDuplicateException;
import org.coin.db.CoinDatabaseLoadException;
import org.coin.util.Outils;

public class CorrespondantInfo extends CoinDatabaseAbstractBean {

	private static final long serialVersionUID = 1L;
	private int iIdCorrespondant;
	protected String sName;
	protected String sTel;
	protected String sPoste;
	protected String sFax;
	protected String sSiteWeb;
	protected String sSiteWeb2;
	protected String sEmail;
	protected int iIdQaAdjudicateur;
	
	
	public void setPreparedStatement (PreparedStatement ps ) throws SQLException {
		int i = 0;
		ps.setInt(++i, getIdCorrespondant());
		ps.setString(++i, preventStore(this.sName));
		ps.setString(++i, preventStore(this.sTel));
		ps.setString(++i, preventStore(this.sPoste));
		ps.setString(++i, preventStore(this.sFax));
		ps.setString(++i, preventStore(this.sSiteWeb));
		ps.setString(++i, preventStore(this.sSiteWeb2));
		ps.setString(++i, preventStore(this.sEmail));
		ps.setInt(++i, this.iIdQaAdjudicateur);
	}
	
	public void setFromResultSet(ResultSet rs) throws SQLException {
		int i=0;
		this.iIdCorrespondant = rs.getInt(++i);
		this.sName = preventLoad(rs.getString(++i));
		this.sTel = preventLoad(rs.getString(++i));
		this.sPoste = preventLoad(rs.getString(++i));
		this.sFax = preventLoad(rs.getString(++i));
		this.sSiteWeb = preventLoad(rs.getString(++i));
		this.sSiteWeb2 = preventLoad(rs.getString(++i));
		this.sEmail = preventLoad(rs.getString(++i));
		this.iIdQaAdjudicateur = rs.getInt(++i);
	}
	
	public CorrespondantInfo() {
		init();
	}
	public CorrespondantInfo(long lId) {
		init();
		this.lId = lId;
	}
	
	public void init(){
		this.TABLE_NAME = "correspondant_info";
		this.FIELD_ID_NAME = "id_correspondant_info";
		this.SELECT_FIELDS_NAME 
		= " id_correspondant,"
			+" nom,"
			+" telephone,"
			+" poste,"
			+" fax,"
			+" site_web,"
			+" site_web_2,"
			+" email,"
			+" id_qa_adjudicateur";
		this.SELECT_FIELDS_NAME_SIZE = this.SELECT_FIELDS_NAME.split(",").length ; 
		this.lId = 0;
		this.iIdCorrespondant = 0;
		this.sName = "";
		this.sTel = "";
		this.sPoste = "";
		this.sFax = "";
		this.sSiteWeb = "";
		this.sSiteWeb2 = "";
		this.sEmail = "";
		this.iIdQaAdjudicateur = 0;
	}
	
	public static Vector<CorrespondantInfo> getAllFromCorrespondant(int iIdCorrespondant)throws NamingException, SQLException, InstantiationException, IllegalAccessException {
		return getAllFromCorrespondant(iIdCorrespondant,true);
	}
	public static Vector<CorrespondantInfo> getAllFromCorrespondant(int iIdCorrespondant,boolean bUseHttpPrevent)
	throws NamingException, SQLException, InstantiationException, IllegalAccessException {
		return getAllWithWhereAndOrderByClauseStatic(" WHERE id_correspondant="+iIdCorrespondant,"",bUseHttpPrevent);
	}
	
	public static CorrespondantInfo getCorrespondantInfoFromIdCorrespondant(
			long lIdCorrespondant,
			boolean bUseHttpPrevent)
	throws NamingException, SQLException, InstantiationException,
	IllegalAccessException, CoinDatabaseLoadException, CoinDatabaseDuplicateException {
		CorrespondantInfo item = new CorrespondantInfo();
		return (CorrespondantInfo) item.getAbstractBeanWithWhereAndOrderByClause(
				" WHERE id_correspondant="+lIdCorrespondant,
				"",
				bUseHttpPrevent);
	}
	
	public static CorrespondantInfo getCorrespondantInfoFromIdCorrespondant(
			long lIdCorrespondant,
			boolean bUseHttpPrevent,
			Connection conn)
	throws NamingException, SQLException, InstantiationException,
	IllegalAccessException, CoinDatabaseLoadException, CoinDatabaseDuplicateException {
		CorrespondantInfo item = new CorrespondantInfo();
		item.bUseEmbeddedConnection = true;
		item.connEmbeddedConnection= conn;
		
		return (CorrespondantInfo) item.getAbstractBeanWithWhereAndOrderByClause(
				" WHERE id_correspondant="+lIdCorrespondant,
				"",
				bUseHttpPrevent);
	}
	
	
	public static Vector<CorrespondantInfo> getAllFromCorrespondant(
			int iIdCorrespondant,
			boolean bUseHttpPrevent,
			Connection conn)
	throws NamingException, SQLException, InstantiationException, IllegalAccessException {
		CorrespondantInfo item = new CorrespondantInfo();
		item.bUseHttpPrevent = bUseHttpPrevent;
		return item.getAllWithWhereAndOrderByClause(" WHERE id_correspondant="+iIdCorrespondant, "", conn);
	}
	
	
	public static Vector<CorrespondantInfo> getAllWithSqlQueryStatic(String sSQLQuery)
	  throws InstantiationException, IllegalAccessException, NamingException, SQLException {
		CorrespondantInfo item = new CorrespondantInfo();
	  return getAllWithSqlQuery(sSQLQuery, item);
	 }
	 
	public static Vector<CorrespondantInfo> getAllStatic()
	 throws InstantiationException, IllegalAccessException, NamingException, SQLException {
		CorrespondantInfo item = new CorrespondantInfo();
	  return item.getAll();
	 }
	 
	public static Vector<CorrespondantInfo> getAllWithWhereAndOrderByClauseStatic(String sWhereClause, String sOrderByClause, boolean bUseHttpPrevent) throws NamingException, SQLException, InstantiationException, IllegalAccessException 
	{
		CorrespondantInfo item = new CorrespondantInfo();
		item.bUseHttpPrevent = bUseHttpPrevent;
		return item.getAllWithWhereAndOrderByClause(sWhereClause, sOrderByClause);
		
	}
	public static Vector<CorrespondantInfo> getAllWithWhereAndOrderByClauseStatic(String sWhereClause, String sOrderByClause) throws NamingException, SQLException, InstantiationException, IllegalAccessException 
	{
		return getAllWithWhereAndOrderByClauseStatic(sWhereClause,sOrderByClause,true);
		
	}

	public String getName() {
		return this.sName;
	}

	public int getIdCorrespondant(){
		return this.iIdCorrespondant;
	}
	
	public String getTelephone(){
		return this.sTel;
	}
	
	public String getFax(){
		return this.sFax;
	}
	
	public String getPoste(){
		return this.sPoste;
	}
	
	public String getSiteWeb(){
		return this.sSiteWeb;
	}
	
	public String getSiteWeb2(){
		return this.sSiteWeb2;
	}	
	
	public String getEmail(){
		return this.sEmail;
	}
	
	public void setFromForm(HttpServletRequest request, String sFormPrefix){
		this.sName = request.getParameter(sFormPrefix+"nom");
		this.sTel = request.getParameter(sFormPrefix+"tel");
		this.sFax = request.getParameter(sFormPrefix+"fax");
		this.sEmail = request.getParameter(sFormPrefix+"email");
		this.sSiteWeb = request.getParameter(sFormPrefix+"site_web");
		this.sSiteWeb2 = request.getParameter(sFormPrefix+"site_web_2");
		this.sPoste = request.getParameter(sFormPrefix+"poste");
		if(!Outils.isNullOrBlank(request.getParameter(sFormPrefix+"iIdQaAdjudicateur")))
			this.iIdQaAdjudicateur = Integer.parseInt(request.getParameter(sFormPrefix+"iIdQaAdjudicateur"));
	}
	
	public void setName(String name) {
		this.sName = name;
	}
	
	public void setIdCorrespondant(int iIdCorrespondant){
		this.iIdCorrespondant = iIdCorrespondant;
	}
	public void setTelephone(String sTel) {
		this.sTel = sTel;
	}
	public void setPoste(String sPoste) {
		this.sPoste = sPoste;
	}
	public void setFax(String sFax) {
		this.sFax = sFax;
	}
	public void setSiteWeb(String sUrl) {
		this.sSiteWeb = sUrl;
	}
	public void setSiteWeb2(String sUrl) {
		this.sSiteWeb2 = sUrl;
	}
	public void setEmail(String sEmail) {
		this.sEmail = sEmail;
	}

	public int getIdQaAdjudicateur() {
		return iIdQaAdjudicateur;
	}

	public void setIdQaAdjudicateur(int idQaAdjudicateur) {
		iIdQaAdjudicateur = idQaAdjudicateur;
	}
}