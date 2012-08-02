/****************************************************************************
Studio Matamore - France 2004
Contact : studio@matamore.com - http://www.matamore.com
****************************************************************************/

/*
 * Created on 19 avr. 2004
 *
 */
package org.coin.fr.bean;

import org.coin.db.*;
import org.coin.security.PreventInjection;

import java.sql.*;
import java.util.*;

import javax.naming.NamingException;

/**
 *
 */
public class Nationalite {
	protected static final String TABLE_NATIONALITE = "nationalite";
	protected int iIdNationalite;
	protected String sLibelle;
	
	public boolean bUseHttpPrevent = true;
	
	public Nationalite() {
		init();
	}
	public Nationalite(int iIdNationalite, String sLibelle) {
		init();
		this.iIdNationalite = iIdNationalite;
		this.sLibelle = sLibelle;
	}
	
	private void init() {
		this.iIdNationalite = -1;
		this.sLibelle = "";
	}
	
	public int getIdNationalite() {
		return this.iIdNationalite;
	}
	public String getLibelle() {
		return this.sLibelle;
	}
	
	public static Nationalite[] getAllNationalites() throws SQLException, NamingException {
		String requete = "SELECT id_nationalite, libelle FROM " + TABLE_NATIONALITE;
		
		ArrayList<Nationalite> listeNationalites= new ArrayList<Nationalite>();
		Connection conn = null;
		Statement stat = null;
		ResultSet resultat = null;
		try {
			conn = ConnectionManager.getDataSource().getConnection();
			stat = conn.createStatement();
			resultat = stat.executeQuery(requete);
			
			Nationalite nat = new Nationalite();
			while (resultat.next()) {
				Nationalite nationalite = new Nationalite(resultat.getInt(1), PreventInjection.preventLoad(resultat.getString(2),nat.bUseHttpPrevent));
				listeNationalites.add(nationalite);
			}
			
			resultat.close();
			stat.close();
			conn.close();
		}
		catch (SQLException e) {
			throw e;
		}
		
		try {
			if(stat != null) stat.close();
			if(conn != null) conn.close();
		}
		catch (SQLException e) {}
		
		Nationalite[] nationalites = null;
		if (listeNationalites != null) {
			nationalites = new Nationalite[listeNationalites.size()];
			nationalites = listeNationalites.toArray(nationalites);
		}
		
		return nationalites;
	}
	/**
	 * Méthode statique renvoyant le libelle du pays identifié
	 * @param iIdNationalite - identifiant du pays
	 * @return le libellé du pays
	 * @throws SQLException 
	 * @throws CoinDatabaseLoadException 
	 * @throws NamingException 
	 */
	public static String getNationalite(int iIdNationalite) throws SQLException, CoinDatabaseLoadException, NamingException {
		String sSqlQuery = "SELECT libelle FROM " + TABLE_NATIONALITE + " WHERE id_nationalite='" + iIdNationalite +"'";
		StringBuffer temp = new StringBuffer();
		
		Connection conn = null;
		Statement stat = null;
		ResultSet resultat = null;
		
		try {
			conn = ConnectionManager.getDataSource().getConnection();
			stat = conn.createStatement();
			resultat = stat.executeQuery(sSqlQuery);
			
			Nationalite nat = new Nationalite();
			if (resultat.next()) {
				temp.append(PreventInjection.preventLoad(resultat.getString(1),nat.bUseHttpPrevent));
			}
			else
			{
				throw new CoinDatabaseLoadException("" + iIdNationalite, sSqlQuery);
			}
			
			resultat.close();
			stat.close();
			conn.close();
		}
		catch (SQLException e) {
			throw e;
		}
		
		try {
			if(stat != null) stat.close();
			if(conn != null) conn.close();
		}
		catch (SQLException e) {}
		
		if (temp != null)
			return temp.toString();
		return null;
	}
	
	/**
	 * Méthode statique renvoyant l'identifiant du pays
	 * @param sNation - libelle du pays
	 * @return identifiant du pays dans la base
	 * @throws Exception 
	 */
	public static int getIdNationalite(String sNation) throws Exception {
		String requete = "SELECT id_nationalite FROM " + TABLE_NATIONALITE + " WHERE libelle='" + sNation +"'";
		int iIdNationalite = -1;
		Connection conn = null;
		Statement stat = null;
		ResultSet resultat = null;
		
		try {
			conn = ConnectionManager.getDataSource().getConnection();
			stat = conn.createStatement();
			resultat = stat.executeQuery(requete);
			
			if (resultat.next()) {
				iIdNationalite = resultat.getInt(1);
			}
			else
			{
				throw new Exception ("Nationalité non trouvée : "+ sNation);
			}
			
			resultat.close();
			stat.close();
			conn.close();
		}
		catch (SQLException e) {
			throw e;
		}
		
		try {
			if(stat != null) stat.close();
			if(conn != null) conn.close();
		}
		catch (SQLException e) {}
		
		return iIdNationalite;
	}
}
