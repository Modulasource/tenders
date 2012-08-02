/****************************************************************************
Studio Matamore - France 2004
Contact : studio@matamore.com - http://www.matamore.com
 ****************************************************************************/

package org.coin.fr.bean;

import org.coin.bean.ObjectType;
import org.coin.db.*;
import org.coin.util.FileUtil;
import org.coin.util.Outils;

import java.io.* ;
import java.sql.*;

import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;

import java.util.*;

public class Multimedia extends CoinDatabaseAbstractBeanTimeStamped {

	private static final long serialVersionUID = 3257003267761452848L;

	protected int iIdMultimediaType;
	protected int iIdTypeObjet;
	protected String sContentType;
	protected int iIdReferenceObjet;
	protected InputStream isMultimediaFile;
	protected String sFileName;
	protected String sReference;
	protected String sLibelle;
	protected boolean bIsPhysique;
	protected String sPathFile;
	
	protected static Map<String,String>[] s_sarrLocalizationLabel;

	/**
	 * @return Returns the iIdMultimedia.
	 */
	public int getIdMultimedia() {
		return (int)this.lId;
	}
	/**
	 * @param idMultimedia The iIdMultimedia to set.
	 */
	public void setIdMultimedia(int idMultimedia) {
		this.lId= idMultimedia;
	}
	/**
	 * @return Returns the iIdMultimediaType.
	 */
	public int getIdMultimediaType() {
		return this.iIdMultimediaType;
	}
	/**
	 * @param idMultimediaType The iIdMultimediaType to set.
	 */
	public void setIdMultimediaType(int idMultimediaType) {
		this.iIdMultimediaType = idMultimediaType;
	}

	public void setPathFile(String sPathFile){
		this.sPathFile = sPathFile;
	}
	/**
	 * @return Returns the iIdReferenceObjet.
	 */
	public int getIdReferenceObjet() {
		return this.iIdReferenceObjet;
	}

	public String getPathFile(){
		return this.sPathFile;
	}

	public String getTextContent() 
	throws SQLException, NamingException, CoinDatabaseLoadException, IOException
	{
		Connection conn = this.getConnection();
		try{
			return getTextContent(conn);
		} finally {
			ConnectionManager.closeConnection(conn);
		}
	}
	
	public String getTextContent(
			Connection conn) 
	throws CoinDatabaseLoadException, NamingException, SQLException, IOException
	{
		String sResult = "";
		InputStreamReader ipsr=new InputStreamReader(
				getInputStreamMultimediaFile(
						this.lId,
						conn));

		BufferedReader br=new BufferedReader(ipsr);
		String ligne;
		while ((ligne=br.readLine())!=null) 
			sResult +=ligne+"\n";
		br.close();
		return sResult;
	}
	/**
	 * @param idReferenceObjet The iIdReferenceObjet to set.
	 */
	public void setIdReferenceObjet(int idReferenceObjet) {
		this.iIdReferenceObjet = idReferenceObjet;
	}
	/**
	 * @return Returns the iIdTypeObjet.
	 */
	public int getIdTypeObjet() {
		return this.iIdTypeObjet;
	}
	/**
	 * @return Returns the sReference.
	 */
	public String getReference() {
		return this.sReference;
	}
	/**
	 * @return Returns the sLibelle.
	 */
	public String getLibelle() {
		return this.sLibelle;
	}
	/**
	 * @param idTypeObjet The iIdTypeObjet to set.
	 */
	public void setIdTypeObjet(int idTypeObjet) {
		this.iIdTypeObjet = idTypeObjet;
	}
	/**
	 * @return Returns the isMultimediaFile.
	 */
	public InputStream getMultimediaFile() {
		return this.isMultimediaFile;
	}
	/**
	 * @param isMultimediaFile The isMultimediaFile to set.
	 */
	public void setMultimediaFile(InputStream isMultimediaFile) {
		this.isMultimediaFile = isMultimediaFile;
	}
	/**
	 * @return Returns the sContentType.
	 */
	public String getContentType() {
		return this.sContentType;
	}
	/**
	 * @param contentType The sContentType to set.
	 */
	public void setContentType(String contentType) {
		this.sContentType = contentType;
	}
	/**
	 * @param sReference The sReference to set.
	 */
	public void setReference(String sReference) {
		this.sReference = sReference;
	}
	/**
	 * @param sLibelle The sLibelle to set.
	 */
	public void setLibelle(String sLibelle) {
		this.sLibelle = sLibelle;
	}

	/**
	 * Constructeur vide de la classe Organisation (par défaut)
	 */
	public Multimedia() {
		init();
	}
	/**
	 * Constructeur de la classe Organisation
	 * @param i - identifiant de l'enregistrement correspondant
	 */
	public Multimedia(long id) {
		init();
		this.lId = id;
	}

	/**
	 * Méthode initialisant tous les champs 
	 * avec des valeurs par défaut
	 */
	public void init() {

		this.TABLE_NAME = "coin_multimedia";
		this.FIELD_ID_NAME = "id_"+ this.TABLE_NAME ;
		
		this.SELECT_FIELDS_NAME 
			= " id_coin_multimedia_type, "
			+ " id_type_objet, "
			+ " content_type, "
			+ " id_reference_objet, "
			+ " date_creation, "
			+ " date_modification, "
			+ " reference, "
			+ " libelle, "
			+ " filename, "
			+ " path_file, "
			+ " is_physique";
		this.SELECT_FIELDS_NAME_SIZE = this.SELECT_FIELDS_NAME.split(",").length ; 
		this.iAbstractBeanIdObjectType = ObjectType.MULTIMEDIA;
		
		this.lId = 0;
		this.iIdMultimediaType = 0;
		this.iIdTypeObjet = 0;
		this.sContentType = "";
		this.iIdReferenceObjet = 0;
		this.isMultimediaFile = null;
		this.tsDateCreation = null;
		this.tsDateModification = null;
		this.sFileName = "";
		this.sReference = "";
		this.sLibelle = "";
		this.bIsPhysique = false;
		this.sPathFile = "";
	}


	public static Multimedia getMultimedia (long iIdMultimedia ) 
	throws CoinDatabaseLoadException, NamingException, SQLException {
		return getMultimedia(iIdMultimedia,true);
	}
	
	public static Multimedia getMultimedia (long iIdMultimedia,boolean bUseHttpPrevent ) 
	throws CoinDatabaseLoadException, NamingException, SQLException {
		Multimedia multimedia = new Multimedia (iIdMultimedia );
		multimedia.bUseHttpPrevent = bUseHttpPrevent;
		multimedia.load();
		return multimedia ;
	}
	
	public static Multimedia getMultimedia (
			long lIdMultimedia,
			boolean bUseHttpPrevent,
			Connection conn) 
	throws CoinDatabaseLoadException, NamingException, SQLException {
		Multimedia item = new Multimedia (lIdMultimedia );
		item.bUseHttpPrevent = bUseHttpPrevent;
		item.load(conn);
		return item;
	}

	public static Multimedia getMultimedia (
			int iIdMultimediaType,
			int iIdReferenceObjet,
			int iIdTypeObjet) 
	throws NamingException, SQLException, CoinDatabaseLoadException, InstantiationException, 
	IllegalAccessException 
	{
		Connection conn = ConnectionManager.getConnection();
		try{
			return getMultimedia(
					iIdMultimediaType, 
					iIdReferenceObjet, 
					iIdTypeObjet, 
					false, 
					conn) ;
		} finally {
			ConnectionManager.closeConnection(conn);
		}
	}

	public static Multimedia getMultimedia (
			long lIdMultimediaType,
			long lIdReferenceObjet,
			long lIdTypeObjet,
			boolean bUseHttpPrevent,
			Connection conn) 
	throws NamingException, SQLException, CoinDatabaseLoadException, InstantiationException, 
	IllegalAccessException 
	{
		return getMultimedia(
			lIdMultimediaType, 
			lIdReferenceObjet, 
			lIdTypeObjet, 
			null,
			bUseHttpPrevent, 
			conn);
	}	
	
	public static Multimedia getMultimedia (
			long lIdMultimediaType,
			long lIdReferenceObjet,
			long lIdTypeObjet,
			String sLabel,
			boolean bUseHttpPrevent,
			Connection conn) 
	throws NamingException, SQLException, CoinDatabaseLoadException, InstantiationException, 
	IllegalAccessException 
	{
		Multimedia item = new Multimedia();
		String sWhereClause 
			= " WHERE "
			+ " id_coin_multimedia_type = " + lIdMultimediaType
			+ " AND id_reference_objet = " + lIdReferenceObjet
			+ " AND id_type_objet = " + lIdTypeObjet;
			
		if(sLabel != null) {
			sWhereClause += " AND libelle = \"" + sLabel + "\"";
		}
		item.bUseHttpPrevent = bUseHttpPrevent;
		item.bUseEmbeddedConnection = true;
		item.connEmbeddedConnection = conn;

		
		Vector<Multimedia> vMultis = item.getAllWithWhereAndOrderByClause(sWhereClause, "");	

		if (vMultis.size() > 0)
			return vMultis.get(0) ;

		return null;
	}

	public static Vector<Multimedia> getAllMultimedia (
			int iIdMultimediaType,
			int iIdReferenceObjet,
			int iIdTypeObjet,
			boolean bUseHttpPrevent,
			Connection conn) 
	throws CoinDatabaseLoadException, NamingException, SQLException, InstantiationException, IllegalAccessException 
	{
		Multimedia item = new Multimedia();

		String sWhereClause =
			  " WHERE"
			+ " id_coin_multimedia_type = " + iIdMultimediaType
			+ " AND id_reference_objet = " + iIdReferenceObjet
			+ " AND id_type_objet = " + iIdTypeObjet;
		item.bUseHttpPrevent = bUseHttpPrevent;
		return item.getAllWithWhereAndOrderByClause(sWhereClause, "", conn);	
	}

	
	public static Vector<Multimedia> getAllMultimedia (
			int iIdMultimediaType,
			boolean bUseHttpPrevent,
			Connection conn) 
	throws CoinDatabaseLoadException, NamingException, SQLException, InstantiationException, IllegalAccessException 
	{
		Multimedia item = new Multimedia();

		String sWhereClause =
			  " WHERE"
			+ " id_coin_multimedia_type = " + iIdMultimediaType;

		item.bUseHttpPrevent=bUseHttpPrevent;
		return item.getAllWithWhereAndOrderByClause(sWhereClause, "", conn);	
	}
	
	public static String getMultimediaFirstOccurenceValueString(
			int iIdMultimediaType,
			String sPageTitle,
			String sIdReferenceObjet,
			int iIdTypeObjet,
			String sDefaultValue) 
	throws IOException, CoinDatabaseLoadException, NamingException, SQLException, 
	InstantiationException, IllegalAccessException 
	{
		
		return getMultimediaFirstOccurenceValueString(
				iIdMultimediaType, 
				sPageTitle,
				Integer.parseInt(sIdReferenceObjet), 
				iIdTypeObjet, 
				sDefaultValue);
	}
	
	public static String getMultimediaFirstOccurenceValueString(
			int iIdMultimediaType,
			String sIdReferenceObjet,
			int iIdTypeObjet,
			String sDefaultValue) 
	throws IOException, CoinDatabaseLoadException, NamingException, SQLException, 
	InstantiationException, IllegalAccessException 
	{
		
		return getMultimediaFirstOccurenceValueString(
				iIdMultimediaType, 
				Integer.parseInt(sIdReferenceObjet), 
				iIdTypeObjet, 
				sDefaultValue);
	}
	
	public static String getMultimediaFirstOccurenceValueString(
			int iIdMultimediaType,
			int iIdReferenceObjet,
			int iIdTypeObjet,
			String sDefaultValue) 
	throws IOException, CoinDatabaseLoadException, NamingException, SQLException, 
	InstantiationException, IllegalAccessException 
	{
		return getMultimediaFirstOccurenceValueString(
				iIdMultimediaType, 
				null,
				iIdReferenceObjet, 
				iIdTypeObjet, 
				sDefaultValue);
	}
	
	public static String getMultimediaFirstOccurenceValueString(
			int iIdMultimediaType,
			String sPageTitle,
			int iIdReferenceObjet,
			int iIdTypeObjet,
			String sDefaultValue) 
	throws IOException, CoinDatabaseLoadException, NamingException, SQLException, 
	InstantiationException, IllegalAccessException 
	{
		Multimedia item = getMultimediaFirstOccurence(
				iIdMultimediaType, 
				sPageTitle,
				iIdReferenceObjet, 
				iIdTypeObjet);
		
		InputStream is = item.getInputStreamMultimediaFile();
    	String sText = FileUtil.convertInputStreamInString(
    			is,
    			sDefaultValue );
    	
    	
    	is.close();
    	
    	return sText;
	}
	
	public static Multimedia getMultimediaFirstOccurence(
			int iIdMultimediaType,
			int iIdReferenceObjet,
			int iIdTypeObjet) 
	throws CoinDatabaseLoadException, NamingException, SQLException, InstantiationException, IllegalAccessException 
	{
		return getMultimediaFirstOccurence(
				iIdMultimediaType, 
				null,
				iIdReferenceObjet, 
				iIdTypeObjet);
	}
	
	public static Multimedia getMultimediaFirstOccurence(
			int iIdMultimediaType,
			String sPageTitle,
			int iIdReferenceObjet,
			int iIdTypeObjet) 
	throws CoinDatabaseLoadException, NamingException, SQLException, InstantiationException, IllegalAccessException 
	{
		Vector<Multimedia> vMulti = Multimedia.getAllMultimedia(
				iIdMultimediaType,
				sPageTitle,
				iIdReferenceObjet,
				iIdTypeObjet);
		return vMulti.firstElement();
		
	}
	
	public static Multimedia getMultimediaFirstOccurence(
			int iIdMultimediaType,
			int iIdReferenceObjet,
			int iIdTypeObjet,
			Connection conn) 
	throws CoinDatabaseLoadException, NamingException, SQLException, InstantiationException, IllegalAccessException 
	{
		Vector<Multimedia> vMulti = Multimedia.getAllMultimedia(
				iIdMultimediaType,
				iIdReferenceObjet,
				iIdTypeObjet,
				false,
				conn);
		return vMulti.firstElement();
		
	}
	
	public static Vector<Multimedia> getAllWithWhereAndOrderByClauseStatic (
			String sWhereClause,
			String sOrderByClause)
	throws NamingException, SQLException, InstantiationException, IllegalAccessException 
	{
		Multimedia item = new Multimedia();

		return item.getAllWithWhereAndOrderByClause(sWhereClause, sOrderByClause);	

	}
	
	public static Vector<Multimedia> getAllMultimedia (
			int iIdMultimediaType,
			String sPageTitle,
			int iIdReferenceObjet,
			int iIdTypeObjet) 
	throws CoinDatabaseLoadException, NamingException, SQLException, InstantiationException, IllegalAccessException 
	{
		Multimedia item = new Multimedia();

		String sWhereClauseBis =
			  " WHERE"
			+ " id_coin_multimedia_type = " + iIdMultimediaType
			+ " AND id_reference_objet = " + iIdReferenceObjet
			+ " AND id_type_objet = " + iIdTypeObjet
			+ (Outils.isNullOrBlank(sPageTitle)?"":" AND filename = '"+sPageTitle+"'");

		return item.getAllWithWhereAndOrderByClause(sWhereClauseBis , "");	
	}
	
	public static Vector<Multimedia> getAllMultimedia (
			int iIdMultimediaType,
			int iIdReferenceObjet,
			int iIdTypeObjet) 
	throws CoinDatabaseLoadException, NamingException, SQLException, InstantiationException, IllegalAccessException 
	{
		Multimedia item = new Multimedia();

		String sWhereClauseBis =
			  " WHERE"
			+ " id_coin_multimedia_type = " + iIdMultimediaType
			+ " AND id_reference_objet = " + iIdReferenceObjet
			+ " AND id_type_objet = " + iIdTypeObjet;

		return item.getAllWithWhereAndOrderByClause(sWhereClauseBis , "");	
	}
	
	public static Vector<Multimedia> getAllMultimedia (
			int iIdMultimediaType,
			Vector<? extends CoinDatabaseAbstractBean> vReferenceObjects,
			int iIdTypeObjet) 
	throws CoinDatabaseLoadException, NamingException, SQLException, InstantiationException, IllegalAccessException 
	{
		Multimedia item = new Multimedia();
		CoinDatabaseWhereClause cw = new CoinDatabaseWhereClause(CoinDatabaseWhereClause.ITEM_TYPE_INTEGER);
		cw.addAll(vReferenceObjects);
		
		String sWhereClauseBis =
			  " WHERE"
			+ " id_coin_multimedia_type = " + iIdMultimediaType
			+ " AND " + cw.generateWhereClause("id_reference_objet")
			+ " AND id_type_objet = " + iIdTypeObjet;

		return item.getAllWithWhereAndOrderByClause(sWhereClauseBis , "");	
	}
	
	public static Vector<Multimedia> getAllMultimedia (
			int iIdMultimediaType,
			int iIdReferenceObjet,
			int iIdTypeObjet,
			Vector<Multimedia> vMultimedia) 
	throws CoinDatabaseLoadException, NamingException, SQLException, InstantiationException, IllegalAccessException 
	{
		return getAllMultimedia(
				iIdMultimediaType, 
				null,
				iIdReferenceObjet,
				iIdTypeObjet,
				vMultimedia);
	}
	
	public static Vector<Multimedia> getAllMultimedia (
			int iIdMultimediaType,
			String sPageTitle,
			int iIdReferenceObjet,
			int iIdTypeObjet,
			Vector<Multimedia> vMultimedia) 
	throws CoinDatabaseLoadException, NamingException, SQLException, InstantiationException, IllegalAccessException 
	{
		Vector<Multimedia> vMultimediaSelected = new Vector<Multimedia>();
		
		for (int i = 0; i < vMultimedia.size(); i++) {
			Multimedia item = vMultimedia.get(i);
			
			if(item.getIdMultimediaType() == iIdMultimediaType
			&& item.getIdReferenceObjet() == iIdReferenceObjet
			&& item.getIdTypeObjet() == iIdTypeObjet
			&& (
					Outils.isNullOrBlank(sPageTitle) || 
					(!Outils.isNullOrBlank(sPageTitle) && sPageTitle.equalsIgnoreCase(item.sFileName))
				) 
			)
			{
				vMultimediaSelected.add(item);
			}
		}
		
		return vMultimediaSelected;
	}

	public static Vector<Multimedia> getAllMultimedia (
			int iIdReferenceObjet,
			int iIdTypeObjet) 
	throws NamingException, SQLException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException 
	{
		Connection conn = ConnectionManager.getConnection();
		try{
			return getAllMultimedia(iIdReferenceObjet, iIdTypeObjet, true, conn);
		} finally {
			ConnectionManager.closeConnection(conn);
		}
		
	}
	
	public static Vector<Multimedia> getAllMultimedia (
			int iIdReferenceObjet,
			int iIdTypeObjet,
			boolean bUseHttpPrevent,
			Connection conn) 
	throws NamingException, SQLException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException 
	{
		Multimedia item = new Multimedia();
		String sWhereClause 
			= " WHERE id_reference_objet = " + iIdReferenceObjet
			+ " AND id_type_objet = " + iIdTypeObjet;
		item.bUseHttpPrevent = bUseHttpPrevent;
		return item.getAllWithWhereAndOrderByClause(sWhereClause, "", conn);	
	}
	
	public InputStream getInputStreamMultimediaFile() 
	throws CoinDatabaseLoadException, NamingException, SQLException 
	{
		return getInputStreamMultimediaFile(this.lId);
	}
	
	public InputStream getInputStreamMultimediaFile(Connection conn) 
	throws CoinDatabaseLoadException, NamingException, SQLException 
	{
		return getInputStreamMultimediaFile(this.lId, conn);
	}

	public File getMultimediaFileTemp(Connection conn)
	throws IOException, CoinDatabaseLoadException, NamingException, SQLException 
	{
		InputStreamDownloader isd = getInputStreamDownloaderMultimediaFile(this.lId, conn);
		File fileTmp = File.createTempFile("multimedia_", this.getFileName()); 
		FileUtil.convertInputStreamInFile(isd.is, fileTmp);
		isd.close();
		return fileTmp;
	}

	public InputStreamDownloader getInputStreamDownloaderMultimediaFile(Connection conn) 
	throws CoinDatabaseLoadException, NamingException, SQLException 
	{
		return getInputStreamDownloaderMultimediaFile(this.lId, conn);
	}
	
	public static InputStream getInputStreamMultimediaFile(long lIdMultimedia) 
	throws CoinDatabaseLoadException, NamingException, SQLException 
	{
		Multimedia item = new Multimedia();
		Connection conn = item.getConnection();
		try {
			return getInputStreamMultimediaFile(lIdMultimedia, conn);
		} finally{
			item.releaseConnection(conn);	
		}
	}

	public static InputStream getInputStreamMultimediaFile(
			long lIdMultimedia, 
			Connection conn) 
	throws NamingException, CoinDatabaseLoadException, SQLException {
		Multimedia item = new Multimedia();
		String sSqlQuery = "SELECT multimedia_file " 
			+ " FROM " + item.TABLE_NAME
			+ " WHERE " + item.FIELD_ID_NAME +"=" + lIdMultimedia;

		return ConnectionManager.downloadInputStream(sSqlQuery, conn);
	}
	
	public static InputStreamDownloader getInputStreamDownloaderMultimediaFile(
			long lIdMultimedia, 
			Connection conn) 
	throws NamingException, CoinDatabaseLoadException, SQLException {
		Multimedia item = new Multimedia();
		String sSqlQuery = "SELECT multimedia_file " 
			+ " FROM " + item.TABLE_NAME
			+ " WHERE " + item.FIELD_ID_NAME +"=" + lIdMultimedia;
		return ConnectionManager.getInputStreamDownloader(sSqlQuery, conn);
	}
	
	public static byte[] getMultimediaFileBytes(
			int iIdMultimediaType,
			long lIdReferenceObjet,
			int iIdTypeObjet, 
			Connection conn) 
	throws NamingException, CoinDatabaseLoadException, SQLException {
		Multimedia item = new Multimedia();
		String sSqlQuery = "SELECT multimedia_file " 
			+ " FROM " + item.TABLE_NAME
			+ " WHERE " + item.TABLE_NAME +".id_coin_multimedia_type=" + iIdMultimediaType
			+ " AND "+ item.TABLE_NAME +".id_reference_objet=" +lIdReferenceObjet
			+ " AND "+ item.TABLE_NAME +".id_type_objet=" + iIdTypeObjet;
		return ConnectionManager.getBytesValueFromSqlQuery(sSqlQuery, conn);
	}
	
	public static byte[] getMultimediaFileBytes(
			long lIdMultimedia, 
			Connection conn) 
	throws NamingException, CoinDatabaseLoadException, SQLException {
		Multimedia item = new Multimedia();
		String sSqlQuery = "SELECT multimedia_file " 
			+ " FROM " + item.TABLE_NAME
			+ " WHERE " + item.FIELD_ID_NAME +"=" + lIdMultimedia;
		return ConnectionManager.getBytesValueFromSqlQuery(sSqlQuery, conn);
	}

	public static Vector<Multimedia>  getAllMultimedias() 
	throws NamingException, SQLException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException {
		return getMultimediasWithWhereClause("");
	}

	public static Vector<Multimedia> getMultimediasWithWhereClause(String sWhereClause)
	throws NamingException, SQLException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException {
		Multimedia item = new Multimedia();

		return item.getAllWithWhereAndOrderByClause(sWhereClause, "");
	}

	public static Vector<Multimedia> getAllStatic(Connection conn)
	throws InstantiationException, IllegalAccessException, NamingException, SQLException {
		Multimedia item = new Multimedia();
		return item.getAll(conn);
	}

	public void storeMultimediaFile() 
	throws CoinDatabaseLoadException, NamingException, SQLException 
	{
		Multimedia item = new Multimedia();
		Connection conn = item.getConnection();
		try {
			storeMultimediaFile(conn);
		} finally{
			item.releaseConnection(conn);	
		}
	}



	public void storeMultimediaFile(Connection conn) throws NamingException, SQLException {
		String sSqlQuery = "UPDATE " + TABLE_NAME + " SET "
		+ " multimedia_file=? "
		+ " WHERE " + FIELD_ID_NAME + "=" 
		+ this.lId;

		ConnectionManager.uploadInputStream(sSqlQuery,  this.isMultimediaFile, conn);

	}
	/**
	 * @return Returns the sFileName.
	 */
	public String getFileName() {
		return this.sFileName;
	}
	/**
	 * @param fileName The sFileName to set.
	 */
	public void setFileName(String fileName) {
		this.sFileName = fileName;
	}

	public void isPhysique(boolean bIsPhysique){
		this.bIsPhysique = bIsPhysique;
	}

	public boolean isPhysique(){
		return this.bIsPhysique;
	}
	@Override
	public String getName() {
		return "multimedia_" + this.sFileName;
	}

	public void setFromForm(HttpServletRequest request, String sFormPrefix) throws SQLException, NamingException {
		// TODO Auto-generated method stub

	}
	public void setFromResultSet(ResultSet rs) throws SQLException {
		this.iIdMultimediaType = rs.getInt(1);
		this.iIdTypeObjet = rs.getInt(2);
		this.sContentType = preventLoad(rs.getString(3));
		this.iIdReferenceObjet = rs.getInt(4);
		this.tsDateCreation = rs.getTimestamp(5);
		this.tsDateModification = rs.getTimestamp(6);
		this.sReference = preventLoad(rs.getString(7));
		this.sLibelle = preventLoad(rs.getString(8));
		this.sFileName = preventLoad(rs.getString(9));
		this.sPathFile = preventLoad(rs.getString(10));
		this.bIsPhysique = rs.getBoolean(11);

	}
	public void setPreparedStatement(PreparedStatement ps) throws SQLException {
		ps.setInt(1, this.iIdMultimediaType);
		ps.setInt(2, this.iIdTypeObjet);
		ps.setString(3, preventStore(this.sContentType));
		ps.setInt(4, this.iIdReferenceObjet);
		ps.setTimestamp(5, this.tsDateCreation);
		ps.setTimestamp(6, this.tsDateModification);
		ps.setString(7, preventStore(this.sReference));
		ps.setString(8, preventStore(this.sLibelle));
		ps.setString(9, preventStore(this.sFileName));
		ps.setString(10, preventStore(this.sPathFile));
		ps.setBoolean(11, this.bIsPhysique);
	}

    public String getIdMultimediaTypeLabel() {
		return getLocalizedLabel("iIdMultimediaType");
	}
    
    public String getIdTypeObjetLabel() {
		return getLocalizedLabel("iIdTypeObjet");
	}
    
    public String getFileNameLabel() {
		return getLocalizedLabel("sFileName");
	}
    
    public String getNameLabel() {
		return getLocalizedLabel("sLibelle");
	}
    
    public String getContentTypeLabel() {
		return getLocalizedLabel("sContentType");
	}
    
    public String getIsPhysiqueLabel() {
		return getLocalizedLabel("bIsPhysique");
	}
	
	public String getLocalizedLabel(String sFieldName) {
		s_sarrLocalizationLabel = getLocalizationLabel(s_sarrLocalizationLabel);
		return s_sarrLocalizationLabel[this.iAbstractBeanIdLanguage].get(sFieldName);
	}
	
    public void updateLocalization(Connection conn)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException
	{
    	s_sarrLocalizationLabel = getLocalizationLabel(s_sarrLocalizationLabel, true);
	}
    
    public MultimediaParameter getParameter (String sName, Connection connection)
    throws CoinDatabaseLoadException, NamingException, SQLException, InstantiationException, IllegalAccessException
    {
    	return MultimediaParameter.getMultimediaParameter(this, sName, connection);
    }
    
    public String getParameterValue (String sName, Connection connection)
    throws CoinDatabaseLoadException, NamingException, SQLException, InstantiationException, IllegalAccessException
    {
    	return MultimediaParameter.getMultimediaParameterValue(this, sName, connection);
    }
    
    public String getParameterValueOptional (String sName, Connection connection, String defaultValue)
    throws NamingException, SQLException, InstantiationException, IllegalAccessException{
    	return MultimediaParameter.getMultimediaParameterValueOptional(this, sName, connection, defaultValue);
    }
    
    public String getParameterValueOptional (String sName, Connection connection)
    throws NamingException, SQLException, InstantiationException, IllegalAccessException
    {
    	return MultimediaParameter.getMultimediaParameterValueOptional (this, sName, connection);
    }
    
    public int getParameterValueOptionalInt(String sName, int iDefaultValue, Connection connection)
	{
    	return MultimediaParameter.getMultimediaParameterValueOptionalInt(this, sName, iDefaultValue, connection);
	}
    
    public void updateParameterValue (String sName, String sValue, Connection connection)
    throws CoinDatabaseStoreException, CoinDatabaseCreateException, CoinDatabaseDuplicateException,
    CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException
    {
    	MultimediaParameter.updateValue(this, sName, sValue, connection);
    }
}
