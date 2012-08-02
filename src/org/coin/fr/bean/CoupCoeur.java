package org.coin.fr.bean;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Vector;

import javax.naming.NamingException;

import org.coin.db.CoinDatabaseCreateException;
import org.coin.db.CoinDatabaseLoadException;
import org.coin.db.ConnectionManager;

public class CoupCoeur {    
	private int iIdCoupCoeur;
	private int iIdOrganisation;
	
	public static String TABLE_COUP_DE_COEUR= "coup_coeur";
    
  
	public CoupCoeur() {
		init();
	}
        
	public CoupCoeur(int i) {
    	init();
    	this.iIdCoupCoeur = i;
    }
        
	private void init(){
    	this.iIdCoupCoeur = -1;
    	this.iIdOrganisation = -1;
	}
	
	public int getIdCoupCoeur(){
		
		return this.iIdCoupCoeur;
	}

	public void setIdCoupCoeur(int iIdCoupCoeur){
		this.iIdCoupCoeur = iIdCoupCoeur;
	}
	
	public int getIdOrganisation(){
		return this.iIdOrganisation;
	}

	public void setIdOrganisation(int iIdOrganisation){
		this.iIdOrganisation = iIdOrganisation;
	}
	
	public static CoupCoeur getCoupCoeur(int iIdCoupCoeur) throws CoinDatabaseLoadException, SQLException, NamingException {
		CoupCoeur coupCoeur = new CoupCoeur(iIdCoupCoeur);
		coupCoeur.load();
		return coupCoeur;
	}

	public void create() throws CoinDatabaseCreateException, NamingException, SQLException {
		String sSqlQuery = "INSERT INTO " + TABLE_COUP_DE_COEUR + " ( "
		+ " id_coup_coeur, id_organisation)" 
		+ " VALUES (NULL, ?)";
		
		Connection conn = null;
		PreparedStatement ps = null;
		Statement stat = null;
		ResultSet rs = null;
		
		try 
		{
			conn = ConnectionManager.getDataSource().getConnection();
			stat = conn.createStatement(java.sql.ResultSet.TYPE_FORWARD_ONLY,
                    java.sql.ResultSet.CONCUR_UPDATABLE);
			ps = (stat.getConnection()).prepareStatement(sSqlQuery );
			ps.setInt(1, this.iIdOrganisation);
			ps.executeUpdate();
			ps.close();
		    rs = stat.executeQuery("SELECT LAST_INSERT_ID()");
		    if (rs.next()) 
		        this.iIdCoupCoeur = rs.getInt(1);
		    else 
		    	throw new CoinDatabaseCreateException(sSqlQuery);
		}
		catch (SQLException e) {
			throw e;
		}
		
		try {
			if(rs != null) rs.close();
			if(stat != null) stat.close();
			if(conn != null) conn.close();
			if(ps != null) ps.close();
		} catch (Exception e) {}
	}

	public void remove() throws SQLException, NamingException {
		String requete = "DELETE FROM " + TABLE_COUP_DE_COEUR+ " WHERE id_coup_coeur" 
		+ "='"+ this.iIdCoupCoeur+ "'";
		
		Connection conn = null;
		Statement stat = null;
		try {
			conn = ConnectionManager.getDataSource().getConnection();
			stat = conn.createStatement();
			stat.executeUpdate(requete);
			
			stat.close();
			conn.close();
		}
		catch (SQLException e) {
			throw e;
		}
		
		try {
			if (stat != null) stat.close();
			if (conn != null) conn.close();
		} catch (Exception e) {}
		
	}

	public static void removeAll() throws SQLException, NamingException {
		String requete = "DELETE FROM " + TABLE_COUP_DE_COEUR;
		
		Connection conn = null;
		Statement stat = null;
		try {
			conn = ConnectionManager.getDataSource().getConnection();
			stat = conn.createStatement();
			stat.executeUpdate(requete);
			stat.close();
			conn.close();
		}
		catch (SQLException e) {
			throw e;
		}
		
		try {
			if (stat != null) stat.close();
			if (conn != null) conn.close();
		} catch (Exception e) {}
		
	}

	public void load() throws SQLException, NamingException, CoinDatabaseLoadException {
		String sSqlQuery = "SELECT id_coup_coeur, id_organisation"
			+ " FROM " + TABLE_COUP_DE_COEUR + " WHERE id_coup_coeur='" 
			+ this.iIdCoupCoeur+"'";
		
		Connection conn = null;
		Statement stat = null;
		ResultSet resultat = null;
		
		try {
			conn = ConnectionManager.getDataSource().getConnection();
			stat = conn.createStatement();
			resultat = stat.executeQuery(sSqlQuery);
			
			if(resultat.next()) {
				this.iIdCoupCoeur = resultat.getInt(1);
				this.iIdOrganisation = resultat.getInt(2);
			}
			else
				throw new CoinDatabaseLoadException("" + this.getIdCoupCoeur(), sSqlQuery);
			
			resultat.close();
			stat.close();
			conn.close();
		}
		catch (SQLException e) {
			throw e;
		}
		
		try {
			if (resultat != null) resultat.close();
			if (stat != null) stat.close();
			if (conn != null) conn.close();
		} catch (Exception e) {}
	}

	public static Vector<CoupCoeur> getAllCoupCoeur() throws Exception {
		
		Vector<CoupCoeur> vCoupCoeur = new Vector<CoupCoeur>();
		Connection conn = null;
		Statement stat = null;
		ResultSet rs = null;
		String sRequete = "SELECT id_coup_coeur FROM "
				+TABLE_COUP_DE_COEUR ;
		try {
			conn = ConnectionManager.getDataSource().getConnection();
			stat = conn.createStatement();
			rs = stat.executeQuery(sRequete);
			
			while(rs.next()) {
				CoupCoeur cc = getCoupCoeur(rs.getInt(1));
				if(cc != null)
					vCoupCoeur.add(cc);
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
		
		return vCoupCoeur;
	}

	public static Vector<CoupCoeur> getAllCoupCoeurFromOrganisation(int iIdOrganisation) throws Exception {
		
		Vector<CoupCoeur> vCoupCoeur = new Vector<CoupCoeur>();
		Connection conn = null;
		Statement stat = null;
		ResultSet rs = null;
		String sRequete = "SELECT id_coup_coeur FROM "
				+TABLE_COUP_DE_COEUR
				+" WHERE id_organisation="+iIdOrganisation;
		try {
			conn = ConnectionManager.getDataSource().getConnection();
			stat = conn.createStatement();
			rs = stat.executeQuery(sRequete);
			
			while(rs.next()) {
				CoupCoeur cc = getCoupCoeur(rs.getInt(1));
				if(cc != null)
					vCoupCoeur.add(cc);
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
		
		return vCoupCoeur;
	}
}
