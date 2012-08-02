/*
 * Created on 4 nov. 2004
 *
 */
package org.coin.fr.bean;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.Collections;
import java.util.Vector;

import javax.naming.NamingException;

import org.coin.bean.ObjectType;
import org.coin.bean.conf.Configuration;
import org.coin.db.CoinDatabaseAbstractBeanComparator;
import org.coin.db.CoinDatabaseLoadException;
import org.coin.db.CoinDatabaseWhereClause;
import org.coin.db.ObjectLocalization;
import org.coin.util.Enumerator;
import org.coin.util.Outils;
import org.json.JSONException;
import org.json.JSONObject;

public class MultimediaType extends Enumerator {

	private static final long serialVersionUID = 1L;
	
	public static final int TYPE_LOGO = 1;
	public static final int TYPE_CSS = 3;
	public static final int TYPE_XSL = 4;
	public static final int TYPE_XSL_GENERER_PDF_AAPC = 5;
	public static final int TYPE_XSL_GENERER_PDF_AATR = 6;
	public static final int TYPE_XSL_GENERER_PDF_AR_AAPC = 7;
	public static final int TYPE_XSL_GENERER_PDF_AR_AATR= 8;
	public static final int TYPE_XSL_GENERER_PDF_ANNUL = 9;
	public static final int TYPE_XSL_GENERER_QUARK_AAPC = 10;
	public static final int TYPE_XSL_GENERER_QUARK_AATR = 11;
	public static final int TYPE_XSL_GENERER_QUARK_AR_AAPC = 12;
	public static final int TYPE_XSL_GENERER_QUARK_AR_AATR= 13;
	public static final int TYPE_XSL_GENERER_QUARK_ANNUL = 14;
	public static final int TYPE_XSL_FORMULAIRE_AAPC = 15;
	public static final int TYPE_XSL_FORMULAIRE_AATR = 16;
	public static final int TYPE_XSL_FORMULAIRE_AR_AAPC = 17;
	public static final int TYPE_XSL_FORMULAIRE_AR_AATR= 18;
	public static final int TYPE_XSL_FORMULAIRE_ANNUL = 19;
	public static final int TYPE_BANDEAU = 20;
	public static final int TYPE_TEXT_HOME_PAGE = 21;
	public static final int TYPE_PRICE_OFFER_LIST_TEMPLATE = 22;
	public static final int TYPE_PLANIFICATION_FILE_TEMPLATE = 23;
	public static final int TYPE_DELIVERY_LIST_TEMPLATE = 24;
	public static final int TYPE_MIGRATION_LIST_TEMPLATE = 25;
	public static final int TYPE_SITE_MAIN_PAGE = 26;
	public static final int TYPE_SITE_PUBLISHER_PAGE = 27;
	public static final int TYPE_CERTIFICATE_LIST_TEMPLATE = 28;
	public static final int TYPE_TEMPLATE_AVIS_RECAPITULATIF = 29;
	public static final int TYPE_XSL_GENERER_PDF_MAIL_TYPE = 30;
	public static final int TYPE_CONTRACT_LIST_TEMPLATE = 31;
	public static final int TYPE_TRAIN_LIFE_CYCLE_DATA = 32;
	public static final int TYPE_PICTURE_ONE = 33;
	public static final int TYPE_PICTURE_TWO = 34;
	public static final int TYPE_VEHICLE_DIAGRAM = 35;
	public static final int TYPE_VEHICLE_DOC_DRIVER = 36;
	public static final int TYPE_VEHICLE_DOC_MAINTENANCE = 37;
	public static final int TYPE_VEHICLE_DOC_SCHEDULE_MAINTENANCE = 38;
	public static final int TYPE_SCANNED_SIGNATURE = 100;
	public static final int TYPE_DOCUMENT_HEADER = 101;
	public static final int TYPE_DOCUMENT_FOOTER = 102;
	public static final int TYPE_DOCUMENT_OVERLAY_DRAFT_PORTAIT = 103;
	public static final int TYPE_DOCUMENT_OVERLAY_DRAFT_LANDSCAPE = 104;
	public static final int TYPE_DOCUMENT_FONT = 105;
	public static final int TYPE_SCANNED_VISA = 106;
	public static final int TYPE_SCANNED_PARAPH = 107;
	public static final int TYPE_SSVP_TRANSFORMATION = 108;
	public static final int TYPE_TEST_FILE_PDF = 109;
	public static final int TYPE_MAIL_TEMPLATE_HTML = 110;
	public static final int TYPE_DATABASE_SCHEME = 111;
	public static final int TYPE_JAVA_KEY_STORE = 112;
	public static final int TYPE_PKCS12 = 113;

	public static final int TYPE_GED_DEFAULT_DOCUMENT_ICON = 200;

	public static final int TYPE_PARAPH_XSL_REPORT = 300;
	public static final int TYPE_PARAPH_REPORT_LOGO = 301;
	public static final int TYPE_ADDRESS_BOOK_TEMPLATE = 302;
	
	public static final int TYPE_XSL_FORMULAIRE_JOUE1 = 400;

	public static final int TYPE_USER_BACKGROUND_IMAGE = 1000;
	
	public static final int TYPE_TRAIN_LIFE_CYCLE_STAT = 500;

	protected static String[][] s_sarrLocalization;


	public void setConstantes() {
		super.TABLE_NAME = "coin_multimedia_type";
        super.FIELD_ID_NAME  = "id_coin_multimedia_type";
        super.FIELD_NAME_NAME = "name";
        super.SELECT_FIELDS_NAME = super.FIELD_NAME_NAME;
        super.SELECT_FIELDS_NAME_SIZE = 1;
        this.iAbstractBeanIdObjectType = ObjectType.MULTIMEDIA_TYPE;
	}
	/**
	 * 
	 */
	public MultimediaType() {
		super();
		setConstantes();
	}

	/**
	 * @param iId
	 * @param sName
	 */
	public MultimediaType(int iId, String sName) {
		super(iId, sName);
		setConstantes();
	}

	/**
	 * @param iId
	 */
	public MultimediaType(int iId) {
		super(iId);
		setConstantes();
	}

	/**
	 * @param sName
	 */
	public MultimediaType(String sName) {
		super(sName);
		setConstantes();
	}

    public MultimediaType(int iId, String sName,boolean bUseHttpPrevent) {
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
		return new MultimediaType(iId, sName,bUseHttpPrevent);
	}

	public static String getMultimediaTypeName(int iId)
	throws CoinDatabaseLoadException, SQLException, NamingException 
	{
    	MultimediaType item = new MultimediaType(iId);
    	item.load();
    	return item.getName();
    }

	public static String getMultimediaTypeName(
			int iId, 
			boolean bUseHttpPrevent ,
			Connection conn)
	throws CoinDatabaseLoadException, SQLException, NamingException 
	{
    	MultimediaType item = new MultimediaType(iId);
    	item.bUseHttpPrevent = bUseHttpPrevent ;
    	item.load(conn);
    	return item.getName();
    }

	public static MultimediaType getMultimediaType(int iId) throws Exception {
    	MultimediaType item = new MultimediaType(iId);
    	item.load();
    	return item;
    }
	public static Vector<MultimediaType> getAllMultimediaType() throws SQLException, NamingException
	{
    	MultimediaType item = new MultimediaType();
		return item.getAllOrderById();
	}
	
	public static Vector<MultimediaType> getAllMultimediaTypeWithServerFilter(boolean bUseLocalization, long lIdLanguage, int iIdObjectType) throws SQLException, NamingException, InstantiationException, IllegalAccessException
	{
    	MultimediaType item = new MultimediaType();
    	if(bUseLocalization) item.setAbstractBeanLocalization(lIdLanguage);
    	Vector<MultimediaType> vReturn = new Vector<MultimediaType>();
    	
    	String sFilterIdType = Configuration.getConfigurationValueMemory("multimedia.type.filter.object."+iIdObjectType,"");
    	String sWhereClause = "";
    	if(!Outils.isNullOrBlank(sFilterIdType)){
    		CoinDatabaseWhereClause cw = new CoinDatabaseWhereClause(CoinDatabaseWhereClause.ITEM_TYPE_INTEGER);
    		cw.addArray(sFilterIdType,";");
    		sWhereClause = "WHERE "+cw.generateWhereClause(item.FIELD_ID_NAME);
    		vReturn = item.getAllWithWhereAndOrderByClause(sWhereClause, "");
    	}else{
    		vReturn = item.getAllOrderById();
    	}
    	
    	if(bUseLocalization)
		{
			Collections.sort( vReturn , new CoinDatabaseAbstractBeanComparator(CoinDatabaseAbstractBeanComparator.ORDERBY_LEXICOGRAPHIC_NAME_ASCENDING));
		}
    	
    	return vReturn;
		
	}
	
	public String getLocalizedName(Connection conn) {
    	s_sarrLocalization = getLocalizationMatrixOptional(s_sarrLocalization, conn);
		return s_sarrLocalization[this.iAbstractBeanIdLanguage][(int)this.lId];
    }
    public void updateLocalization(Connection conn)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException
	{
    	s_sarrLocalization =  ObjectLocalization.generateLocalizationMatrix(this, conn);
	}
    public String getName() {
    	if(this.bUseLocalization)
    	{
    		String s = getLocalizedName(!(s_sarrLocalization==null));
    		if(s == null) return this.sName;
    		return s;
    	}
        return this.sName;
    }
    public JSONObject toJSONObject() throws JSONException {
		JSONObject item = new JSONObject();
		item.put("lId", this.lId);
		item.put("sName", this.getName());
		
		item.put("data", this.lId);
		item.put("value", this.getName());
		
		return item;
	}
 }
