/****************************************************************************
Studio Matamore - France 2004
Contact : studio@matamore.com - http://www.matamore.com
****************************************************************************/

package org.coin.fr.bean;

import java.math.BigInteger;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Vector;

import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;

import org.coin.db.CoinDatabaseAbstractBean;
import org.coin.db.CoinDatabaseLoadException;
import org.coin.util.BitField;

/**
 * @author julien
 * @version last updated: 05/08/2005
 */
public class Correspondant extends CoinDatabaseAbstractBean 
{
	private static final long serialVersionUID = 3258417239714574896L;
	
	
	private int iIdPersonnePhysique;
	private int iIdPersonnePhysiqueFonction;
	private int iIdTypeObjet;
	private int iIdReferenceObjet;
	protected BigInteger biStatus;

	public Correspondant() {
		init();
	}
	
	public Correspondant(int iIdCorrespondant) {
		init();
		this.lId = iIdCorrespondant;
	}
	
	public void init() {
		
		this.TABLE_NAME = "correspondant";
		this.FIELD_ID_NAME = "id_correspondant";
		this.SELECT_FIELDS_NAME =
			 " id_personne_physique,"
			+ " id_personne_physique_fonction,"
			+ " id_type_objet_modula,"
			+ " id_reference_objet,"
			+ " correspondant_statuts";
		
		this.SELECT_FIELDS_NAME_SIZE = this.SELECT_FIELDS_NAME.split(",").length ; 
		
		this.lId = -1;
		this.iIdPersonnePhysique = 0;
		this.iIdPersonnePhysiqueFonction = 0;
		this.iIdTypeObjet = 0;
		this.iIdReferenceObjet = 0;
		this.biStatus = new BigInteger(new byte[] {0x00, 0x00, 0x00, 0x00, 0x00, 0x00});
	}
	
	public static Correspondant getCorrespondant(int iIdCorrespondant) throws CoinDatabaseLoadException, NamingException, SQLException{
		Correspondant correspondant = new Correspondant(iIdCorrespondant);
		correspondant.load();
		return correspondant;
	}

	
	public static Correspondant getCorrespondant(int iIdCorrespondant, boolean bUseHttpPrevent, Connection conn) 
	throws CoinDatabaseLoadException, NamingException, SQLException{
		Correspondant correspondant = new Correspondant(iIdCorrespondant);
		correspondant.bUseHttpPrevent = bUseHttpPrevent ;
		correspondant.load(conn);
		return correspondant;
	}

	/* GETTERs */
	public int getIdCorrespondant() {
		return (int)this.lId;
	}
	public int getIdPersonnePhysique() {
		return this.iIdPersonnePhysique;
	}
	public int getIdPersonnePhysiqueFonction() {
		return this.iIdPersonnePhysiqueFonction;
	}
	public int getIdTypeObjet() {
		return this.iIdTypeObjet;
	}
	public int getIdReferenceObjet() {
		return this.iIdReferenceObjet;
	}
	public BigInteger getStatus() {
		return this.biStatus;
	}

	/* SETTERs */
	public void setIdCorrespondant(int iId) {
		this.lId  = iId;
	}
	public void setIdPersonnePhysique(int iId) {
		this.iIdPersonnePhysique = iId;
	}
	public void setIdPersonnePhysiqueFonction(int iId) {
		this.iIdPersonnePhysiqueFonction = iId;
	}
	public void setIdTypeObjet(int iId) {
		this.iIdTypeObjet = iId;
	}
	public void setIdReferenceObjet(int iId) {
		this.iIdReferenceObjet = iId;
	}
	public void setStatus(BigInteger biStatus) {
		this.biStatus = biStatus;
	}

	public static boolean isCorrespondantExist(Correspondant oCorrespondant) throws Exception
	{
		Vector<Correspondant> vCorrespondant = getAllWithWhereClause("");
		for(int i=0;i<vCorrespondant.size();i++)
		{
			Correspondant oCorrespondantInBase = vCorrespondant.get(i);
			if( (oCorrespondantInBase.getIdPersonnePhysique() == oCorrespondant.getIdPersonnePhysique())
					&& (oCorrespondantInBase.getIdPersonnePhysiqueFonction() == oCorrespondant.getIdPersonnePhysiqueFonction())
					&& (oCorrespondantInBase.getIdReferenceObjet() == oCorrespondant.getIdReferenceObjet())
					&& (oCorrespondantInBase.getIdTypeObjet() == oCorrespondant.getIdTypeObjet()))
			{
				return true;
			}
		}
		
		return false;
	}

	/**
	 * Méthode renvoyant la liste des Correspondant en base
	 * @param sSQLQuery - requete SQL
	 * @throws NamingException 
	 * @throws SQLException 
	 * @throws CoinDatabaseLoadException 
	 * @throws IllegalAccessException 
	 * @throws InstantiationException 
	 */
	public static Vector<Correspondant> getAllWithSQLQuery(String sSqlquery) throws NamingException, SQLException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException{

		Correspondant item = new Correspondant();
		return item.getAllWithSqlQuery(sSqlquery);
	}
	
	
	/**
	 * Méthode renvoyant la liste des Correspondant en base
	 * @param sWhereClause - requete SQL de type WHERE...
	 * @throws Exception 
	 */
	public static Vector<Correspondant> getAllWithWhereClause(String sWhereClause, Connection conn) throws Exception {
		Correspondant item = new Correspondant();
		return item.getAllWithWhereAndOrderByClause(sWhereClause, "", conn);
	}
	
	/**
	 * Méthode renvoyant la liste des Correspondant en base
	 * @param sWhereClause - requete SQL de type WHERE...
	 * @throws IllegalAccessException 
	 * @throws InstantiationException 
	 * @throws SQLException 
	 * @throws NamingException 
	 * @throws Exception 
	 */
	public static Vector<Correspondant> getAllWithWhereClause(
			String sWhereClause, 
			boolean bUseHttpPrevent ,
			Connection conn) 
	throws NamingException, SQLException, InstantiationException, IllegalAccessException
	{
		Correspondant item = new Correspondant();
		item.bUseHttpPrevent = bUseHttpPrevent ; 
		return item.getAllWithWhereAndOrderByClause(sWhereClause, "", conn);
	}
	
	
	/**
	 * Méthode renvoyant la liste des Correspondant en base
	 * @param sWhereClause - requete SQL de type WHERE...
	 * @throws IllegalAccessException 
	 * @throws InstantiationException 
	 * @throws SQLException 
	 * @throws NamingException 
	 * @throws Exception 
	 */
	public static Vector<Correspondant> getAllWithWhereClause(String sWhereClause) 
	throws NamingException, SQLException, InstantiationException, IllegalAccessException  {
		Correspondant item = new Correspondant();
		return item.getAllWithWhereAndOrderByClause(sWhereClause, "");
	}
	
	/**
	 * Méthode renvoyant la liste des Correspondant en base associées à un type d'Objet
	 * @param iIdTypeObjet - type d'objet
	 * @throws IllegalAccessException 
	 * @throws InstantiationException 
	 * @throws SQLException 
	 * @throws NamingException 
	 * @throws Exception 
	 */
	public static Vector<Correspondant> getAllCorrespondantFromTypeObjet(int iIdTypeObjet) 
	throws NamingException, SQLException, InstantiationException, IllegalAccessException 
	{
		String sWhereClause = " WHERE id_type_objet_modula='"+iIdTypeObjet+"' ";
		return getAllWithWhereClause(sWhereClause);
	}

	/**
	 * Méthode renvoyant la liste des Correspondant en base associées à un type d'Objet et une reférence et une fonction
	 * @param iIdTypeObjet - type d'objet
	 * @param iIdReferenceObjet - reference de l'objet
	 * @param iIdPersonnePhysiqueFonction - fonction de la pp
	 * @throws IllegalAccessException 
	 * @throws InstantiationException 
	 * @throws SQLException 
	 * @throws NamingException 
	 * @throws Exception 
	 */
	public static Vector<Correspondant> 
	getAllCorrespondantFromTypeAndReferenceObjetAndFonction(
			int iIdTypeObjet,
			int iIdReferenceObjet, 
			int iIdPersonnePhysiqueFonction,
			Connection conn) 
	throws NamingException, SQLException, InstantiationException, IllegalAccessException 

	{
		return 	getAllCorrespondantFromTypeAndReferenceObjetAndFonction(
				iIdTypeObjet,
				iIdReferenceObjet, 
				iIdPersonnePhysiqueFonction,
				true,
				conn) ;

	}

	
	public static Vector<Correspondant> 
	getAllCorrespondantFromTypeAndReferenceObjetAndFonction(
			int iIdTypeObjet,
			int iIdReferenceObjet, 
			int iIdPersonnePhysiqueFonction,
			boolean bUseHttpPrevent,
			Connection conn) throws NamingException, SQLException, InstantiationException, IllegalAccessException 

	{
		String sWhereClause = " WHERE id_type_objet_modula="+iIdTypeObjet
							+ " AND id_reference_objet="+iIdReferenceObjet
							+ " AND id_personne_physique_fonction="+iIdPersonnePhysiqueFonction;
		return getAllWithWhereClause(sWhereClause, bUseHttpPrevent, conn);
	}

	
	/**
	 * Méthode renvoyant la liste des Correspondant en base associées à un type d'Objet et une reférence et une fonction
	 * @param iIdTypeObjet - type d'objet
	 * @param iIdReferenceObjet - reference de l'objet
	 * @param iIdPersonnePhysiqueFonction - fonction de la pp
	 * @throws IllegalAccessException 
	 * @throws InstantiationException 
	 * @throws SQLException 
	 * @throws NamingException 
	 * @throws Exception 
	 */
	public static Vector<Correspondant> getAllCorrespondantFromTypeAndReferenceObjetAndFonction(
			int iIdTypeObjet,
			int iIdReferenceObjet, 
			int iIdPersonnePhysiqueFonction) 
			throws NamingException, SQLException, InstantiationException, IllegalAccessException 

	{
		String sWhereClause = " WHERE id_type_objet_modula='"+iIdTypeObjet+"' "
							+ " AND id_reference_objet='"+iIdReferenceObjet+"' "
							+ " AND id_personne_physique_fonction='"+iIdPersonnePhysiqueFonction+"' ";
		return getAllWithWhereClause(sWhereClause);
	}
	
	/**
	 * Méthode renvoyant la liste des Correspondant en base associées à un type d'Objet et une reférence et une fonction et une personne physique
	 * @param iIdTypeObjet - type d'objet
	 * @param iIdReferenceObjet - reference de l'objet
	 * @param iIdPersonnePhysiqueFonction - fonction de la pp
	 * @param iIdPersonnePhysique - id de la pp
	 * @throws IllegalAccessException 
	 * @throws InstantiationException 
	 * @throws SQLException 
	 * @throws NamingException 
	 * @throws Exception 
	 */
	public static Vector<Correspondant> getAllCorrespondantFromTypeAndReferenceObjetAndPersonneWithFonction(
			int iIdTypeObjet,
			int iIdReferenceObjet, 
			int iIdPersonnePhysique, 
			int iIdPersonnePhysiqueFonction)
	throws NamingException, SQLException, InstantiationException, IllegalAccessException 
	{
		String sWhereClause = " WHERE id_type_objet_modula='"+iIdTypeObjet+"' "
							+ " AND id_reference_objet='"+iIdReferenceObjet+"' "
							+ " AND id_personne_physique='"+iIdPersonnePhysique+"' "
							+ " AND id_personne_physique_fonction='"+iIdPersonnePhysiqueFonction+"' ";
		return getAllWithWhereClause(sWhereClause);
	}
	
	/**
	 * Méthode renvoyant la liste des Correspondant en base associées à un type d'Objet et une reférence
	 * @param iIdTypeObjet - type d'objet
	 * @param iIdReferenceObjet - reference de l'objet
	 * @throws IllegalAccessException 
	 * @throws InstantiationException 
	 * @throws SQLException 
	 * @throws NamingException 
	 * @throws Exception 
	 */
	public static Vector<Correspondant> getAllCorrespondantFromTypeAndReferenceObjet(
			int iIdTypeObjet,
			int iIdReferenceObjet) 
	throws NamingException, SQLException, InstantiationException, IllegalAccessException 
	{
		String sWhereClause = " WHERE id_type_objet_modula='"+iIdTypeObjet+"' "
							+ " AND id_reference_objet='"+iIdReferenceObjet+"' ";
		return getAllWithWhereClause(sWhereClause);
	}

	@Override
	public String getName() {
		return "correspondant_" + this.sId;
	}
	
	public static Vector<Correspondant> getAllWithSqlQueryStatic(String sSQLQuery) 
	throws InstantiationException, IllegalAccessException, NamingException, SQLException {
		Correspondant item = new Correspondant (); 
		return getAllWithSqlQuery(sSQLQuery, item);
	}
	
	public static Vector<Correspondant> getAllStatic() 
	throws InstantiationException, IllegalAccessException, NamingException, SQLException {
		
		Correspondant item = new Correspondant (); 
		return item.getAll();
	}

	public void setFromForm(HttpServletRequest request, String sFormPrefix) throws SQLException, NamingException {
		// TODO Auto-generated method stub
		
	}

	public void setFromResultSet(ResultSet rs) throws SQLException {
		this.iIdPersonnePhysique = rs.getInt(1);
		this.iIdPersonnePhysiqueFonction = rs.getInt(2);
		this.iIdTypeObjet = rs.getInt(3);
		this.iIdReferenceObjet = rs.getInt(4);
		if(rs.getBytes(5) == null) 
		{ 
			this.biStatus = new BigInteger( new byte[] { 0x00 } ); 
		}
		else 
		{
			this.biStatus = new BigInteger( rs.getBytes(5) );
		}	

	}

	public void setPreparedStatement(PreparedStatement ps) throws SQLException {
		ps.setInt(1, this.iIdPersonnePhysique);
		ps.setInt(2, this.iIdPersonnePhysiqueFonction);
		ps.setInt(3, this.iIdTypeObjet);
		ps.setInt(4, this.iIdReferenceObjet);
		ps.setBytes(5, BitField.getStatusFormated (this.biStatus) );

	}
}
