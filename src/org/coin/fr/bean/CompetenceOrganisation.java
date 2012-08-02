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
import java.sql.Statement;
import java.util.Vector;

import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;

import org.coin.db.CoinDatabaseAbstractBean;
import org.coin.db.ConnectionManager;

/**
 * @author wvillard
 * @deprecated il faut passer par BoampCPFItem
 */

public class CompetenceOrganisation extends CoinDatabaseAbstractBean
{
	private static final long serialVersionUID = 1L;
	
    protected int iIdOrganisation;
    
	public void setPreparedStatement (PreparedStatement ps ) throws SQLException 
	{
		int i = 0;
		ps.setInt(++i, this.iIdOrganisation);
	}
	
	public void setFromResultSet(ResultSet rs) throws SQLException 
	{
		int i = 0;	
		this.iIdOrganisation = rs.getInt(++i);
	}
   
    public CompetenceOrganisation(){
    	this.init();
    }
    
    public CompetenceOrganisation(int iIdOrganisation,int iIdCompetence){
    	init();
    	this.iIdOrganisation = iIdOrganisation;
    	this.lId = iIdCompetence;
    }

    public CompetenceOrganisation(int iIdOrganisation){
    	init();
    	this.iIdOrganisation = iIdOrganisation;
    }
    
    public void init() 
    {
		this.TABLE_NAME = "competence_par_organisation";
		this.FIELD_ID_NAME = "id_competence";
		// il ne doit y avoir d'espace apres la virgule => pour ajouter les alias.
		this.SELECT_FIELDS_NAME = " id_organisation";
 
		this.SELECT_FIELDS_NAME_SIZE = 1 ; 
		this.setAutoIncrement(false);
		
		this.iIdOrganisation = -1;
   	}
    
    public void setIdCompetence(int iIdCompetence){
    	this.lId = iIdCompetence;
    }

    public int getIdCompetence(){
    	return (int)this.lId;
    }

    public int getIdOrganisation(){
    	return this.iIdOrganisation;
    }
    
    /**
	 * Méthode ajoutant un enregistrement d'un objet CompetenceOrganisation dans la base
 * @throws SQLException 
 * @throws NamingException 
	 */
	
	public void create() throws SQLException, NamingException 
	{
		String requete = "INSERT INTO " + this.TABLE_NAME + " ( "
		+ " id_organisation, id_competence) VALUES (?, ?)";
		
		Connection conn = null;
		PreparedStatement ps = null;
		try 
		{
			conn = ConnectionManager.getDataSource().getConnection();
			ps = conn.prepareStatement(requete);
			
			ps.setInt(1, this.iIdOrganisation);
			ps.setInt(2,(int) this.lId);
			
			ps.executeUpdate();
		}
		catch (SQLException e) 
		{
			throw e;
		}
		catch (NamingException e) 
		{
			throw e;
		}
		finally {
			ConnectionManager.closeConnection(conn,ps);
		}
	}
    
    public static Vector<CompetenceOrganisation> getAllCompetencesWithIdOrganisation(int iIdOrganisation) throws SQLException, NamingException {
		String sWhereClause = " WHERE id_organisation = " + iIdOrganisation;
		String sSQLQuery = "SELECT id_organisation,id_competence FROM competence_par_organisation" + sWhereClause;
		Vector<CompetenceOrganisation> vIdCompetence = new Vector<CompetenceOrganisation>();
		
		Connection conn = null;
		Statement stat = null;
		ResultSet rs = null;
		
		try 
		{
			conn = ConnectionManager.getDataSource().getConnection();
			stat = conn.createStatement();
			rs = stat.executeQuery(sSQLQuery );
			
			while(rs.next()) 
			{
				vIdCompetence.add(new CompetenceOrganisation(rs.getInt(1),rs.getInt(2)));
			}
		}
		catch (SQLException e) 
		{
			throw e;
		}
		catch (NamingException e) 
		{
			throw e;
		}
		finally {
			ConnectionManager.closeConnection(rs,stat,conn);
		}
		
		return vIdCompetence;
	}
	
	/**
	 * Méthode supprimant un enregistrement correspondant à un objet CompetenceOrganisation dans la base
	 * @throws NamingException 
	 * @throws SQLException 
	 */
	public void removeAll() throws SQLException, NamingException {
		this.remove(this.iIdOrganisation);
	}

	public void remove() throws SQLException, NamingException {
		this.remove(this.iIdOrganisation,(int)this.lId);
	}
	/**
	 * Methode supprimant un enregistrement d'objet CompetenceOrganisation dans la base
	 * @param id - identifiant de l'enregistrement à supprimer
	 * @throws SQLException 
	 * @throws NamingException 
	 */
	public void remove(int id) throws SQLException, NamingException 
	{
		String requete = "DELETE FROM " + this.TABLE_NAME + " WHERE " 
		+ "id_organisation='"+ id + "'";
		
		Connection conn = null;
		Statement stat = null;

		try 
		{
			conn = ConnectionManager.getDataSource().getConnection();
			stat = conn.createStatement();
			stat.executeUpdate(requete);
		}
		catch (SQLException e) 
		{
			throw e;
		}
		catch (NamingException e) 
		{
			throw e;
		}
		finally {
			ConnectionManager.closeConnection(stat,conn);
		}
	}

	private void remove(int iIdOrganisation, int iIdCompetence) throws SQLException, NamingException {
		String requete = "DELETE FROM " + this.TABLE_NAME + " WHERE " 
		+ "id_organisation='"+ iIdOrganisation + "' and " + this.FIELD_ID_NAME + "='"+iIdCompetence+"'" ;
		
		Connection conn = null;
		Statement stat = null;
		
		try
		{
			conn = ConnectionManager.getDataSource().getConnection();
			stat = conn.createStatement();
			stat.executeUpdate(requete);
		}
		catch (SQLException e) {
			throw e;
		}
		catch (NamingException e) {
			throw e;
		}
		
		finally {
			ConnectionManager.closeConnection(stat,conn);
		}
	}

	@Override
	public String getName() 
	{
		String sName = "";
	
		try
		{
			sName = Competence.getCompetenceNameMemory((int)this.lId);
		}
		catch(Exception e){sName = "";}
		
		return sName;
	}

	public static Vector<CompetenceOrganisation> getAllWithSqlQueryStatic(String sSQLQuery) 
	throws InstantiationException, IllegalAccessException, NamingException, SQLException 
	{
		CompetenceOrganisation item = new CompetenceOrganisation(); 
		return getAllWithSqlQuery(sSQLQuery, item);
	}

	public void setFromForm(HttpServletRequest request, String sFormPrefix){
		
	}
}
