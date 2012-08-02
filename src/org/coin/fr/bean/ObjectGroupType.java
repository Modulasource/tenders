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

public class ObjectGroupType extends CoinDatabaseAbstractBean  {

	private static final long serialVersionUID = 1L;
	public static final int GROUP_ORGANISMES_PUBLICATION = 1;
	public static final int GROUP_ORGANISATION_SERVICE_MEMBRE = 2;
	public static final int GROUP_ORGANISATION_GROUPE = 2;
	
	protected String sNom;	
	protected String sDescription;	
	protected String sCode;	
	
	public void setPreparedStatement (PreparedStatement ps ) throws SQLException {
		int i = 0;
		ps.setString(++i, preventStore(this.sNom));
		ps.setString(++i, preventStore(this.sDescription));
		ps.setString(++i, preventStore(this.sCode));
	}
	
	public void setFromResultSet(ResultSet rs) throws SQLException {
		int i = 0;	
		this.sNom = preventLoad(rs.getString(++i));
		this.sDescription = preventLoad(rs.getString(++i));
		this.sCode = preventLoad(rs.getString(++i));
	}

	public ObjectGroupType() {
		init();
	}

	public ObjectGroupType(int iIdObjectGroupType) {
		init();
		this.lId = iIdObjectGroupType;
	}
	
	public void init() {
	
		this.TABLE_NAME = "object_group_type";
		this.FIELD_ID_NAME = "id_"+ this.TABLE_NAME ;
		this.SELECT_FIELDS_NAME 
								= "nom,"
								+ "description,"
								+ "code";
								
		this.SELECT_FIELDS_NAME_SIZE = this.SELECT_FIELDS_NAME.split(",").length ; 
		
		this.sNom = "";
		this.sDescription = "";
		this.sCode = "";
	}
	
	public int getIdObjectGroupType() {
		return (int)this.lId;
	}

	public String getDescription() {
		return this.sDescription;
	}

	public String getCode() {
		return this.sCode;
	}

	public void setIdObjectGroupItem(int id) {
		this.lId = id;
	}

	public void setNom(String sNom) {
		this.sNom = sNom;
	}

	public void setDescription(String sDescription) {
		this.sDescription = sDescription;
	}

	public void setCode(String sCode) {
		this.sCode = sCode;
	}

	public static ObjectGroupType getObjectGroupType(int iIdObjectGroupType) throws Exception {
		ObjectGroupType objectGroupType = new ObjectGroupType (iIdObjectGroupType);
		objectGroupType.load();
    	return objectGroupType;
    }
    
	public void setFromForm(HttpServletRequest request, String sFormPrefix)	{
		this.sNom = request.getParameter(sFormPrefix+"sNom");
		this.sDescription = request.getParameter(sFormPrefix+"sDescription");
		this.sCode = request.getParameter(sFormPrefix+"sDescription");
	}
	
	public static Vector<ObjectGroupType> getAllWithSqlQueryStatic(String sSQLQuery) 
	throws InstantiationException, IllegalAccessException, NamingException, SQLException {
		ObjectGroupType item = new ObjectGroupType (); 
		return getAllWithSqlQuery(sSQLQuery, item);
	}
	
	public static Vector<ObjectGroupType> getAllStatic() 
	throws InstantiationException, IllegalAccessException, NamingException, SQLException {
		
		ObjectGroupType item = new ObjectGroupType (); 
		return item.getAll();
	}

	public static Vector<ObjectGroupType> getAllWithWhereAndOrderByClauseStatic(String sWhereClause, String sOrderByClause)
		throws NamingException, SQLException, InstantiationException, IllegalAccessException{
		ObjectGroupType item = new ObjectGroupType(); 
		return item.getAllWithWhereAndOrderByClause(sWhereClause, sOrderByClause);
	}

	@Override
	public String getName() {
		return this.sNom;
	}

}