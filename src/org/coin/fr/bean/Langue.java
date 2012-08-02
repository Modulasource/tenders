/*
 * Created on 4 nov. 2004
 *
 */
package org.coin.fr.bean;

import java.sql.*;
import java.util.Vector;

import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;

import modula.marche.Marche;
 
import org.coin.db.CoinDatabaseLoadException;
import org.coin.db.CoinDatabaseStoreException;
import org.coin.db.ConnectionManager;
import org.coin.security.PreventInjection;
import org.coin.util.Enumerator;
import org.coin.util.Outils;

/**
 *
 */
//TODO: il y a 2 tables ici pour un meme objet
//à dissocier en 2 objets
//bIsAutoIncrement = false
public class Langue extends Enumerator {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	protected static final String TABLE_LANGUE_MARCHE = "marche_langue";

	public void setConstantes() {
		super.TABLE_NAME = "langue";
		super.FIELD_ID_NAME  = "id_langue";
		super.FIELD_NAME_NAME = "libelle";
		super.SELECT_FIELDS_NAME = super.FIELD_NAME_NAME;
		super.SELECT_FIELDS_NAME_SIZE = 1;
	}
	/**
	 * 
	 */
	public Langue() {
		super();
		setConstantes();
	}

	/**
	 * @param iId
	 * @param sName
	 */
	public Langue(int iId, String sName) {
		super(iId, sName);
		setConstantes();
	}

	/**
	 * @param iId
	 */
	public Langue(int iId) {
		super(iId);
		setConstantes();
	}

	/**
	 * @param sName
	 */
	public Langue(String sName) {
		super(sName);
		setConstantes();
	}

	public Langue(int iId, String sName,boolean bUseHttpPrevent) {
		super(iId,sName);
		this.bUseHttpPrevent = bUseHttpPrevent;
		setConstantes();
	}

	protected Enumerator getAll_onNewItem(int iId, String sName)
	{
		return getAll_onNewItem(iId,sName,true);
	}

	protected Enumerator getAll_onNewItem(int iId, String sName,boolean bUseHttpPrevent)
	{
		return new Langue(iId, sName,bUseHttpPrevent);
	}

	/**
	 * Méthode renvoyant le libellé de la langue identifiée
	 * @param sId - identifiant de la langue
	 * @return le libellé de la langue
	 * @throws NamingException 
	 * @throws SQLException 
	 * @throws CoinDatabaseLoadException 
	 * @throws Exception 
	 */
	public static String getLangueName(String sId)
	throws CoinDatabaseLoadException, SQLException, NamingException {
		Langue langue = new Langue(sId);
		langue.load();
		return langue.getName();
	}
	/**
	 * Méthode renvoyant l'objet Langue identifié
	 * @param sId - identifiant de l'objet Langue
	 * @return un objet Langue
	 * @throws NamingException 
	 * @throws SQLException 
	 * @throws CoinDatabaseLoadException 
	 * @throws Exception 
	 */
	public static Langue getLangue(int iId) 
	throws CoinDatabaseLoadException, SQLException, NamingException  {
		Langue langue = new Langue(iId);
		langue.load();
		return langue;
	}
	public static Langue getLangue(int iId,boolean bUseHttpPrevent) 
	throws CoinDatabaseLoadException, SQLException, NamingException {
		Langue langue = new Langue(iId);
		langue.bUseHttpPrevent = bUseHttpPrevent;
		langue.load();
		return langue;
	}
	
	public static Langue getLangue(
			int iId,
			boolean bUseHttpPrevent,
			Connection conn) 
	throws CoinDatabaseLoadException, NamingException, SQLException 
	{
		Langue langue = new Langue(iId);
		langue.bUseHttpPrevent = bUseHttpPrevent;
		langue.load(conn);
		return langue;
	}
	/**
	 * Méthode renvoyant tous les Langue
	 * @return un Vector d'objets LAngue, sinon un Vector null
	 * @throws SQLException 
	 * @throws NamingException 
	 */
	public static Vector getAllLangue() throws SQLException, NamingException
	{
		Langue langue = new Langue();
		return langue.getAllOrderById();
	}
	/**
	 * Méthode renvoyant toutes les langues du marché identifié
	 * @param iId - identifiant du marché
	 * @return un Vector d'objets Langue sinon un Vector null
	 * @throws NamingException 
	 * @throws SQLException 
	 * @throws CoinDatabaseLoadException 
	 * @throws IllegalAccessException 
	 * @throws InstantiationException 
	 * @throws Exception 
	 */
	public static Vector<Langue> getAllLangueFromMarche(int iId) 
	throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException{
		return getAllLangueFromMarche(iId,true);
	}


	public static Vector<Langue> getAllLangueFromMarche(int iId,boolean bUseHttpPrevent) 
	throws SQLException, NamingException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException  {
		Connection conn = ConnectionManager.getDataSource().getConnection(); 

		try {
			return getAllLangueFromMarche(iId,bUseHttpPrevent, conn);
		} finally {
			ConnectionManager.closeConnection(conn);
		}
	}    

	public static Vector<Langue> getAllLangueFromMarche(int iId,boolean bUseHttpPrevent, Connection conn) 
	throws SQLException, CoinDatabaseLoadException, NamingException, InstantiationException, IllegalAccessException
	{
		Langue item = new Langue();
		item.bUseHttpPrevent = bUseHttpPrevent;
		String sSqlquery = item.getAllSelect("l.") 
		 		+ " , " + TABLE_LANGUE_MARCHE + " lm"
		 		+ " WHERE lm.id_langue=l.id_langue" 
				+ " AND lm.id_marche=" + iId;
			
		return item.getAllWithSqlQuery(sSqlquery, conn);
	}



	/**
	 * Méthode renvoyant toutes les langues du marché identifié
	 * @param lId - identifiant du marché
	 * @return un Vector d'objets Langue sinon un Vector null
	 * @throws NamingException 
	 * @throws SQLException 
	 */
	public static void removeAllLangueFromMarche(int iIdAffaire) throws NamingException, SQLException {
		String sSQLQuery = "DELETE "
			+ " FROM "
			+ TABLE_LANGUE_MARCHE
			+ " WHERE id_marche='" + iIdAffaire + "'";
		
		ConnectionManager.executeUpdate(sSQLQuery);
	}

	/**
	 * Création de la langue courante pour le marché identifié
	 * @param iIdMarche - identifiant du marché
	 * @return true si réussi, sinon false
	 * @throws SQLException 
	 * @throws NamingException 
	 */
	public static void addInAffaire(int iIdLangue, int iIdAffaire) throws SQLException, NamingException {
		
		String sSqlQuery = "INSERT INTO "
			+ TABLE_LANGUE_MARCHE
			+ " ( id_langue , "
			+ "id_marche "
			+ " ) "
			+ " VALUES (?, ?)";
		PreparedStatement ps = null;
		Connection conn = null;
		Statement stat = null;

		try {
			conn = ConnectionManager.getDataSource().getConnection();
			stat = conn.createStatement(java.sql.ResultSet.TYPE_FORWARD_ONLY,
					java.sql.ResultSet.CONCUR_UPDATABLE);
			ps = (stat.getConnection()).prepareStatement(sSqlQuery);

			ps.setInt(1, iIdLangue);
			ps.setInt(2, iIdAffaire);
			ps.executeUpdate();
		} finally {
			ConnectionManager.closeConnection(stat, conn, ps);
		}
	}

	public static String getLangueXML(int iIdLangue) 
	throws SQLException, NamingException, CoinDatabaseLoadException 
	{

		Connection conn = ConnectionManager.getDataSource().getConnection();
		try {
			return getLangueXML(iIdLangue, true, conn);
		} finally{
			ConnectionManager.closeConnection(conn);	
		}
	}

	
	public static String getLangueXML(
			int iIdLangue,
			boolean bUseHttpPrevent,
			Connection conn) 
	throws CoinDatabaseLoadException, SQLException
	
	{
		String sXML = "";

		String sSQLQuery = 	"SELECT libelle_court "
			+ " FROM langue " 
			+ " WHERE id_langue='" + iIdLangue + "'" ;

		Statement stat = null;
		ResultSet rs = null;

		try {
			stat = conn.createStatement();
			rs = stat.executeQuery(sSQLQuery);

			Langue lang = new Langue();
			lang.bUseHttpPrevent = bUseHttpPrevent;
			if (rs.next()) {
				sXML = PreventInjection.preventLoad(rs.getString(1),lang.bUseHttpPrevent);
			}
			else
			{
				throw new CoinDatabaseLoadException("" + iIdLangue , sSQLQuery);
			}

		}
		finally{
			ConnectionManager.closeConnection(rs, stat);
		}

		return sXML;
	}




	public static void updateAll(
			Marche marche,
			HttpServletRequest request)
	throws NamingException, SQLException, CoinDatabaseStoreException 
	{
		Langue.removeAllLangueFromMarche(marche.getIdMarche());

		int[] iLangues = null;
		if (request.getParameter("languesHidden") != null)
			iLangues = Outils.parserChaineVersEntier(request.getParameter("languesHidden"), "|");

		if (iLangues != null)
		{
			for (int i = 0; i < iLangues.length; i++)
			{
				Langue.addInAffaire(iLangues[i] , marche.getIdMarche());
			}
		}

		if (request.getParameter("sLangueAutre") != null)
			marche.setLangueAutre(request.getParameter("sLangueAutre"));

		marche.store();
	}
}
