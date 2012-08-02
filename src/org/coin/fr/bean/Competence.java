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
 * @deprecated il faut passer par BoampCPF
 */
public class Competence extends CoinDatabaseAbstractBeanMemory {
	
	protected String sName;
	protected int iIdCompetenceType;
	protected long lIdBoampCPF;

	private static final long serialVersionUID = 1L;
	
	public static Vector m_vComp = null; 
	public static Vector m_unprevent_vComp = null; 

    public Competence() {
    	init();
    }
    
    public Competence(int iId) {
    	init();
    	this.lId = iId;
    }
    
    public Competence(int iId, String sName) {
    	init();
    	this.lId = iId;
    	this.sName = sName;
    	
    }
    
    public void init(){
		this.TABLE_NAME = "competence";
		this.FIELD_ID_NAME = "id_competence";
		// il ne doit y avoir d'espace apres la virgule => pour ajouter les alias.
		this.SELECT_FIELDS_NAME = " libelle"+
								  " ,id_competence_type"+
								  " ,id_boamp_cpf";
 
		this.SELECT_FIELDS_NAME_SIZE = 2 ; 
		this.iIdCompetenceType= 0;
		this.sName = "";
		this.lIdBoampCPF = 0;
    }
	public void setPreparedStatement (PreparedStatement ps ) throws SQLException 
	{
		int i = 0;
		ps.setString(++i, preventStore(this.sName));
		ps.setInt(++i, this.iIdCompetenceType);
		ps.setLong(++i, this.lIdBoampCPF);
	}
	
	public void setFromResultSet(ResultSet rs) throws SQLException 
	{
		int i = 0;	
		this.sName = PreventInjection.preventLoad(rs.getString(++i));
		this.iIdCompetenceType = rs.getInt(++i);
		this.lIdBoampCPF = rs.getLong(++i);
	}
   
	public void setFromForm(HttpServletRequest request, String sAlias){
		
	}
    
    public static String getCompetenceName(int iId,boolean bUseHttpPrevent) throws Exception {
    	Competence competence = new Competence(iId);
    	competence.bUseHttpPrevent = bUseHttpPrevent;
    	competence.load();
    	return competence.getName();
    }
    
    public static String getCompetenceName(int iId) throws Exception {
    	return getCompetenceName(iId,true);
    }
    
    public static String getCompetenceNameMemory(int iId,boolean bUseHttpPrevent) throws Exception {
    	return getCompetenceMemory(iId,bUseHttpPrevent).getName();
    }
    public static String getCompetenceNameMemory(int iId) throws Exception {
    	return getCompetenceNameMemory(iId,true);
    }
    
    public static Competence getCompetence(int iId) throws Exception
	{
    	return getCompetence(iId, true);
	}
    
    public static Competence getCompetence(int iId, boolean bUseHttpPrevent) throws Exception
	{
    	Competence competence = new Competence(iId);
    	competence.bUseHttpPrevent = bUseHttpPrevent;
    	competence.load();
		return competence;
	}
    
    public static Competence getCompetenceMemory(int iId,boolean bUseHttpPrevent) throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException 
    {
    	Vector<Competence> vItems = getAllStaticMemory(bUseHttpPrevent);

    	for (Competence item : vItems) {
        	if(item.getId()==iId) return item;
		}

    	throw new CoinDatabaseLoadException("" + iId, "getCompetenceMemory");
    }
    
    public static Competence getCompetenceMemory(int iId) throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException 
    {
    	return getCompetenceMemory(iId,true);
    }

    
    public String getName(){
    	return this.sName;
    }
    
    public int getIdCompetenceType(){
    	return this.iIdCompetenceType;
    }

	public static Vector<Competence> getAllFromType(int iIdCompetenceType)throws NamingException, SQLException, InstantiationException, IllegalAccessException {
		return getAllWithWhereAndOrderByClauseStatic(" WHERE id_competence_type="+iIdCompetenceType,"");
	}
	
	public static Vector<Competence> getAllWithSqlQueryStatic(String sSQLQuery)
	  throws InstantiationException, IllegalAccessException, NamingException, SQLException {
		Competence item = new Competence();
	  return getAllWithSqlQuery(sSQLQuery, item);
	 }
	 
	public static Vector<Competence> getAllCompetence(boolean bUseHttpPrevent) throws SQLException, NamingException, InstantiationException, IllegalAccessException
	{
		Competence item = new Competence();
		item.bUseHttpPrevent = bUseHttpPrevent;
    	return item.getAll();
	}
	public static Vector<Competence> getAllCompetence() throws SQLException, NamingException, InstantiationException, IllegalAccessException
	{
		return getAllCompetence(true);
	}
	 
	public static Vector<Competence> getAllStatic()
	 throws InstantiationException, IllegalAccessException, NamingException, SQLException {
		Competence item = new Competence();
	  return item.getAll();
	 }
	 
	public static Vector<Competence> getAllWithWhereAndOrderByClauseStatic(String sWhereClause, String sOrderByClause) throws NamingException, SQLException, InstantiationException, IllegalAccessException 
	{
		Competence item = new Competence(); 
		return item.getAllWithWhereAndOrderByClause(sWhereClause, sOrderByClause);
	}
	
	public void populateMemory() throws NamingException, SQLException, InstantiationException, IllegalAccessException{
		m_vComp = getAllCompetence(true);
		m_unprevent_vComp = getAllCompetence(false);
	}
    
	@SuppressWarnings("unchecked")
	public <T> Vector<T> getAllMemory() throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException{
		return (Vector<T>) getAllStaticMemory();
	}
	
    @SuppressWarnings("unchecked")
	public static Vector<Competence> getAllStaticMemory(boolean bUseHttpPrevent)
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException
    {
    	Competence item = new Competence();
    	item.bUseHttpPrevent = bUseHttpPrevent;
    	reloadMemoryStatic(item);
    	return item.getItemMemory();
    }
    
    @SuppressWarnings("unchecked")
	public static Vector<Competence> getAllStaticMemory()
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException
    {
    	return getAllStaticMemory(true);
    }

	@SuppressWarnings("unchecked")
	public Vector<Competence> getItemMemory() {
		return (this.bUseHttpPrevent?m_vComp:m_unprevent_vComp);
	}

	public long getIdBoampCPF() {
		return lIdBoampCPF;
	}

	public void setIdBoampCPF(long idBoampCPF) {
		lIdBoampCPF = idBoampCPF;
	}
    
}
