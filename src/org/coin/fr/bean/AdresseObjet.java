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

import modula.TypeObjetModula;

import org.coin.db.CoinDatabaseCreateException;
import org.coin.db.ConnectionManager;
import org.coin.db.CoinDatabaseLoadException;
import org.coin.util.BasicDom;
import org.w3c.dom.Node;

/**
 * @author julien
 * @version last updated: 05/08/2005
 */
public class AdresseObjet implements Serializable 
{
	private static final long serialVersionUID = 3258417239714574896L;
	
	public static final String TABLE_NAME = "adresse_objet";
	public static final String FIELD_NAME_ID = "id_adresse_objet";
	
	private int iIdAdresseObjet;
	private int iIdAdresse;
	private int iIdAdresseType;
	private int iIdTypeObjet;
	private int iIdReferenceObjet;

	public AdresseObjet() {
		init();
	}
	
	public AdresseObjet(int iIdAdresseObjet) {
		init();
		this.iIdAdresseObjet = iIdAdresseObjet;
	}
	
	private void init() {
		this.iIdAdresseObjet = -1;
		this.iIdAdresse = -1;
		this.iIdAdresseType = -1;
		this.iIdTypeObjet = -1;
		this.iIdReferenceObjet = -1;
	}
	
	public static AdresseObjet getAdresseObjet(int iIdAdresseObjet) throws CoinDatabaseLoadException, NamingException, SQLException{
		AdresseObjet adresseObjet = new AdresseObjet(iIdAdresseObjet);
		adresseObjet.load();
		return adresseObjet;
	}
	
	/* GETTERs */
	public int getIdAdresseObjet() {
		return this.iIdAdresseObjet;
	}
	public int getIdAdresse() {
		return this.iIdAdresse;
	}
	public int getIdAdresseType() {
		return this.iIdAdresseType;
	}
	public int getIdTypeObjet() {
		return this.iIdTypeObjet;
	}
	public int getIdReferenceObjet() {
		return this.iIdAdresseObjet;
	}

	/* SETTERs */
	public void setIdAdresseObjet(int iId) {
		this.iIdAdresseObjet = iId;
	}
	public void setIdAdresse(int iId) {
		this.iIdAdresse = iId;
	}
	public void setIdAdresseType(int iId) {
		this.iIdAdresseType = iId;
	}
	public void setIdTypeObjet(int iId) {
		this.iIdTypeObjet = iId;
	}
	public void setIdReferenceObjet(int iId) {
		this.iIdAdresseObjet = iId;
	}
	
	//TODO: DK => JR on peut laisser ces adresses voir avec will comment l'ajouter à la syncho du carnet d'adresses
	public String serialize() throws Exception
	{
		 String sAdresseObjet
		 	= "<adresseObjet>\n"
		 	+ Adresse.getAdresse(this.iIdAdresse).serialize() 
		 	+ AdresseType.getAdresseType(this.iIdAdresseType).serialize("adresseType") 
		 	+ TypeObjetModula.getTypeObjetModula(this.iIdTypeObjet).serialize("typeObjet")  
		 	+ "<referenceObjet>" +  this.iIdReferenceObjet + "</referenceObjet>\n" 
			+ "</adresseObjet>\n";
		 
		 return sAdresseObjet;
	
	}
	
	//TODO: DK => JR on peut laisser ces adresses voir avec will comment l'ajouter à la syncho du carnet d'adresses
	public void deserialize (Node node) throws Exception{
		try{
			Adresse.getAdresse(this.iIdAdresse).deserialize(node);
		}
		catch(Exception e){}
		try{
			AdresseType.getAdresseType(this.iIdAdresseType).deserialize(node);
		}
		catch(Exception e){}
		try
		{
		 	TypeObjetModula.getTypeObjetModula(this.iIdTypeObjet).deserialize(node);
		}
		catch(Exception e){}
		try{
			this.iIdReferenceObjet = Integer.parseInt(BasicDom.getChildNodeValueByNodeName(node, "referenceObjet"));
		}
		catch(Exception e){}
	}

	//TODO: DK => JR on peut laisser ces adresses voir avec will comment l'ajouter à la syncho du carnet d'adresses
	public void synchroniser(Node node) throws Exception{
	 	// FLON : DK => WV JR à revoir (non utilisé pour le moment) 
		//Adresse.getAdresse(this.iIdAdresse).synchroniser(node);
	 	AdresseType.getAdresseType(this.iIdAdresseType).synchroniser(node);
	 	TypeObjetModula.getTypeObjetModula(this.iIdTypeObjet).synchroniser(node);  
		deserialize(node);
		if(this.iIdAdresseObjet !=-1) {
			try {
				store();
			}
			catch(Exception e){
				create();
				e.getMessage();
			}
		}
		else create();
		
	}
	
	/**
	 * Méthode permettant de créer un enregistrement de l'objet AdresseObjet courant
	 * @throws SQLException 
	 * @throws CoinDatabaseCreateException 
	 * @throws NamingException 
	 * @throws Exception 
	 */
	public void create() throws SQLException, CoinDatabaseCreateException, NamingException{
		String sRequete = "INSERT INTO " + TABLE_NAME + " ( "
						+ FIELD_NAME_ID + ", "
						+ " id_adresse, "
						+ " id_adresse_type, "
						+ " id_type_objet_modula, "
						+ " id_reference_objet "
						+ " ) VALUES (NULL, ?, ?, ?, ?)";
		
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
			
			ps.setInt(1, this.iIdAdresse);
			ps.setInt(2, this.iIdAdresseType);
			ps.setInt(3, this.iIdTypeObjet);
			ps.setInt(4, this.iIdReferenceObjet);
			ps.executeUpdate();

		    rs = null;
		    rs = stat.executeQuery("SELECT LAST_INSERT_ID()");

		    if (rs.next()) {
		        this.iIdAdresseObjet = rs.getInt(1);
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
	 * Méthode permettant la MAJ de l'enregistrement de la base de données avec l'objet AdresseObjet courant
	 * @throws SQLException 
	 * @throws NamingException 
	 */
	public void store() throws SQLException, NamingException {
		String requete = "UPDATE " + TABLE_NAME + " SET "
					+ FIELD_NAME_ID + "=?, "
					+ " id_adresse=?, "
					+ " id_adresse_type=?, "
					+ " id_type_objet_modula=?, "
					+ " id_reference_objet=? "
					+ " WHERE " + FIELD_NAME_ID + "=?";
		
		Connection conn = null;
		PreparedStatement ps = null;
		try {
			conn = ConnectionManager.getDataSource().getConnection();
			ps = conn.prepareStatement(requete);
			
			ps.setInt(1, this.iIdAdresseObjet);
			ps.setInt(2, this.iIdAdresse);
			ps.setInt(3, this.iIdAdresseType);
			ps.setInt(4, this.iIdTypeObjet);
			ps.setInt(5, this.iIdReferenceObjet);
			ps.setInt(6, this.iIdAdresseObjet);
			
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
	 * Méthode permettant de charger l'objet AdresseObjet à partir de la base de données
	 * @throws NamingException 
	 * @throws SQLException 
	 * @throws CoinDatabaseLoadException 
	 * @throws Exception 
	 */
	public void load() throws NamingException, SQLException, CoinDatabaseLoadException{
		String sSqlQuery = "SELECT "
					+ " id_adresse, "
					+ " id_adresse_type, "
					+ " id_type_objet_modula, "
					+ " id_reference_objet "
					+ " FROM " + TABLE_NAME
					+ " WHERE " + FIELD_NAME_ID + "='" + this.iIdAdresseObjet + "'";
		
		Connection conn = null;
		Statement stat = null;
		ResultSet rs = null;
		try {
			conn = ConnectionManager.getDataSource().getConnection();
			stat = conn.createStatement();
			rs = stat.executeQuery(sSqlQuery);
			
			if (rs.next()) {
				this.iIdAdresse = rs.getInt(1);
				this.iIdAdresseType = rs.getInt(2);
				this.iIdTypeObjet = rs.getInt(3);
				this.iIdReferenceObjet = rs.getInt(4);
			}
			else
			{
				throw new CoinDatabaseLoadException ( "" + this.iIdAdresseObjet, sSqlQuery);
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
	 * Méthode permettant la suppression du AdresseObjet courant
	 * @throws SQLException 
	 * @throws NamingException 
	 */
	public void remove() throws SQLException, NamingException {
		remove(this.iIdAdresseObjet);
	}
	/**
	 * Méthode permettant la suppression d'un AdresseObjet identifié
	 * @param id - identifiant du AdresseObjet
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
	 * Méthode renvoyant la liste des AdresseObjet en base
	 * @param sSQLQuery - requete SQL
	 * @throws NamingException 
	 * @throws SQLException 
	 * @throws CoinDatabaseLoadException 
	 * @throws Exception 
	 */
	public static Vector<AdresseObjet> getAllWithSQLQuery(String sSQLQuery) throws NamingException, SQLException, CoinDatabaseLoadException{

		Vector<AdresseObjet> vAdresseObjet = new Vector<AdresseObjet>();
		Connection conn = null;
		Statement stat = null;
		ResultSet rs = null;
		
		try {
			conn = ConnectionManager.getDataSource().getConnection();
			stat = conn.createStatement();
			rs = stat.executeQuery(sSQLQuery);
			
			while (rs.next()) 
			{				
				AdresseObjet adresseObjet = getAdresseObjet(rs.getInt(1));	
				vAdresseObjet.add(adresseObjet);
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
		return vAdresseObjet;
	}
	
	/**
	 * Méthode renvoyant la liste des AdresseObjet en base
	 * @param sWhereClause - requete SQL de type WHERE...
	 * @throws Exception 
	 */
	public static Vector<AdresseObjet> getAllWithWhereClause(String sWhereClause) throws Exception {
		String sSQLQuery = "SELECT "+FIELD_NAME_ID
			+ " FROM " + TABLE_NAME
			+ sWhereClause ;
		return getAllWithSQLQuery(sSQLQuery);
	}
	
	/**
	 * Méthode renvoyant la liste des AdresseObjet en base associées à un type d'Objet
	 * @param iIdTypeObjet - type d'objet
	 * @throws Exception 
	 */
	public static Vector<AdresseObjet> getAllAdresseObjetFromTypeObjet(int iIdTypeObjet) throws Exception 
	{
		String sWhereClause = " WHERE id_type_objet_modula='"+iIdTypeObjet+"' ";
		return getAllWithWhereClause(sWhereClause);
	}
	
	/**
	 * Méthode renvoyant la liste des AdresseObjet en base associées à un type d'adresse
	 * @param iIdAdresseType - type d'adresse
	 * @throws Exception 
	 */
	public static Vector<AdresseObjet> getAllAdresseObjetFromAdresseType(int iIdAdresseType) throws Exception 
	{
		String sWhereClause = " WHERE id_adresse_type='"+iIdAdresseType+"' ";
		return getAllWithWhereClause(sWhereClause);
	}
	
	/**
	 * Méthode renvoyant la liste des AdresseObjet en base associées à un type d'Objet et une reférence
	 * @param iIdTypeObjet - type d'objet
	 * @param iIdReferenceObjet - reference de l'objet
	 * @throws Exception 
	 */
	public static Vector<AdresseObjet> getAllAdresseObjetFromTypeAndReferenceObjet(int iIdTypeObjet,int iIdReferenceObjet) throws Exception 
	{
		String sWhereClause = " WHERE id_type_objet_modula='"+iIdTypeObjet+"' "
							+ " AND id_reference_objet='"+iIdReferenceObjet+"' ";
		return getAllWithWhereClause(sWhereClause);
	}
}
