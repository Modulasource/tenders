/****************************************************************************
Studio Matamore - France 2004
Contact : studio@matamore.com - http://www.matamore.com
****************************************************************************/

package org.coin.fr.bean;

import java.io.Serializable;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Vector;

import javax.naming.NamingException;

import org.coin.db.CoinDatabaseCreateException;
import org.coin.db.ConnectionManager;
import org.coin.db.CoinDatabaseLoadException;

/**
 * @author julien
 * @version last updated: 05/08/2005
 */
public class PersonnePhysiqueFonctionObjet implements Serializable 
{
	private static final long serialVersionUID = 3258417239714574896L;
	
	public static final String TABLE_NAME = "personne_physique_fonction_objet";
	public static final String FIELD_NAME_ID = "id_personne_physique_fonction_objet";
	
	private int iIdPersonnePhysiqueFonctionObjet;
	private int iIdPersonnePhysiqueFonction;
	private int iIdTypeObjet;

	public PersonnePhysiqueFonctionObjet() {
		init();
	}
	
	public PersonnePhysiqueFonctionObjet(int iIdPersonnePhysiqueFonctionObjet) {
		init();
		this.iIdPersonnePhysiqueFonctionObjet = iIdPersonnePhysiqueFonctionObjet;
	}
	
	private void init() {
		this.iIdPersonnePhysiqueFonctionObjet = -1;
		this.iIdPersonnePhysiqueFonction = -1;
		this.iIdTypeObjet = -1;
	}
	
	public static PersonnePhysiqueFonctionObjet getPersonnePhysiqueFonctionObjet(int iIdPersonnePhysiqueFonctionObjet) throws CoinDatabaseLoadException, NamingException, SQLException{
		PersonnePhysiqueFonctionObjet personnePhysiqueFonctionObjet = new PersonnePhysiqueFonctionObjet(iIdPersonnePhysiqueFonctionObjet);
		personnePhysiqueFonctionObjet.load();
		return personnePhysiqueFonctionObjet;
	}
	
	/* GETTERs */
	public int getIdPersonnePhysiqueFonctionObjet() {
		return this.iIdPersonnePhysiqueFonctionObjet;
	}
	public int getIdPersonnePhysiqueFonction() {
		return this.iIdPersonnePhysiqueFonction;
	}
	public int getIdTypeObjet() {
		return this.iIdTypeObjet;
	}

	/* SETTERs */
	public void setIdPersonnePhysiqueFonctionObjet(int iId) {
		this.iIdPersonnePhysiqueFonctionObjet = iId;
	}
	public void setIdPersonnePhysiqueFonction(int iId) {
		this.iIdPersonnePhysiqueFonction = iId;
	}
	public void setIdTypeObjet(int iId) {
		this.iIdTypeObjet = iId;
	}
	
	/**
	 * Méthode permettant de créer un enregistrement de l'objet PersonnePhysiqueFonctionObjet courant
	 * @throws SQLException 
	 * @throws CoinDatabaseCreateException 
	 * @throws NamingException 
	 */
	public void create() throws SQLException, CoinDatabaseCreateException, NamingException{
		String sRequete = "INSERT INTO " + TABLE_NAME + " ( "
						+ FIELD_NAME_ID + ", "
						+ " id_personne_physique_fonction, "
						+ " id_type_objet_modula "
						+ " ) VALUES (NULL, ?, ?)";
		
		Connection conn = null;
		Statement stat = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		
		try
		{
			conn = ConnectionManager.getDataSource().getConnection();
			stat = conn.createStatement(java.sql.ResultSet.TYPE_FORWARD_ONLY,
                    java.sql.ResultSet.CONCUR_UPDATABLE);
			ps = (stat.getConnection()).prepareStatement(sRequete);
			
			ps.setInt(1, this.iIdPersonnePhysiqueFonction);
			ps.setInt(2, this.iIdTypeObjet);
			ps.executeUpdate();

		    rs = null;
		    rs = stat.executeQuery("SELECT LAST_INSERT_ID()");

		    if (rs.next()) {
		        this.iIdPersonnePhysiqueFonctionObjet = rs.getInt(1);
		    } 
		    else 
		    {
		    	throw new CoinDatabaseCreateException(sRequete);
		    }
		}
		catch (SQLException e) {
			throw e;
		}
		catch (NamingException e) {
			throw e;
		}
		catch (CoinDatabaseCreateException e) {
			throw e;
		}
		finally 
		{
			ConnectionManager.closeConnection(rs,stat,conn,ps);
		}
	}
	
	/**
	 * Méthode permettant la MAJ de l'enregistrement de la base de données avec l'objet PersonnePhysiqueFonctionObjet courant
	 * @throws SQLException 
	 * @throws NamingException 
	 */
	public void store() throws SQLException, NamingException {
		String requete = "UPDATE " + TABLE_NAME + " SET "
					+ FIELD_NAME_ID + "=?, "
					+ " id_personne_physique_fonction=?, "
					+ " id_type_objet_modula=? "
					+ " WHERE " + FIELD_NAME_ID + "=?";
		
		Connection conn = null;
		PreparedStatement ps = null;
		try {
			conn = ConnectionManager.getDataSource().getConnection();
			ps = conn.prepareStatement(requete);
			
			ps.setInt(1, this.iIdPersonnePhysiqueFonctionObjet);
			ps.setInt(2, this.iIdPersonnePhysiqueFonction);
			ps.setInt(3, this.iIdTypeObjet);
			ps.setInt(4, this.iIdPersonnePhysiqueFonctionObjet);
			
			ps.executeUpdate();
		}
		catch (SQLException e) {
			throw e;
		}
		catch (NamingException e) {
			throw e;
		}
		finally {
			ConnectionManager.closeConnection(conn,ps);
		}
	}
	/**
	 * Méthode permettant de charger l'objet PersonnePhysiqueFonctionObjet à partir de la base de données
	 * @throws NamingException 
	 * @throws SQLException 
	 * @throws CoinDatabaseLoadException 
	 */
	public void load() throws NamingException, SQLException, CoinDatabaseLoadException{
		String sSqlQuery = "SELECT "
					+ " id_personne_physique_fonction, "
					+ " id_type_objet_modula "
					+ " FROM " + TABLE_NAME
					+ " WHERE " + FIELD_NAME_ID + "='" + this.iIdPersonnePhysiqueFonctionObjet + "'";
		
		Connection conn = null;
		Statement stat = null;
		ResultSet rs = null;
		try {
			conn = ConnectionManager.getDataSource().getConnection();
			stat = conn.createStatement();
			rs = stat.executeQuery(sSqlQuery);
			
			if (rs.next()) {
				this.iIdPersonnePhysiqueFonction = rs.getInt(1);
				this.iIdTypeObjet = rs.getInt(2);
			}
			else
			{
				throw new CoinDatabaseLoadException ( "" + this.iIdPersonnePhysiqueFonctionObjet, sSqlQuery);
			}
		}
		catch(NamingException e)
		{
			throw e;
		}
		catch(SQLException e)
		{
			throw e;
		}
		catch(CoinDatabaseLoadException e)
		{
			throw e;
		}
		finally 
		{
			ConnectionManager.closeConnection(rs,stat,conn);
		}
	}
	/**
	 * Méthode permettant la suppression du PersonnePhysiqueFonctionObjet courant
	 * @throws SQLException 
	 * @throws NamingException 
	 */
	public void remove() throws SQLException, NamingException {
		remove(this.iIdPersonnePhysiqueFonctionObjet);
	}
	/**
	 * Méthode permettant la suppression d'un PersonnePhysiqueFonctionObjet identifié
	 * @param id - identifiant du PersonnePhysiqueFonctionObjet
	 * @throws SQLException 
	 * @throws NamingException 
	 */
	private void remove(int id) throws SQLException, NamingException {
		String requete = "DELETE FROM " + TABLE_NAME + " WHERE " 
		+ FIELD_NAME_ID + "='"+ id + "'";
		
		Connection conn = null;
		Statement stat = null;
		try {
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
		finally
		{
			ConnectionManager.closeConnection(stat,conn);
		}
	}

	/**
	 * Méthode renvoyant la liste des PersonnePhysiqueFonctionObjet en base
	 * @param sSQLQuery - requete SQL
	 * @throws NamingException 
	 * @throws SQLException 
	 * @throws CoinDatabaseLoadException 
	 */
	public static Vector<PersonnePhysiqueFonctionObjet> getAllWithSQLQuery(String sSQLQuery) throws NamingException, SQLException, CoinDatabaseLoadException{

		Vector<PersonnePhysiqueFonctionObjet> vPersonnePhysiqueFonctionObjet = new Vector<PersonnePhysiqueFonctionObjet>();
		Connection conn = null;
		Statement stat = null;
		ResultSet rs = null;
		
		try {
			conn = ConnectionManager.getDataSource().getConnection();
			stat = conn.createStatement();
			rs = stat.executeQuery(sSQLQuery);
			
			while (rs.next()) 
			{				
				PersonnePhysiqueFonctionObjet personnePhysiqueFonctionObjet = getPersonnePhysiqueFonctionObjet(rs.getInt(1));	
				vPersonnePhysiqueFonctionObjet.add(personnePhysiqueFonctionObjet);
			}
		}
		catch(NamingException e)
		{
			throw e;
		}
		catch(SQLException e)
		{
			throw e;
		}
		catch(CoinDatabaseLoadException e)
		{
			throw e;
		}
		finally 
		{
			ConnectionManager.closeConnection(rs,stat,conn);
		}
		return vPersonnePhysiqueFonctionObjet;
	}
	
	/**
	 * Méthode renvoyant la liste des PersonnePhysiqueFonctionObjet en base
	 * @param sWhereClause - requete SQL de type WHERE...
	 * @throws Exception 
	 */
	public static Vector<PersonnePhysiqueFonctionObjet> getAllWithWhereClause(String sWhereClause) throws Exception {
		String sSQLQuery = "SELECT "+FIELD_NAME_ID
			+ " FROM " + TABLE_NAME
			+ sWhereClause ;
		return getAllWithSQLQuery(sSQLQuery);
	}
	
	/**
	 * Méthode renvoyant la liste des PersonnePhysiqueFonctionObjet en base associées à un type d'Objet
	 * @param iIdTypeObjet - type d'objet
	 * @throws Exception 
	 */
	public static Vector<PersonnePhysiqueFonctionObjet> getAllPersonnePhysiqueFonctionObjetFromTypeObjet(int iIdTypeObjet) throws Exception 
	{
		String sWhereClause = " WHERE id_type_objet_modula='"+iIdTypeObjet+"' ";
		return getAllWithWhereClause(sWhereClause);
	}
	
	/**
	 * Méthode renvoyant la liste des PersonnePhysiqueFonctionObjet en base associées à une fonction
	 * @param iIdPersonnePhysiqueFonction - fonction
	 * @throws Exception 
	 */
	public static Vector<PersonnePhysiqueFonctionObjet> getAllPersonnePhysiqueFonctionObjetFromFonction(int iIdPersonnePhysiqueFonction) throws Exception 
	{
		String sWhereClause = " WHERE id_personne_physique_fonction='"+iIdPersonnePhysiqueFonction+"' ";
		return getAllWithWhereClause(sWhereClause);
	}

}
