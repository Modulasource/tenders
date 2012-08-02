/*
 * Studio Matamore - France 2005, tous droits réservés
 * Contact : studio@matamore.com - http://www.matamore.com
 *
 */
package org.coin.fr.bean;

import org.coin.db.*;

import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;
import java.sql.*;
import java.util.Vector;

public class BOAMPProperties extends CoinDatabaseAbstractBean  {

	private static final long serialVersionUID = 1L;
	
	public static int FACTURATION_GROUPEE = 1;
	public static int FACTURATION_SEPAREE = 2;
	
	protected int iIdOrganisation;
	protected String sCodeClient;
	protected String sLogin;
	protected String sPassword;
	protected String sEmail;
	protected int iTypeFacturation;
	protected int iIdAdresseFacturation;
	protected int iIdAdresseExpedition;
	protected String sDenomination;
	
	
	public void setPreparedStatement (PreparedStatement ps ) throws SQLException {
		ps.setInt(1, this.iIdOrganisation);
		ps.setString(2, preventStore(this.sCodeClient));
		ps.setInt(3, this.iTypeFacturation);
		ps.setString(4, preventStore(this.sDenomination));
		ps.setInt(5, this.iIdAdresseFacturation);
		ps.setInt(6, this.iIdAdresseExpedition);
		ps.setString(7, preventStore(this.sLogin));
		ps.setString(8, preventStore(this.sPassword));
		ps.setString(9, preventStore(this.sEmail));
	}
	
	public void setFromResultSet(ResultSet rs) throws SQLException {
		this.iIdOrganisation = rs.getInt(1);
		this.sCodeClient = preventLoad(rs.getString(2));
		this.iTypeFacturation = rs.getInt(3);
		this.sDenomination = preventLoad(rs.getString(4));
		this.iIdAdresseFacturation = rs.getInt(5);
		this.iIdAdresseExpedition = rs.getInt(6);
		this.sLogin = preventLoad(rs.getString(7));
		this.sPassword = preventLoad(rs.getString(8));
		this.sEmail = preventLoad(rs.getString(9));
	}

	public BOAMPProperties() {
		init();
	}

	public BOAMPProperties(int iIdBOAMPProperties) {
		init();
		this.lId = iIdBOAMPProperties;
	}
	
	public void init() {
	
		this.TABLE_NAME = "boamp_properties";
		this.FIELD_ID_NAME = "id_"+ this.TABLE_NAME ;
		this.SELECT_FIELDS_NAME = "id_organisation,"
								+ "code_client,"
								+ "type_facturation,"
								+ "denomination,"
								+ "id_adresse_facturation,"
								+ "id_adresse_expedition,"
								+ "login,"
								+ "pass,"
								+ "email";
								
		this.SELECT_FIELDS_NAME_SIZE = this.SELECT_FIELDS_NAME.split(",").length ; 
		
		this.iTypeFacturation = FACTURATION_SEPAREE;
		this.iIdOrganisation = -1;
		this.sCodeClient = "";
		this.iIdAdresseFacturation = -1;
		this.iIdAdresseExpedition = -1;
		this.sDenomination = "";
		this.sLogin = "";
		this.sPassword = "";
		this.sEmail = "";
		
	}
	
	public int getIdBOAMPProperties() {
		return (int)this.lId;
	}

	public int getIdOrganisation() {
		return this.iIdOrganisation;
	}

	public void setIdBOAMPProperties(int id) {
		this.lId = id;
	}

	public int getIdTypeFacturation() {
		return this.iTypeFacturation;
	}

	public String getCodeClient() {
		return this.sCodeClient;
	}

	public String getLogin() {
		return this.sLogin;
	}

	public String getPassword() {
		return this.sPassword;
	}

	public String getEmail() {
		return this.sEmail;
	}

	public String getDenomination() {
		return this.sDenomination;
	}

	public int getIdAdresseExpedition() {
		return this.iIdAdresseExpedition;
	}

	public int getIdAdresseFacturation() {
		return this.iIdAdresseFacturation;
	}

	public void setIdTypeFacturation(int id) {
		this.iTypeFacturation = id;
	}

	public void setIdOrganisation(int iIdOrganisation) {
		this.iIdOrganisation = iIdOrganisation;
	}

	public void setCodeClient(String sCodeClient) {
		this.sCodeClient = sCodeClient;
	}

	public void setLogin(String sLogin) {
		this.sLogin = sLogin;
	}

	public void setPassword(String sPassword) {
		this.sPassword = sPassword;
	}

	public void setEmail(String sEmail) {
		this.sEmail = sEmail;
	}

	public void setDenomination(String sDenomination) {
		this.sDenomination = sDenomination;
	}
	
	public void setIdAdresseExpedition(int iIdAdresse){
		this.iIdAdresseExpedition = iIdAdresse;
	}

	public void setIdAdresseFacturation(int iIdAdresse){
		this.iIdAdresseFacturation = iIdAdresse;
	}

	public static BOAMPProperties getBOAMPPropertiesFromOrganisation(int iIdOrganisation) 
	throws NamingException, SQLException, InstantiationException, IllegalAccessException  {
			String sWhereClause = " WHERE id_organisation="+iIdOrganisation;
    	return BOAMPProperties.getAllWithWhereAndOrderByClauseStatic(sWhereClause,"").firstElement();
    }
	public static BOAMPProperties getBOAMPPropertiesFromOrganisation(int iIdOrganisation,Connection conn) 
	throws NamingException, SQLException, InstantiationException, IllegalAccessException {
		String sWhereClause = " WHERE id_organisation="+iIdOrganisation;
		return BOAMPProperties.getAllWithWhereAndOrderByClauseStatic(sWhereClause,"",conn).firstElement();
	}
    
	public static BOAMPProperties getBOAMPProperties(int iIdBOAMPProperties) 
	throws CoinDatabaseLoadException, SQLException, NamingException  {
    	BOAMPProperties properties = new BOAMPProperties (iIdBOAMPProperties);
    	properties.load();
    	return properties;
    }
    
	public void setFromForm(HttpServletRequest request, String sFormPrefix)	{
		this.iTypeFacturation = Integer.parseInt(request.getParameter(sFormPrefix+"sTypeFacturation"));
		this.sCodeClient = request.getParameter(sFormPrefix+"sCodeClient");
		this.sLogin = request.getParameter(sFormPrefix+"sLogin");
		this.sPassword = request.getParameter(sFormPrefix+"sPassword");
		this.sEmail = request.getParameter(sFormPrefix+"sEmail");
		this.sDenomination = request.getParameter(sFormPrefix+"sDenomination");
	}
	
	public static Vector<BOAMPProperties> getAllWithSqlQueryStatic(String sSQLQuery) 
	throws InstantiationException, IllegalAccessException, NamingException, SQLException {
		BOAMPProperties item = new BOAMPProperties (); 
		return getAllWithSqlQuery(sSQLQuery, item);
	}
	
	public static Vector<BOAMPProperties> getAllStatic() 
	throws InstantiationException, IllegalAccessException, NamingException, SQLException {
		
		BOAMPProperties item = new BOAMPProperties (); 
		return item.getAll();
	}

	public static Vector<BOAMPProperties> getAllWithWhereAndOrderByClauseStatic(String sWhereClause, String sOrderByClause)
		throws NamingException, SQLException, InstantiationException, IllegalAccessException{
		BOAMPProperties item = new BOAMPProperties(); 
		return item.getAllWithWhereAndOrderByClause(sWhereClause, sOrderByClause);
	}
	public static Vector<BOAMPProperties> getAllWithWhereAndOrderByClauseStatic(String sWhereClause, String sOrderByClause,Connection conn)
	throws NamingException, SQLException, InstantiationException, IllegalAccessException{
		BOAMPProperties item = new BOAMPProperties(); 
		return item.getAllWithWhereAndOrderByClause(sWhereClause, sOrderByClause,conn);
	}

	@Override
	public String getName() {
		return "boampproperties_" + this.lId;
	}

}
