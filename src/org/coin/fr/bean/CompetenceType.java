/****************************************************************************
Studio Matamore - France 2004
Contact : studio@matamore.com - http://www.matamore.com
****************************************************************************/
/*
 * Created on 2 nov. 2004
 *
 */
package org.coin.fr.bean;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Vector;

import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;

import org.coin.db.CoinDatabaseAbstractBeanMemory;
import org.coin.db.CoinDatabaseLoadException;
import org.coin.security.PreventInjection;
/**
 * @author wvillard
 * @deprecated va bientot degager
 */
public class CompetenceType extends CoinDatabaseAbstractBeanMemory {
	
	protected String sName;

	private static final long serialVersionUID = 1L;
	
	public static Vector m_vCom = null; 
	public static Vector m_unprevent_vCom = null; 

    public CompetenceType() {
    	init();
    }
    
    public CompetenceType(int iId) {
    	init();
    	this.lId = iId;
    }
    
    public CompetenceType(int iId, String sName) {
    	init();
    	this.lId = iId;
    	this.sName = sName;
    	
    }
    
    public void init(){
		this.TABLE_NAME = "competence_type";
		this.FIELD_ID_NAME = "id_competence_type";
		// il ne doit y avoir d'espace apres la virgule => pour ajouter les alias.
		this.SELECT_FIELDS_NAME = " name";
		this.SELECT_FIELDS_NAME_SIZE = 1; 
		this.sName = "";
    }
	public void setPreparedStatement (PreparedStatement ps ) throws SQLException 
	{
		int i = 0;
		ps.setString(++i, preventStore(this.sName));
	}
	
	public void setFromResultSet(ResultSet rs) throws SQLException 
	{
		int i = 0;	
		this.sName = PreventInjection.preventLoad(rs.getString(++i));
	}
   
	public void setFromForm(HttpServletRequest request, String sAlias){
		
	}
    

    public static String getCompetenceTypeName(int iId,boolean bUseHttpPrevent) throws Exception {
    	CompetenceType competence = new CompetenceType(iId);
    	competence.bUseHttpPrevent = bUseHttpPrevent;
    	competence.load();
    	return competence.getName();
    }
    
    public static String getCompetenceTypeName(int iId) throws Exception {
    	return getCompetenceTypeName(iId,true);
    }
    
    public static CompetenceType getCompetence(int iId) throws Exception
	{
    	CompetenceType competence = new CompetenceType(iId);
    	competence.load();
		return competence;
	}
    
    public static CompetenceType getCompetenceType(int iId,boolean bUseHttpPrevent) throws CoinDatabaseLoadException, SQLException, NamingException 
    {
    	CompetenceType item = new CompetenceType (iId);
    	item.bUseHttpPrevent = bUseHttpPrevent;
    	item.load();
    	return item;
    }
    public static CompetenceType getCompetenceType(int iId) throws CoinDatabaseLoadException, SQLException, NamingException 
    {
    	return getCompetenceType(iId,true);
    }
    
    public static CompetenceType getCompetenceTypeMemory(int iId,boolean bUseHttpPrevent) throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException 
    {
    	Vector<CompetenceType> vItems = getAllStaticMemory(bUseHttpPrevent);

    	for (CompetenceType item : vItems) {
        	if(item.getId()==iId) return item;
		}

    	throw new CoinDatabaseLoadException("" + iId, "getCompetenceTypeMemory");
    }
    
    public static CompetenceType getCompetenceTypeMemory(int iId) throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException 
    {
    	return getCompetenceTypeMemory(iId,true);
    }
    
    public static String getCompetenceTypeNameMemory(int iId,boolean bUseHttpPrevent) throws Exception {
    	return getCompetenceTypeMemory(iId,bUseHttpPrevent).getName();
    }
    public static String getCompetenceTypeNameMemory(int iId) throws Exception {
    	return getCompetenceTypeNameMemory(iId,true);
    }
    
    public String getName(){
    	return this.sName;
    }

	public static Vector<CompetenceType> getAllCompetenceType()throws NamingException, SQLException, InstantiationException, IllegalAccessException {
		return getAllWithWhereAndOrderByClauseStatic("","");
	}
	
	public static Vector<CompetenceType> getAllWithSqlQueryStatic(String sSQLQuery)
	  throws InstantiationException, IllegalAccessException, NamingException, SQLException {
		CompetenceType item = new CompetenceType();
	  return getAllWithSqlQuery(sSQLQuery, item);
	 }
	
	public static Vector<CompetenceType> getAllCompetence(boolean bUseHttpPrevent) throws SQLException, NamingException, InstantiationException, IllegalAccessException
	{
		CompetenceType item = new CompetenceType();
		item.bUseHttpPrevent = bUseHttpPrevent;
    	return item.getAll();
	}
	public static Vector<CompetenceType> getAllCompetence() throws SQLException, NamingException, InstantiationException, IllegalAccessException
	{
		return getAllCompetence(true);
	}
	 
	public static Vector<CompetenceType> getAllStatic()
	 throws InstantiationException, IllegalAccessException, NamingException, SQLException {
		CompetenceType item = new CompetenceType();
	  return item.getAll();
	 }
	 
	public static Vector<CompetenceType> getAllWithWhereAndOrderByClauseStatic(String sWhereClause, String sOrderByClause) throws NamingException, SQLException, InstantiationException, IllegalAccessException 
	{
		CompetenceType item = new CompetenceType(); 
		return item.getAllWithWhereAndOrderByClause(sWhereClause, sOrderByClause);
	}
	
	public void populateMemory() throws NamingException, SQLException, InstantiationException, IllegalAccessException{
		m_vCom = getAllCompetence(true);
		m_unprevent_vCom = getAllCompetence(false);
	}
    
	@SuppressWarnings("unchecked")
	public <T> Vector<T> getAllMemory() throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException{
		return (Vector<T>) getAllStaticMemory();
	}
	
    @SuppressWarnings("unchecked")
	public static Vector<CompetenceType> getAllStaticMemory(boolean bUseHttpPrevent)
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException
    {
    	CompetenceType item = new CompetenceType();
    	item.bUseHttpPrevent = bUseHttpPrevent;
    	reloadMemoryStatic(item);
    	return item.getItemMemory();
    }
    
    @SuppressWarnings("unchecked")
	public static Vector<CompetenceType> getAllStaticMemory()
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException
    {
    	return getAllStaticMemory(true);
    }

	@SuppressWarnings("unchecked")
	public Vector<CompetenceType> getItemMemory() {
		return (this.bUseHttpPrevent?m_vCom:m_unprevent_vCom);
	}
}
