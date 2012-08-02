/****************************************************************************
Studio Matamore - France 2004
Contact : studio@matamore.com - http://www.matamore.com
****************************************************************************/

package org.coin.bean ;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Vector;

import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;

import org.coin.db.CoinDatabaseAbstractBean;
import org.coin.db.CoinDatabaseLoadException;
import org.coin.db.ConnectionManager;

public class Role extends CoinDatabaseAbstractBean {    
	private static final long serialVersionUID = 1L;

	protected String sName;
	protected long lIdTreeview;
	
	public void setPreparedStatement (PreparedStatement ps ) throws SQLException 
	{
		int i = 0;
		ps.setString(++i, this.sName);
		ps.setLong(++i, this.lIdTreeview);
	}
	
	public void setFromResultSet(ResultSet rs) throws SQLException 
	{
		int i = 0;	
		this.sName = rs.getString(++i);
		this.lIdTreeview = rs.getLong(++i);
	}
	
	/**
	 * Constructeur classique de la classe Adresse
	 *
	 */
	public Role(long lId) {
		init();
		this.lId = lId;
	}

	/**
	 * Constructeur classique de la classe Adresse
	 *
	 */
	public Role() {
		init();
	}

		
	/**
	 * Initilisation de tous les champs de l'objet Adresse
	 * avec des paramètres par défaut
	 */
	public void init() {
	
		this.TABLE_NAME = "coin_role";
		this.FIELD_ID_NAME = "id_"+ this.TABLE_NAME ;
		// il ne doit y avoir d'espace apres la virgule => pour ajouter les alias.
		this.SELECT_FIELDS_NAME 
				= " name,"
				+ " id_tv_treeview";
		
		this.SELECT_FIELDS_NAME_SIZE = this.SELECT_FIELDS_NAME.split(",").length ; 
	
		this.sName = "";
		this.lIdTreeview = 0;
		
		this.PRIMARY_KEY_TYPE = PRIMARY_KEY_TYPE_LONG;
	}
	


	public void setFromForm(HttpServletRequest request, String sFormPrefix)
	{
		this.sName = request.getParameter(sFormPrefix + "sName");
		this.lIdTreeview = Long.parseLong(request.getParameter(sFormPrefix + "lIdTreeview"));
	}
	

	public static Vector<Role> getAllWithSqlQueryStatic(String sSQLQuery) 
	throws InstantiationException, IllegalAccessException, NamingException, SQLException {
		Role item = new Role (); 
		return getAllWithSqlQuery(sSQLQuery, item);
	}

	public static Vector<Role> getAllStatic() 
	throws InstantiationException, IllegalAccessException, NamingException, SQLException 
	{
		Connection conn = ConnectionManager.getConnection();
		try {
			return getAllStatic(conn);
		} finally {
			ConnectionManager.closeConnection(conn);
		}
	}
	
	public static Vector<Role> getAllStatic(
			Connection conn) 
	throws InstantiationException, IllegalAccessException, NamingException, SQLException 
	{
		Role item = new Role(); 
		String sSQLQuery
		= "SELECT " + item.SELECT_FIELDS_NAME + ", " + item.FIELD_ID_NAME
		+ " FROM " + item.TABLE_NAME;
		return getAllWithSqlQuery(sSQLQuery, item, conn); 
	}

	@SuppressWarnings("unchecked")
	public <T> Vector<T> getAllWithSqlQuery(String sSqlquery) 
	throws NamingException, SQLException, InstantiationException, IllegalAccessException {
		return (Vector<T>) getAllWithSqlQueryStatic(sSqlquery);
	}
	
	
	@Override
	public String getName() {
		
		return this.sName;
	}
	
	
	public void setName(String name) {
		this.sName = name;
	}
	

	public long getIdTreeview() {
		return this.lIdTreeview;
	}
    
	public void setIdTreeview(long idTreeview) {
		this.lIdTreeview = idTreeview;
	}
	
    public Role(String sName) {
    	this.sName = sName;
    }
    
    
    public static String getRoleName(int iId)
    throws CoinDatabaseLoadException, SQLException, NamingException {
    	return getRole(iId).getName();
    }
    
    public static Role getRole(long lId)
    throws CoinDatabaseLoadException, SQLException, NamingException {
    	Role item = new Role (lId);
    	item.load();
    	return item ;
    }
    
    public static Vector<Role> getAllRole()
    throws SQLException, NamingException, InstantiationException, IllegalAccessException
	{
    	return Role.getAllStatic();
	}

    public void removeWithObjectAttached(
			Connection conn)
	throws NamingException, SQLException, InstantiationException, IllegalAccessException,
	CoinDatabaseLoadException 
	{
    	ConnectionManager.executeUpdate(
    			"DELETE FROM coin_user_role "
    			+ " WHERE id_coin_role=" + this.lId, 
    			conn);

    	ConnectionManager.executeUpdate(
    			"DELETE FROM habilitation "
    			+ " WHERE id_coin_role=" + this.lId, 
    			conn);

    	ConnectionManager.executeUpdate(
    			"DELETE FROM coin_role_group "
    			+ " WHERE id_coin_role=" + this.lId, 
    			conn);

    	/**
    	 * here id_coin_role = id_mt_user_type
    	 */
    	/*
    	ConnectionManager.executeUpdate(
    			"DELETE FROM habilitations_treeview "
    			+ " WHERE id_mt_user_type=" + this.lId, 
    			conn);
    	*/
    	
    	remove(conn);
	}
}

