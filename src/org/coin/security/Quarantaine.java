/****************************************************************************
Studio Matamore - France 2005
Contact : studio@matamore.com - http://www.matamore.com
****************************************************************************/

package org.coin.security;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.Vector;

import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;

import org.coin.db.CoinDatabaseAbstractBean;
import org.coin.db.CoinDatabaseCreateException;
import org.coin.db.CoinDatabaseDuplicateException;
import org.coin.db.CoinDatabaseLoadException;
import org.coin.db.ConnectionManager;

/**
 * Gestion de la quarantaine
 * @author julien
 *
 */
public class Quarantaine extends CoinDatabaseAbstractBean
{
	private static final long serialVersionUID = 1L;
	
	protected int iIdTypeObjet ;
	protected int iIdReferenceObjet ;
	protected InputStream isFile;
	protected String sFileName;
	protected String sContentType;
	protected Timestamp tsDate;
	protected String sRapport;
	
	public void setPreparedStatement (PreparedStatement ps ) throws SQLException 
	{
		int i = 0;
		ps.setInt(++i, this.iIdTypeObjet);
		ps.setInt(++i, this.iIdReferenceObjet);
		ps.setString(++i, preventStore(this.sFileName));
		ps.setString(++i, preventStore(this.sContentType));
		ps.setTimestamp(++i, this.tsDate);
		ps.setString(++i, preventStore(this.sRapport));
	}
	
	public void setFromResultSet(ResultSet rs) throws SQLException 
	{
		int i = 0;
		this.iIdTypeObjet = rs.getInt(++i);
		this.iIdReferenceObjet = rs.getInt(++i);
		this.sFileName = preventLoad(rs.getString(++i));
		this.sContentType = preventLoad(rs.getString(++i));
		this.tsDate = rs.getTimestamp(++i);
		this.sRapport = preventLoad(rs.getString(++i));
	}
	
	public static String getStaticSelectFieldsName(String sAlias)
	{
		Quarantaine doc = new Quarantaine();
		return doc.getSelectFieldsName(sAlias);
	}
	
	public Quarantaine() {
		this.init();
	}
	public Quarantaine(int i) {
		init();
		this.lId = i;
	}
	
	public static Quarantaine getQuarantaine(int iIdQuarantaine) throws CoinDatabaseLoadException, NamingException, SQLException {
		return getQuarantaine(iIdQuarantaine,true);
	}
	public static Quarantaine getQuarantaine(int iIdQuarantaine,boolean bUseHttpPrevent) throws CoinDatabaseLoadException, NamingException, SQLException {
		Quarantaine item = new Quarantaine(iIdQuarantaine);
		item.bUseHttpPrevent = bUseHttpPrevent;
		item.load();
		return item;
	}

	public String getName() {
		return this.sFileName;
	}
	public int getIdTypeObjet() {
		return this.iIdTypeObjet;
	}
	public int getIdReferenceObjet() {
		return this.iIdReferenceObjet;
	}
	public String getRapport() {
		return this.sRapport;
	}
	public InputStream getFile() {
		return this.isFile;
	}
	public String getFileName() {
		return this.sFileName;
	}
	public String getContentType() {
		return this.sContentType;
	}
	public Timestamp getDate() {
		return this.tsDate;
	}
	
	public void setName(String sName) {
		this.sFileName = sName;
	}
	public void setIdTypeObjet(int iIdTypeObjet) {
		this.iIdTypeObjet = iIdTypeObjet;
	}
	public void setIdReferenceObjet(int iIdReferenceObjet) {
		this.iIdReferenceObjet = iIdReferenceObjet;
	}
	public void setRapport(String sRapport) {
		this.sRapport = sRapport;
	}
	public void setFile(File f) 
	{
		try 
		{
			FileInputStream isFile = new FileInputStream(f);
			setFile(isFile);
		} 
		catch (FileNotFoundException e) {
			e.printStackTrace();
		}
	}
	public void setFile(InputStream is) 
	{
		this.isFile = is;
	}
	public void setFileName(String sFileName) {
		this.sFileName = sFileName;
	}
	public void setContentType(String sContentType) {
		this.sContentType = sContentType;
	}
	public void setDate(Timestamp tsDate) {
		this.tsDate = tsDate;
	}
	
	public void create() throws CoinDatabaseCreateException, CoinDatabaseDuplicateException, SQLException, NamingException, CoinDatabaseLoadException
	{
		this.tsDate = new Timestamp(System.currentTimeMillis());
		super.create();
	}
	
	public void removeWithObjectAttached() throws Exception {
		this.remove();
	}
	
	public static Vector<Quarantaine> getAllWithSqlQueryStatic(String sSQLQuery) throws InstantiationException, IllegalAccessException, NamingException, SQLException 
	{
		Quarantaine item = new Quarantaine(); 
		return getAllWithSqlQuery(sSQLQuery, item);
	}
	
	public static Vector<Quarantaine> getAllQuarantaineFromTypeAndReferenceObjet(int iIdTypeObjet, int iIdReferenceObjet) throws Exception 
	{
		Quarantaine quar = new Quarantaine();
		String sSqlQuery = "SELECT "+quar.getSelectFieldsName("") + ", " + quar.FIELD_ID_NAME 
			+ " FROM "+quar.TABLE_NAME
			+ " WHERE id_type_objet = " + iIdTypeObjet
			+ " AND id_reference_objet = " + iIdReferenceObjet;

		return getAllWithSqlQuery(sSqlQuery, quar);
	}

	public void init()
	{
		this.TABLE_NAME = "coin_quarantaine";
		this.FIELD_ID_NAME = "id_coin_quarantaine";

		// il ne doit y avoir d'espace apres la virgule => pour ajouter les alias.
		this.SELECT_FIELDS_NAME 
			= " id_type_objet,"
			+ " id_reference_objet,"
			+ " nom_fichier,"
			+ " content_type,"
			+ " date,"
			+ " rapport";
			
			
		this.SELECT_FIELDS_NAME_SIZE = this.SELECT_FIELDS_NAME.split(",").length ; 
	
		this.lId = 0;
		this.iIdTypeObjet = 0;
		this.iIdReferenceObjet = 0;
		this.isFile = null;
		this.sFileName = "";
		this.sContentType = "";
		this.tsDate = null;	
		this.sRapport = "";
	}

	public static InputStream getFile(int iIdQuarantaine )
	throws SQLException, NamingException, CoinDatabaseLoadException {
		String sSqlQuery = "SELECT fichier" 
					+ " FROM coin_quarantaine"
					+ " WHERE id_coin_quarantaine=" + iIdQuarantaine;
		
		InputStream isFile = null;
		Connection conn = null;
		Statement stat = null;
		ResultSet resultat = null;
		
		try 
		{
			conn = ConnectionManager.getDataSource().getConnection();
			stat = conn.createStatement();
			resultat = stat.executeQuery(sSqlQuery);
			
			if(resultat.next()) {
				isFile = resultat.getBinaryStream(1);
			}
			else
			{
				throw new CoinDatabaseLoadException("coin_quarantaine fichier non chargé "
						+ iIdQuarantaine, sSqlQuery );
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
		
		return isFile;
	}
	
	public static InputStream getRapportFile(int iIdQuarantaine ) 
	throws SQLException, NamingException, CoinDatabaseLoadException {
		String sSqlQuery = "SELECT rapport" 
					+ " FROM coin_quarantaine"
					+ " WHERE id_coin_quarantaine=" + iIdQuarantaine;
		
		InputStream isFile = null;
		Connection conn = null;
		Statement stat = null;
		ResultSet resultat = null;
		
		try 
		{
			conn = ConnectionManager.getDataSource().getConnection();
			stat = conn.createStatement();
			resultat = stat.executeQuery(sSqlQuery);
			
			if(resultat.next()) {
				isFile = resultat.getBinaryStream(1);
			}
			else
			{
				throw new CoinDatabaseLoadException("coin_quarantaine rapport non chargé " 
						+ iIdQuarantaine, sSqlQuery );
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
		
		return isFile;
	}

	public void storeFile() 
	throws SQLException, NamingException 
	{
		Connection conn = getConnection();
		try{
			storeFile(conn);
		} finally {
			releaseConnection(conn);
		}
	}
	public void storeFile(
			Connection conn) 
	throws SQLException, NamingException 
	{
		String requete = "UPDATE " + this.TABLE_NAME+ " SET "
		+ " fichier=? "
		+ " WHERE " + this.FIELD_ID_NAME + "=" + this.lId;
		
		PreparedStatement ps = null;
		try {
			conn = ConnectionManager.getDataSource().getConnection();
			ps = conn.prepareStatement(requete);
			ps.setBinaryStream(1, this.isFile, -1);
			ps.executeUpdate();
			
		} finally {
			ConnectionManager.closeConnection(ps);
		}
	}

	public void setFromForm(HttpServletRequest request, String sFormPrefix) {
	}
}
