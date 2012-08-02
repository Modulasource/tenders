/*
 * Created on 5 avr. 2005
 *
 */
package org.coin.fr.bean;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Vector;

import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;

import org.coin.db.CoinDatabaseAbstractBean;
import org.coin.db.CoinDatabaseLoadException;
import org.coin.db.CoinDatabaseStoreException;
import org.coin.db.ConnectionManager;
import org.coin.util.Outils;

/**
 * @author d.keller
 *
 */
public class OrganisationParametre extends CoinDatabaseAbstractBean {

	private static final long serialVersionUID = 1L;
	protected int iIdOrganisation;
	protected String sName;
	protected String sValue;
	
	public final static String PARAM_PARAPH_FOLDER_ORGANIGRAM_NODE_ORDER_BY = "paraph.folder.organigram.node.orderby";
	public final static String PARAM_VALUE_PARAPH_FOLDER_ORGANIGRAM_NODE_ORDER_ALPHABETIC = "alphabetic";
	public final static String PARAM_VALUE_PARAPH_FOLDER_ORGANIGRAM_NODE_ORDER_HIERARCHIC = "hierarchic";

   public void init()
	{
		this.TABLE_NAME = "organisation_parametre";
		this.FIELD_ID_NAME = "id_"+ this.TABLE_NAME ;
		
		this.SELECT_FIELDS_NAME 
			= " id_organisation, "
			+ " name, "
			+ " value ";
 
		this.SELECT_FIELDS_NAME_SIZE = this.SELECT_FIELDS_NAME.split(",").length ; 

		this.lId = 0;
		this.iIdOrganisation = 0;
		this.sName = "";
		this.sValue= "";
		
		//mis à défaut à false pour éviter des surprises
		this.bUseHttpPrevent = false;
		
	}
	public OrganisationParametre()
	{
		init();
	}

	public OrganisationParametre(int iIdOrganisationParametre)
	{
		init();
		this.lId= iIdOrganisationParametre;
	}
	
	public static OrganisationParametre getOrganisationParametre (int iIdOrganisationParametre) 
	throws CoinDatabaseLoadException, NamingException, SQLException
	{
		OrganisationParametre item = new OrganisationParametre(iIdOrganisationParametre );
		item.load();
		return item;
	}
	
	
	public static int incrementIntValue(
			int iIdOrganisation, 
			String sParamName,
			Connection conn)
	throws CoinDatabaseLoadException, SQLException, InstantiationException, IllegalAccessException, NamingException, CoinDatabaseStoreException 
	{
		OrganisationParametre param = 
			OrganisationParametre.getOrganisationParametre(
					iIdOrganisation, 
					sParamName ,
					conn);
			
		int iValue = Integer.parseInt(param.getValue()); 
		iValue++;
		
		param.setValue("" + iValue);
		param.store(conn);
		
		return iValue;
	}
	
	public static int incrementIntValue(int iIdOrganisation, String sParamName)
	throws CoinDatabaseLoadException, SQLException, InstantiationException, IllegalAccessException, NamingException, CoinDatabaseStoreException
	{
		OrganisationParametre param = 
			OrganisationParametre.getOrganisationParametre(iIdOrganisation, sParamName );
			
		int iValue = Integer.parseInt(param.getValue()); 
		iValue++;
		
		param.setValue("" + iValue);
		param.store();
		
		return iValue;
	}
	

	public static Vector<OrganisationParametre> getAllFromIdOrganisation(int iIdOrganisation) 
	throws SQLException, NamingException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException 
	{
		OrganisationParametre item = new OrganisationParametre ();
	
		return item.getAllWithWhereAndOrderByClause(
				" WHERE id_organisation =" + iIdOrganisation,
				 " ORDER BY name");
		
	}	
	
	public static Vector<OrganisationParametre> getAllStartWithFromIdOrganisation(long lIdOrganisation, String sStartWith) 
	throws SQLException, NamingException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException 
	{
		OrganisationParametre item = new OrganisationParametre ();
		return item.getAllWithWhereAndOrderByClause(
				" WHERE id_organisation =" + lIdOrganisation
				+" AND name LIKE '" + Outils.addLikeSlashes(sStartWith) + "%' ",
				 " ORDER BY name");
		
	}	

	
	public static boolean isTrue(
			long lIdOrganisation, 
			String sName,
			Connection conn)
	throws SQLException, InstantiationException, IllegalAccessException 
	{
		String sValue = getOrganisationParametreValueOptional(lIdOrganisation, sName, conn);
		return sValue.equals("true");
	}	
	
	public static boolean isTrue(
			long lIdOrganisation, 
			String sName,
			boolean bDefaultValue,
			Connection conn)
	throws SQLException, InstantiationException, IllegalAccessException 
	{
		try {
			String sValue = getOrganisationParametre(lIdOrganisation, sName, conn ).getValue();
			return sValue.equals("true");
		} catch (CoinDatabaseLoadException e) {
			return bDefaultValue;
		}
	}	
	
	public static boolean isEnabled(
			long lIdOrganisation, 
			String sName,
			Connection conn)
	throws SQLException, InstantiationException, IllegalAccessException 
	{
		String sValue = getOrganisationParametreValueOptional(lIdOrganisation, sName, conn);
		return sValue.equals("enabled");
	}
	
	public static boolean isEnabled(
			long lIdOrganisation, 
			String sName,
			boolean bDefaultValue,
			Connection conn)
	throws SQLException, InstantiationException, IllegalAccessException 
	{
		try {
			String sValue = getOrganisationParametre(lIdOrganisation, sName, conn ).getValue();
			return sValue.equals("enabled");
		} catch (CoinDatabaseLoadException e) {
			return bDefaultValue;
		}
	}	
	
	
	public static String getOrganisationParametreValueOptional(
			long lIdOrganisation, 
			String sName ,
			Connection conn)
	throws SQLException, InstantiationException, IllegalAccessException 
 	{
		try {
			return getOrganisationParametre(lIdOrganisation, sName, conn ).getValue();
		} catch (CoinDatabaseLoadException e) {
			return "";
		}
	}

	
	public static String getOrganisationParametreValueOptional(int iIdOrganisation, String sName ) 
	{
		try {
			return getOrganisationParametre(iIdOrganisation, sName ).getValue();
			
		} catch (Exception e) {
			return "";
		}
	}
	
	public static String getOrganisationParametreValue(String sIdOrganisation, String sName, String sDefaultValue ) 
	throws CoinDatabaseLoadException, SQLException, InstantiationException, IllegalAccessException, NamingException  {
		try{
			return getOrganisationParametreValue(Integer.parseInt(sIdOrganisation), sName ) ;
		}catch(CoinDatabaseLoadException ce){
			return sDefaultValue;
		}
	}

	public static String getOrganisationParametreValue(String sIdOrganisation, String sName ) 
	throws CoinDatabaseLoadException, SQLException, InstantiationException, IllegalAccessException, NamingException  {
		return getOrganisationParametreValue(Integer.parseInt(sIdOrganisation), sName ) ;
	}
	
	public static String getOrganisationParametreValue(long lIdOrganisation, String sName ) 
	throws CoinDatabaseLoadException, SQLException, InstantiationException,
	IllegalAccessException, NamingException  {
		Connection conn = ConnectionManager.getDataSource().getConnection(); 
		
		try {
			return getOrganisationParametreValue(lIdOrganisation, sName, conn);
		} finally{
			ConnectionManager.closeConnection(conn);	
		}		
	}	
	
	public static String getOrganisationParametreValue(
			long lIdOrganisation, 
			String sName , 
			Connection conn) 
	throws CoinDatabaseLoadException, SQLException, InstantiationException, IllegalAccessException 
	{
		return getOrganisationParametre(lIdOrganisation, sName,conn ).getValue();
	}	

	public static OrganisationParametre getOrganisationParametre(String sIdOrganisation, String sName ) 
	throws CoinDatabaseLoadException, SQLException, InstantiationException, IllegalAccessException, NamingException
	{
		return getOrganisationParametre(Integer.parseInt(sIdOrganisation), sName);
	}
	
	public static OrganisationParametre getOrganisationParametre(int iIdOrganisation, String sName ) 
	throws CoinDatabaseLoadException, SQLException, InstantiationException, IllegalAccessException, NamingException
	{
		Connection conn = ConnectionManager.getDataSource().getConnection(); 
		
		try {
			return getOrganisationParametre(iIdOrganisation, sName, conn);
		} finally{
			ConnectionManager.closeConnection(conn);	
		}		
	
	}
	
	public static OrganisationParametre getOrganisationParametre(
			long lIdOrganisation, 
			String sName, 
			Connection conn) 
	throws CoinDatabaseLoadException, SQLException, InstantiationException, IllegalAccessException 
	{
		OrganisationParametre item = new OrganisationParametre ();

		Vector<OrganisationParametre> vexp =  item.getAllWithWhereAndOrderByClause(
				" WHERE id_organisation =" + lIdOrganisation
				+ " AND name ='" + sName + "' ",
				" ORDER BY name",
				conn);

		if (vexp.size() >0 ) 
		{
			return vexp.get(0);
		}
		CoinDatabaseLoadException ee 
		= new CoinDatabaseLoadException ("Le paramètre '"
				+sName + "' est indéfini pour l'iIdOrganisation = " + lIdOrganisation, "");
		throw (ee);

	}	

	public static Vector<OrganisationParametre> getAllStartWith(String sStartWith) 
	throws SQLException, NamingException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException 
	{
		OrganisationParametre item = new OrganisationParametre ();
		
		return item.getAllWithWhereAndOrderByClause(
			 " WHERE name LIKE '" + Outils.addLikeSlashes(sStartWith) + "%' ",
			 " ORDER BY name" );
	}

	
	public void setFromForm(HttpServletRequest request, String sFormPrefix)
	{
		this.iIdOrganisation = Integer.parseInt( request.getParameter(sFormPrefix + "iIdOrganisation"));
		this.sName = request.getParameter(sFormPrefix + "sName");
		this.sValue = request.getParameter(sFormPrefix + "sValue");
		
	}

	/**
	 * @return Returns the iIdExport.
	 */
	public int getIdOrganisation() {
		return this.iIdOrganisation;
	}
	/**
	 * @param idExport The iIdExport to set.
	 */
	public void setIdOrganisation(int idOrganisation) {
		this.iIdOrganisation = idOrganisation;
	}
	/**
	 * @return Returns the iIdExportParametre.
	 */
	public int getIdOrganisationParametre() {
		return (int)this.lId;
	}
	/**
	 * @param idExportParametre The iIdExportParametre to set.
	 */
	public void setIdOrganisationParametre(int iIdOrganisationParametre) {
		this.lId = iIdOrganisationParametre;
	}
	/**
	 * @return Returns the sName.
	 */
	public String getName() {
		return this.sName;
	}
	/**
	 * @param name The sName to set.
	 */
	public void setName(String name) {
		this.sName = name;
	}
	/**
	 * @return Returns the sValue.
	 */
	public String getValue() {
		return this.sValue;
	}
	/**
	 * @param value The sValue to set.
	 */
	public void setValue(String value) {
		this.sValue = value;
	}
	public void setFromResultSet(ResultSet rs) throws SQLException {
		this.iIdOrganisation = rs.getInt(1);
		this.sName = preventLoad(rs.getString(2));
		this.sValue = preventLoad(rs.getString(3));
		
	}
	public void setPreparedStatement(PreparedStatement ps) throws SQLException {
		ps.setInt(1, this.iIdOrganisation);
		ps.setString(2, preventStore(this.sName));
		ps.setString(3, preventStore(this.sValue));
		
	}
}
