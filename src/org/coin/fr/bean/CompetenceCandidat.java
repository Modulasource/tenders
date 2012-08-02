/****************************************************************************
Studio Matamore - France 2004
Contact : studio@matamore.com - http://www.matamore.com
****************************************************************************/
/*
 * Created on 2 nov. 2004
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
/**
 * @author wvillard
 * @deprecated il faut passer par BoampCPFItem
 */
public class CompetenceCandidat extends CoinDatabaseAbstractBean {
	
	protected int iIdCompetenceType;
	protected int iIdPersonnePhysique;

	private static final long serialVersionUID = 1L;

    public CompetenceCandidat() {
    	init();
    }
    
    public CompetenceCandidat(int iId) {
    	init();
    	this.lId = iId;
    }
    
    public void init(){
		this.TABLE_NAME = "competence_candidat";
		this.FIELD_ID_NAME = "id_competence_candidat";
		// il ne doit y avoir d'espace apres la virgule => pour ajouter les alias.
		this.SELECT_FIELDS_NAME = " id_competence_type,"
								+ " id_personne_physique";
		this.SELECT_FIELDS_NAME_SIZE = 2; 
		this.iIdCompetenceType = -1;
		this.iIdPersonnePhysique = -1;
    }
	public void setPreparedStatement (PreparedStatement ps ) throws SQLException 
	{
		int i = 0;
		ps.setInt(++i, this.iIdCompetenceType);
		ps.setInt(++i, this.iIdPersonnePhysique);
	}
	
	public void setFromResultSet(ResultSet rs) throws SQLException 
	{
		int i = 0;	
		this.iIdCompetenceType = rs.getInt(++i);
		this.iIdPersonnePhysique = rs.getInt(++i);
	}
   
	public void setFromForm(HttpServletRequest request, String sAlias){
		
	}
    

    public static String getCompetenceTypeName(int iId) throws Exception {
    	CompetenceCandidat competence = new CompetenceCandidat(iId);
    	competence.load();
    	return competence.getName();
    }
    
    public static CompetenceCandidat getCompetenceCandidat(int iId) throws Exception
	{
    	CompetenceCandidat competence = new CompetenceCandidat(iId);
    	competence.load();
		return competence;
	}
    
    public String getName(){
    	return "";
    }
    
    public int getIdCompetenceType(){
    	return this.iIdCompetenceType;
    }
    
    public void setIdCompetenceType(int iIdCompetenceType){
    	this.iIdCompetenceType = iIdCompetenceType;
    }
    
    public void setIdPersonnePhysique(int iIdPersonnePhysique){
    	this.iIdPersonnePhysique = iIdPersonnePhysique;
    }
    
	public static Vector<CompetenceCandidat> getAllCompetenceCandidat(int iIdCandidat)throws NamingException, SQLException, InstantiationException, IllegalAccessException {
		return getAllWithWhereAndOrderByClauseStatic(" WHERE id_personne_physique="+iIdCandidat,"");
	}
	public static Vector<CompetenceCandidat> getAllCompetenceCandidat(int iIdCandidat,Connection conn)throws NamingException, SQLException, InstantiationException, IllegalAccessException {
		return getAllWithWhereAndOrderByClauseStatic(" WHERE id_personne_physique="+iIdCandidat,"",conn);
	}
	
	public static void removeAllFromCandidat(int iIdCandidat) throws NamingException, SQLException, InstantiationException, IllegalAccessException{
		Vector<CompetenceCandidat> vCompetences = getAllCompetenceCandidat(iIdCandidat);
		for(int i=0;i<vCompetences.size();i++)
			vCompetences.get(i).remove();
	}
	
	public static Vector<CompetenceCandidat> getAllWithSqlQueryStatic(String sSQLQuery)
	  throws InstantiationException, IllegalAccessException, NamingException, SQLException {
		CompetenceCandidat item = new CompetenceCandidat();
	  return getAllWithSqlQuery(sSQLQuery, item);
	 }
	 
	public static Vector<CompetenceCandidat> getAllCompetenceCandidat()
	  throws InstantiationException, IllegalAccessException, NamingException, SQLException {
	  return getAllWithWhereAndOrderByClauseStatic("", "");
	 }
	 
	public static Vector<CompetenceCandidat> getAllStatic()
	 throws InstantiationException, IllegalAccessException, NamingException, SQLException {
		CompetenceCandidat item = new CompetenceCandidat();
	  return item.getAll();
	 }
	 
	public static Vector<CompetenceCandidat> getAllWithWhereAndOrderByClauseStatic(String sWhereClause, String sOrderByClause) throws NamingException, SQLException, InstantiationException, IllegalAccessException 
	{
		CompetenceCandidat item = new CompetenceCandidat(); 
		return item.getAllWithWhereAndOrderByClause(sWhereClause, sOrderByClause);
	} 
	
	public static Vector<CompetenceCandidat> getAllWithWhereAndOrderByClauseStatic(String sWhereClause, String sOrderByClause,Connection conn) throws NamingException, SQLException, InstantiationException, IllegalAccessException 
	{
		CompetenceCandidat item = new CompetenceCandidat(); 
		return item.getAllWithWhereAndOrderByClause(sWhereClause, sOrderByClause,conn);
	}

	public int getIdPersonnePhysique() {
		return iIdPersonnePhysique;
	}
}
