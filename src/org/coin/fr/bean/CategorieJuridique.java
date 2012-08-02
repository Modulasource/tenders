/****************************************************************************
Studio Matamore - France 2004
Contact : studio@matamore.com - http://www.matamore.com
****************************************************************************/

/*
 * Created on 13 avr. 2004
 *
 */
package org.coin.fr.bean;

import org.coin.db.CoinDatabaseLoadException;
import org.coin.db.ConnectionManager;
import org.coin.util.Enumerator;
import org.coin.util.Outils;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.*;

import javax.naming.NamingException;

/**
 *
 */
public class CategorieJuridique extends Enumerator {
	
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	static final String SQL_QUERY_SELECT_FROM_CLAUSE = "SELECT id_categorie_juridique FROM categorie_juridique "  ;
	static final String SQL_QUERY_COUNT_FROM_CLAUSE = "SELECT COUNT(*) FROM categorie_juridique "  ;

	public void setConstantes(){
        super.TABLE_NAME = "categorie_juridique";
        super.FIELD_ID_NAME  = "id_categorie_juridique";
        super.FIELD_NAME_NAME = "libelle";
        super.SELECT_FIELDS_NAME = super.FIELD_NAME_NAME;
        super.SELECT_FIELDS_NAME_SIZE = 1;
        this.setAutoIncrement(false);
    }
    
    public CategorieJuridique () {
        super();
        setConstantes();
    }
    
    public CategorieJuridique (String sName) {
        super(sName);
        setConstantes();
    }
    
    public CategorieJuridique (int iId) {
        super(iId);
        setConstantes();
    }
    
    public CategorieJuridique (int iId, String sName) {
        super(iId,sName);
        setConstantes();
    }
    
    public CategorieJuridique(int iId, String sName,boolean bUseHttpPrevent) {
		super(iId,sName);
		this.bUseHttpPrevent = bUseHttpPrevent;
		setConstantes();
	}
   
	protected Enumerator getAll_onNewItem(int iId, String sName)
	{
		return getAll_onNewItem(iId,sName,true);
	}
   
	protected Enumerator getAll_onNewItem(int iId, String sName,boolean bUseHttpPrevent)
	{
		return new CategorieJuridique(iId, sName,bUseHttpPrevent);
	}

    public static String getCategorieJuridiqueName(int iId) throws Exception {
    	CategorieJuridique  cat = new CategorieJuridique (iId);
    	cat.load();
    	return cat.getName();
    }

    public static String getCategorieJuridiqueNameOptional(int iId)  {
    	CategorieJuridique  cat = new CategorieJuridique (iId);
    	try {
			cat.load();
	    	return cat.getName();
		} catch (Exception e) {}

		return "";
    }
    

    public static Vector<CategorieJuridique> getAllCategorieJuridique () throws SQLException, NamingException
	{
    	CategorieJuridique cat = new CategorieJuridique ();
		return cat.getAllOrderById();
	}

    public static CategorieJuridique  getCategorieJuridique (int iId) throws Exception
	{
    	return getCategorieJuridique(iId,true);
	}
    public static CategorieJuridique  getCategorieJuridique (int iId, boolean bUseHttpPrevent) throws CoinDatabaseLoadException, SQLException, NamingException 
	{
    	CategorieJuridique cat = new CategorieJuridique (iId);
    	cat.bUseHttpPrevent = bUseHttpPrevent;
    	cat.load();
		return cat;
	}
    
	public static Vector<CategorieJuridique> getAllCategorieJuridiqueLike(String sChaine, int iLimitOffset, int iLimit) 
	throws Exception {
		return getAllCategorieJuridiqueLike(sChaine, iLimitOffset, iLimit,true);
	}
    
	public static Vector<CategorieJuridique> getAllCategorieJuridiqueLike(String sChaine, int iLimitOffset, int iLimit,boolean bUseHttpPrevent) throws CoinDatabaseLoadException, NamingException, SQLException  {
		String sSQLQuery = SQL_QUERY_SELECT_FROM_CLAUSE ;
		
		if (sChaine!=null){
			sSQLQuery += " WHERE libelle LIKE '%" + Outils.addLikeSlashes(sChaine) + "%'";
			sSQLQuery += " ORDER BY libelle";
		}
		
		if (iLimit>0){
			sSQLQuery += " LIMIT "+iLimitOffset+", "+iLimit;
		}
		Connection conn = null;
		Statement stat = null;
		ResultSet rs = null;
		Vector<CategorieJuridique> vCategorieJuridique = new Vector<CategorieJuridique>();
		try {
			conn = ConnectionManager.getDataSource().getConnection();
			stat = conn.createStatement();
			rs = stat.executeQuery(sSQLQuery);
			
			while(rs.next()) {
				vCategorieJuridique.add(CategorieJuridique.getCategorieJuridique(rs.getInt(1),bUseHttpPrevent));
			}
		} finally{
			ConnectionManager.closeConnection(rs,stat,conn);
		}
	
		return vCategorieJuridique;
	}

	public static int getCountCategorieJuridiqueLike(String sChaine, int iLimitOffset, int iLimit) throws NamingException, SQLException {
		String sSQLQuery = SQL_QUERY_COUNT_FROM_CLAUSE ;
		
		if (sChaine!=null){
			sSQLQuery += " WHERE libelle LIKE '%" + Outils.addLikeSlashes(sChaine) + "%'";
		}
		
		if (iLimit>0){
			sSQLQuery += " LIMIT "+iLimitOffset+", "+iLimit;
		}
		Connection conn = null;
		Statement stat = null;
		ResultSet rs = null;
		int iCount = 0;
		
		try {
			conn = ConnectionManager.getDataSource().getConnection();
			stat = conn.createStatement();
			rs = stat.executeQuery(sSQLQuery);
			
			while(rs.next()) {
				iCount = rs.getInt(1);
			}
		}finally{
			ConnectionManager.closeConnection(rs,stat,conn);
		}
		
		return iCount;
	}
	
	
}

