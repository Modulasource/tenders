package org.coin.util;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Vector;

import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;

import org.coin.db.CoinDatabaseAbstractBean;

public class FixedNonWorkingDay extends CoinDatabaseAbstractBean{
	private static final long serialVersionUID = 1L;

	protected int iDay;
	protected int iMonth;
	
	public void setPreparedStatement (PreparedStatement ps ) throws SQLException 
	{
		int i = 0;
		ps.setInt(++i, this.iDay);
		ps.setInt(++i, this.iMonth);
	}
	
	public void setFromResultSet(ResultSet rs) throws SQLException 
	{
		int i = 0;	
		this.iDay = rs.getInt(++i);
		this.iMonth = rs.getInt(++i);		
	}
	
	/**
	 * Constructeur 
	 *
	 */
	public FixedNonWorkingDay() {
		init();
	}
	
	/**
	 * Constructeur 
	 * @param id - identifiant de l'enregistrement correspondant dans la base
	 * @throws Exception 
	 */
	public FixedNonWorkingDay(long lId) {
		init();
		this.lId = lId;
	}

	/**
	 * Initilisation de tous les champs de l'objet 
	 * avec des paramètres par défaut
	 */
	public void init() {
	
		this.TABLE_NAME = "fixed_non_working_day";
		this.FIELD_ID_NAME = "id_"+ this.TABLE_NAME ;
		// il ne doit y avoir d'espace apres la virgule => pour ajouter les alias.
		this.SELECT_FIELDS_NAME 
			= "fixed_day,"
				+ " fixed_month";
 
		this.SELECT_FIELDS_NAME_SIZE = this.SELECT_FIELDS_NAME.split(",").length ; 
	
		this.iDay = 0;
		this.iMonth = 0;
	}
    
    public static FixedNonWorkingDay getFixedNonWorkingDay(long lId) throws Exception {
    	FixedNonWorkingDay item = new FixedNonWorkingDay (lId);
    	item.load();
    	return item ;
    }

	public void setFromForm(HttpServletRequest request, String sFormPrefix)
	{
		this.iDay = Integer.parseInt(request.getParameter(sFormPrefix + "iDay"));
		this.iMonth = Integer.parseInt(request.getParameter(sFormPrefix + "iMonth"));
	}
	
	@SuppressWarnings("unchecked")
	public static Vector<FixedNonWorkingDay> getAllWithWhereAndOrderByClauseStatic(String sWhereClause, String sOrderByClause)
		throws NamingException, SQLException, InstantiationException, IllegalAccessException{
		FixedNonWorkingDay item = new FixedNonWorkingDay(); 
		return item.getAllWithWhereAndOrderByClause(sWhereClause, sOrderByClause);
	}

	
	public static Vector<FixedNonWorkingDay> getAllWithSqlQueryStatic(String sSQLQuery) 
	throws InstantiationException, IllegalAccessException, NamingException, SQLException {
		FixedNonWorkingDay item = new FixedNonWorkingDay (); 
		return getAllWithSqlQuery(sSQLQuery, item);
	}
	
	public static Vector<FixedNonWorkingDay> getAllStatic() 
	throws InstantiationException, IllegalAccessException, NamingException, SQLException {
		
		FixedNonWorkingDay item = new FixedNonWorkingDay (); 
		String sSQLQuery
		= "SELECT " + item.SELECT_FIELDS_NAME + ", " + item.FIELD_ID_NAME
		+ " FROM " + item.TABLE_NAME;
		return getAllWithSqlQuery(sSQLQuery, item); 
	}

	@SuppressWarnings("unchecked")
	public <T> Vector<T> getAllWithSqlQuery(String sSqlquery) throws NamingException, SQLException, InstantiationException, IllegalAccessException {
		return (Vector<T>) getAllWithSqlQueryStatic(sSqlquery);
	}

	@Override
	public String getName() {
		
		return this.lId+"";
	}

	public int getDay() {
		return iDay;
	}

	public void setDay(int day) {
		iDay = day;
	}

	public int getMonth() {
		return iMonth;
	}

	public void setMonth(int month) {
		iMonth = month;
	}
}
