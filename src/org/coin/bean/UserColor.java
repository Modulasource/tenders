/*
 * Studio Matamore - France 2005, tous droits réservés
 * Contact : studio@matamore.com - http://www.matamore.com
 *
 */
package org.coin.bean;

import java.io.Serializable;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Vector;

import javax.naming.NamingException;
import javax.sql.DataSource;

import org.coin.db.CoinDatabaseCreateException;
import org.coin.db.CoinDatabaseLoadException;
import org.coin.security.PreventInjection;

/** 
 * 
 */
public class UserColor implements Serializable{
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	protected int iId;
    protected String sHtmlName;
    protected String sHexaValue;
    
    public static final String TABLE_NAME_COIN_USER_COLOR = "coin_user_color" ;
	public static final String FIELD_NAME_ID_COIN_USER_COLOR = "id_coin_user_color" ;
	public static final String FIELD_NAME_COIN_USER_COLOR_NAME = "name" ;
	public static final String FIELD_NAME_COIN_USER_COLOR_VALUE = "value" ;	
	
	public boolean bUseHttpPrevent = true;
	
    private void init() {
        this.iId = -1;
        this.sHtmlName = "";
        this.sHexaValue = "";
    }
    
    public UserColor() {
        init();
    }
    
    public UserColor(
            int iId, 
            String sHtmlName) {
        this();
        this.iId = iId;
        this.sHtmlName = sHtmlName;
    }
        
    public UserColor(
            String sHtmlName) {
        this();
        this.sHtmlName = sHtmlName;
    }

	public UserColor(int iId) {
	     this();
	     this.iId = iId;
	}

	public static Vector<UserColor> getAll() throws NamingException, SQLException, CoinDatabaseLoadException {
        DataSource ds = org.coin.db.ConnectionManager.getDataSource();
        
		String sSQLQuery = 	"SELECT " + FIELD_NAME_ID_COIN_USER_COLOR
							+ " FROM " + TABLE_NAME_COIN_USER_COLOR
							+ " ORDER BY " + FIELD_NAME_COIN_USER_COLOR_VALUE + " ASC";
		
		Vector<UserColor> vUserColor = new Vector<UserColor>();
		Connection conn = null;
		Statement stat = null;
		ResultSet rs = null;
		try {
			conn = ds.getConnection();
			stat = conn.createStatement();
			rs = stat.executeQuery(sSQLQuery);
			
			while (rs.next()) {
			    UserColor oUserColor = new UserColor(rs.getInt(1));
			    oUserColor.load();	
			    vUserColor.addElement(oUserColor);
			}
			
			rs.close();
			stat.close();
			conn.close();
		}
		catch (SQLException e) {
			throw e;
		}
		
		try {
			if(rs != null) rs.close();
			if(stat != null) stat.close();
			if(conn != null) conn.close();
		}
		catch (SQLException e) {}
		
		return vUserColor;
	}

	public void load() throws CoinDatabaseLoadException, NamingException, SQLException {
	    DataSource ds = org.coin.db.ConnectionManager.getDataSource();
        
		String sSQLQuery = 	"SELECT "
		    					+ FIELD_NAME_COIN_USER_COLOR_NAME + ", "
		    					+ FIELD_NAME_COIN_USER_COLOR_VALUE
							+ " FROM " + TABLE_NAME_COIN_USER_COLOR
							+ " WHERE " + FIELD_NAME_ID_COIN_USER_COLOR + "='" + this.iId + "'";
		
		Connection conn = null;
		Statement stat = null;
		ResultSet rs = null;

		try {
			conn = ds.getConnection();
			stat = conn.createStatement();
			rs = stat.executeQuery(sSQLQuery);
			
			if (rs.next()) {
				this.sHtmlName = (PreventInjection.preventLoad(rs.getString(1),this.bUseHttpPrevent));
				this.sHexaValue = (PreventInjection.preventLoad(rs.getString(2),this.bUseHttpPrevent));
			}
			else
			{
				throw new CoinDatabaseLoadException("" + this.iId, sSQLQuery);
			}
			
			rs.close();
			stat.close();
			conn.close();

		}
		catch (SQLException e) {
			throw e;
		}
		
		try {
			if(rs != null) rs.close();
			if(stat != null) stat.close();
			if(conn != null) conn.close();
		}
		catch (SQLException e) {}
		
	}

	public void create() throws SQLException, CoinDatabaseCreateException, NamingException {
        DataSource ds = org.coin.db.ConnectionManager.getDataSource();
        
        String sSQLQuery =	"INSERT INTO " + TABLE_NAME_COIN_USER_COLOR
								+ "(" + FIELD_NAME_ID_COIN_USER_COLOR + ","
								+ FIELD_NAME_COIN_USER_COLOR_NAME + ","
								+ FIELD_NAME_COIN_USER_COLOR_VALUE + ")"
							+ " VALUES (NULL, ?, ?)";       
        
        Connection conn = null;
        Statement stat = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
      
        try {
			conn = ds.getConnection();
			stat = conn.createStatement(java.sql.ResultSet.TYPE_FORWARD_ONLY,
                    java.sql.ResultSet.CONCUR_UPDATABLE);
			ps = (stat.getConnection()).prepareStatement(sSQLQuery);
			
			ps.setString(1, PreventInjection.preventStore(this.sHtmlName));
			ps.setString(2, PreventInjection.preventStore(this.sHexaValue));
			ps.executeUpdate();
		    rs = stat.executeQuery("SELECT LAST_INSERT_ID()");

		    if (rs.next()) {
		        this.iId = rs.getInt(1);
		    } else {
		        throw new CoinDatabaseCreateException(sSQLQuery);
		    }

		    rs.close();  
			ps.close();
			stat.close();
			conn.close();
		}
		catch (SQLException e) {
			throw e;
		}
		
		try {
			if(rs != null) rs.close();
			if (ps != null) ps.close();
			if(stat != null) stat.close();
			if(conn != null) conn.close();
		}
		catch (SQLException e) {}
		
    }
    
    public void store(String sHtmlName, String sHexaValue) throws SQLException, NamingException {
        DataSource ds ;
        ds = org.coin.db.ConnectionManager.getDataSource();
        
        String sSQLQuery =	"UPDATE " + TABLE_NAME_COIN_USER_COLOR
        					+ " SET "
								+ FIELD_NAME_COIN_USER_COLOR_NAME + "=?, "
								+ FIELD_NAME_COIN_USER_COLOR_VALUE + "=? "
							+ " WHERE " + FIELD_NAME_ID_COIN_USER_COLOR + "=? ";
        
        Connection conn = null;
        Statement stat = null;
        PreparedStatement ps = null;
        
        try {
			conn = ds.getConnection();
			stat = conn.createStatement();
			ps = (stat.getConnection()).prepareStatement(sSQLQuery);
			
			ps.setString(1, PreventInjection.preventStore(sHtmlName));
			ps.setString(2, PreventInjection.preventStore(sHexaValue));
			ps.setInt(3, this.iId);
			
			ps.executeUpdate();
			ps.close();
			conn.close();
			
		}
		catch (SQLException e) {
			throw e;
		}
		
		try {
			if (ps != null) ps.close();
			if(stat != null) stat.close();
			if(conn != null) conn.close();
		}
		catch (SQLException e) {}
		
    }
}
