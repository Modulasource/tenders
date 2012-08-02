/****************************************************************************
Studio Matamore - France 2004
Contact : studio@matamore.com - http://www.matamore.com
****************************************************************************/

package org.coin.bean;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Vector;

import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;

import org.coin.db.CoinDatabaseAbstractBean;
import org.coin.db.ConnectionManager;
import org.coin.util.HttpUtil;


/**
 */
public class GroupRole extends CoinDatabaseAbstractBean{    
	private static final long serialVersionUID = 1L;
	
	public static final String TABLE_NAME = "coin_role_group";
	public static final String FIELD_NAME_ID = "id_coin_role_group";
	public static final String FIELD_NAME_ID_GROUP = "id_coin_group";
	public static final String FIELD_NAME_ID_ROLE = "id_coin_role";

	protected int iIdGroup;
	protected int iIdRole;
	
    public GroupRole() {
    	init();
    }
        
    public GroupRole(int iIdGroup, int iIdRole) {
    	init();
    	this.iIdGroup = iIdGroup;
    	this.iIdRole = iIdRole;
    }
    
    public GroupRole(int iIdUserRole , int iIdGroup, int iIdUser) {
    	this.lId = iIdUserRole ;
    	this.iIdGroup = iIdGroup;
    	this.iIdRole = iIdUser;
    	init();
    }

    public void init()
    {
		// il ne doit y avoir d'espace apres la virgule => pour ajouter les alias.
    	super.TABLE_NAME = "coin_role_group";
		super.FIELD_ID_NAME = "id_coin_role_group";
		
		this.SELECT_FIELDS_NAME 
				= " id_coin_group,"
				+ " id_coin_role";
		
		this.SELECT_FIELDS_NAME_SIZE = this.SELECT_FIELDS_NAME.split(",").length ; 
		this.PRIMARY_KEY_TYPE = PRIMARY_KEY_TYPE_LONG;
    	
    	this.lId = 0;
    	this.iIdGroup = 0;
    	this.iIdRole = 0;
    }
    
    public static void removeAllByIdGroup(int iIdGroup) throws SQLException, NamingException {
        GroupRole item = new GroupRole();
        item.remove(" WHERE " + FIELD_NAME_ID_GROUP + "="+iIdGroup);
    }
    
    
    public static Vector<Role> getAllRole(
    		long lIdGroup)
    throws SQLException, NamingException, InstantiationException, IllegalAccessException
	{
    	Connection conn = ConnectionManager.getConnection();
		try{
			return getAllRole(lIdGroup , true, conn) ;
		} finally {
			ConnectionManager.closeConnection(conn);
		}
	}
    
    public static Vector<Role> getAllRole(
    		long lIdGroup,
    		boolean bUseHttpPrevent,
    		Connection conn)
    throws SQLException, NamingException, InstantiationException, IllegalAccessException
	{
    	Role item = new Role();
    	String sSQLQuery 
    		= item.getAllSelect("role.")
			+ ",  " 
			+ TABLE_NAME + " grouprole "
			+ " WHERE role." + item.FIELD_ID_NAME+ "=" + "grouprole." + FIELD_NAME_ID_ROLE
			+ " AND grouprole." + FIELD_NAME_ID_GROUP + "=" + lIdGroup;
		
    	item.bUseHttpPrevent = bUseHttpPrevent;
		return item.getAllWithSqlQuery(sSQLQuery,conn);
	}

	public String getName() {
		return "goup_role_"+this.lId;
	}

	public void setFromForm(HttpServletRequest request, String formPrefix)
			throws SQLException, NamingException {
		this.iIdGroup = HttpUtil.parseInt("iIdGroup", request, 0);
		this.iIdRole = HttpUtil.parseInt("iIdRole", request, 0);
	}

	public void setFromResultSet(ResultSet rs) throws SQLException {
		int i = 0;	
		this.iIdGroup = rs.getInt(++i);
		this.iIdRole = rs.getInt(++i);
		
	}

	public void setPreparedStatement(PreparedStatement ps) throws SQLException {
		int i = 0;
		ps.setInt(++i, this.iIdGroup);
		ps.setInt(++i, this.iIdRole);
	}
	
	public static Vector<GroupRole> getAllWithSqlQueryStatic(String sSQLQuery) 
	throws InstantiationException, IllegalAccessException, NamingException, SQLException {
		GroupRole item = new GroupRole (); 
		return getAllWithSqlQuery(sSQLQuery, item);
	}
	
	public static Vector<GroupRole> getAllStatic() 
	throws InstantiationException, IllegalAccessException, NamingException, SQLException {
		
		GroupRole item = new GroupRole(); 
		String sSQLQuery
		= "SELECT " + item.SELECT_FIELDS_NAME + ", " + item.FIELD_ID_NAME
		+ " FROM " + TABLE_NAME;
		return getAllWithSqlQuery(sSQLQuery, item); 
	}

	@SuppressWarnings("unchecked")
	public <T> Vector<T> getAllWithSqlQuery(String sSqlquery) throws NamingException, SQLException, InstantiationException, IllegalAccessException {
		return (Vector<T>) getAllWithSqlQueryStatic(sSqlquery);
	}
}

