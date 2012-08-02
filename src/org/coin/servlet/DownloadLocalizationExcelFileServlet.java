package org.coin.servlet;

import java.io.*;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.naming.NamingException;
import javax.servlet.http.*;


import mt.modula.batch.RemoteControlServiceConnection;

import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.poifs.filesystem.POIFSFileSystem;
import org.coin.bean.ObjectType;
import org.coin.db.CoinDatabaseAbstractBean;
import org.coin.db.CoinDatabaseLoadException;
import org.coin.db.ConnectionManager;
import org.coin.db.ObjectAttributeLocalization;
import org.coin.db.ObjectLocalization;
import org.coin.localization.CaptionCategory;
import org.coin.localization.CaptionValue;
import org.coin.localization.Language;
import org.coin.localization.Localize;
import org.coin.util.HttpUtil;
import org.coin.util.excel.PoiExcelUtil;


public class DownloadLocalizationExcelFileServlet  extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	public String sFilename = "";
	public Vector<Language> vLanguageSelected ;
	public int iPrimaryKeyType ;
	public ObjectType objType ;
	public String sLocalizationType;
	public static final int MAX_ROW_CHECKED = 4000;
	
	protected void doGet(
			HttpServletRequest request,
			HttpServletResponse response) {


		String sDisposition = HttpUtil.parseString("sContentDisposition", request, "attachement" ) + ";";
		String sAction = HttpUtil.parseStringBlank("sAction", request);
		this.sLocalizationType = HttpUtil.parseStringBlank("sLocalizationType", request);
		
		
		Vector<Language> vLanguage;
		this.vLanguageSelected = new Vector<Language> ();
		try {
			vLanguage = Language.getAllStaticMemory();
			for(Language l : vLanguage)
			{
				if(request.getParameter( "language_" + l.getId()) != null)
				{
					this.vLanguageSelected.add(l);
				}
			}
		} catch (Exception e2) {
			e2.printStackTrace();
		}
		
		
		if(sAction.equalsIgnoreCase("view"))
			sDisposition = " ; ";

		
		
		
		String sContentType = "application/x-excel";
		String sContentLength ="";
		

		Connection conn = null;
		try {
			conn = ConnectionManager.getConnection();
			
			HSSFWorkbook wb = null;
			
			if (this.sLocalizationType.equals("caption")) {
				wb = prepareExcelFileCaptionLocalization(request);
			} else if (this.sLocalizationType.equals("object")) {
				wb = prepareExcelFileObjectLocalization(request);
			} else if (this.sLocalizationType.equals("object_attribute")) {
				wb = prepareExcelFileObjectAttributeLocalization(request);
			} else if (this.sLocalizationType.equals("object_method")) {
				wb = prepareExcelFileObjectMethodLocalization(request);
			}
			
			
			response.setContentType(sContentType);
			this.sFilename ="localization_" + this.sFilename + "_" + System.currentTimeMillis() + ".xls";

			response.setHeader("Content-Disposition", sDisposition+" filename=\"" + this.sFilename+"\"");
			
			if(sContentLength != null && !sContentLength.equalsIgnoreCase(""))
				response.addHeader("length-file",sContentLength);
			
			OutputStream out = response.getOutputStream();

			wb.write(out);
			out.close();
			
		} catch (Exception e) {
			e.printStackTrace();
			try {
				OutputStream outError = response.getOutputStream();
				outError.write(e.getMessage().getBytes());
				outError.flush();
			} catch (IOException e1) {
				e1.printStackTrace();
			}
		} finally {
			try {
				ConnectionManager.closeConnection(conn);
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}
	
	public static void testLocalizeCaption(
			InputStream is,
			Connection conn)
	throws FileNotFoundException, IOException, CoinDatabaseLoadException, NamingException, SQLException, InstantiationException, IllegalAccessException 
	{
		POIFSFileSystem fs = new 
		POIFSFileSystem(is);

		HSSFWorkbook wb = new HSSFWorkbook(fs); 
		
		Vector<CaptionValue> vCaptionValue = getAllCaptionValueFromWorkbook(wb, conn);
	
		for (CaptionValue captionValue : vCaptionValue) {
			System.out.println("value : " + captionValue .getValue());
		}

		// important pour initialser les valeurs
		new Localize(conn);
		String[][][] lm = prepareLocalizedMatrix(wb, conn);

		Localize.displayMatrixOnConsole(conn, lm);
		
	}

	public static void testLocalizeObject(
			InputStream is,
			Connection conn)
	throws FileNotFoundException, IOException, CoinDatabaseLoadException, NamingException, 
	SQLException, InstantiationException, IllegalAccessException, IllegalArgumentException, 
	SecurityException, ClassNotFoundException, InvocationTargetException, NoSuchMethodException 
	{
		POIFSFileSystem fs = new 
		POIFSFileSystem(is);
		ObjectLocalization[][] arrOL = null;
		Map<String, ObjectLocalization>[] mapOL = null;
		
		HSSFWorkbook wb = new HSSFWorkbook(fs); 
		ObjectType objType = ObjectType.getObjectType(getIdTypeObjectFromWorkbook(wb), false, conn);
		
		int iPrimaryKeyType = (Integer)objType.invokeObjectInstanceMethod("getPrimaryKeyType");
		System.out.println("iPrimaryKeyType=" + iPrimaryKeyType);

		switch(iPrimaryKeyType)
		{
		case CoinDatabaseAbstractBean.PRIMARY_KEY_TYPE_LONG:
			//arrOL = ObjectLocalization.generateObjectLocalization(lIdTypeObject, conn);
			arrOL = prepareObjectLocalization(wb, objType, conn);
			break;
			
		case CoinDatabaseAbstractBean.PRIMARY_KEY_TYPE_STRING:
			//mapOL = ObjectLocalization.generateObjectLocalizationString(lIdTypeObject, conn);
			mapOL = prepareObjectLocalizationString(wb, objType, conn);
			break;
			
		}
		
		
	}
	
	public static void main(String[] args)
	throws FileNotFoundException, IOException, CoinDatabaseLoadException, NamingException,
	SQLException, InstantiationException, IllegalAccessException, IllegalArgumentException,
	SecurityException, ClassNotFoundException, InvocationTargetException, NoSuchMethodException 
	{
		RemoteControlServiceConnection a = new RemoteControlServiceConnection("jdbc:mysql://serveur8.matamore.com:3306/veolia_dev?","dba_account", "dba_account" );
		Connection conn = a.getConnexionMySQL();

		//testLocalizeCaption(new FileInputStream("c:\\local.xls"), conn);
		testLocalizeObject(new FileInputStream("c:\\localization_Pays.xls"), conn);
		
		
		ConnectionManager.closeConnection(conn);
		
	}
	public static Vector<Language>  getAllLanguageSelectedFromWorkbook(
			HSSFWorkbook wb,
			Connection conn)
	throws InstantiationException, IllegalAccessException, NamingException, SQLException
	{
		HSSFSheet sheet = wb.getSheetAt(0);
		Vector<Language> vLanguage = Language.getAllStatic(conn);;
		Vector<Language> vLanguageSelected = new Vector<Language> ();
		for(Language l : vLanguage)
		{
			for(int iLang = 1; iLang < 20 ; iLang++)
			{
				String sLang = PoiExcelUtil.getExcelCellValueOptional(3, iLang, sheet).trim();
				if( l.getShortLabel().equals(sLang)) 
				{
					vLanguageSelected.add(l);
					break;
				}
			}
		}
		
		return vLanguageSelected;
	}
	
	public static int getIdCaptionCategoryFromWorkbook(
			HSSFWorkbook wb)
	{
		HSSFSheet sheet = wb.getSheetAt(0);
		int lIdCaptionCategory 
			= Integer.parseInt(
					PoiExcelUtil.getExcelCellValueOptional(0, 1, sheet).trim());
		
		return lIdCaptionCategory;
	}
	
	public static int getIdTypeObjectFromWorkbook(
			HSSFWorkbook wb)
	{
		HSSFSheet sheet = wb.getSheetAt(0);
		int lIdCaptionCategory 
			= Integer.parseInt(
					PoiExcelUtil.getExcelCellValueOptional(0, 1, sheet).trim());
		
		return lIdCaptionCategory;
	}
	
	public static Vector<ObjectAttributeLocalization> getAllObjectAttributeLocalization(
			HSSFWorkbook wb,
			ObjectType objType,
			Connection conn)
	throws IllegalArgumentException, SecurityException, ClassNotFoundException, IllegalAccessException,
	InvocationTargetException, NoSuchMethodException, InstantiationException, NamingException, SQLException 
	{
		Vector<ObjectAttributeLocalization> vOLA = new Vector<ObjectAttributeLocalization>();
		HSSFSheet sheet = wb.getSheetAt(0);
		int [] iarrLangIndex = new int[20];
		
		Vector<Language> vLanguageSelected = getAllLanguageSelectedFromWorkbook(sheet, iarrLangIndex, conn);
		
		for (int i = 4; i < MAX_ROW_CHECKED; i++) {
			String sAttributeName = PoiExcelUtil.getExcelCellValueOptional(
					i, 
					0,
					sheet).trim();
			
			if(sAttributeName.equals("")) break;
			
			for (Language lang : vLanguageSelected) {
				String sValue 
					= PoiExcelUtil.getExcelCellValueOptional(
						i, 
						iarrLangIndex[(int)lang.getId()],
						sheet).trim();
				
				

				ObjectAttributeLocalization ola = new ObjectAttributeLocalization();
				ola.setAttributeName(sAttributeName);
				ola.setAttributeLabel(sValue);
				ola.setIdLanguage(lang.getId());
				ola.setIdTypeObject(objType.getId());
				
				
				vOLA.add(ola);
			}
		}
		
		return vOLA;
	}
	
	
	public static Vector<ObjectLocalization> getAllObjectLocalization(
			HSSFWorkbook wb,
			ObjectType objType,
			Connection conn)
	throws IllegalArgumentException, SecurityException, ClassNotFoundException, IllegalAccessException,
	InvocationTargetException, NoSuchMethodException, InstantiationException, NamingException, SQLException 
	{
		Vector<ObjectLocalization> vOL = new Vector<ObjectLocalization>();
		HSSFSheet sheet = wb.getSheetAt(0);
		int [] iarrLangIndex = new int[20];
		int iPrimaryKeyType = (Integer)objType.invokeObjectInstanceMethod("getPrimaryKeyType");
		
		Vector<Language> vLanguageSelected = getAllLanguageSelectedFromWorkbook(sheet, iarrLangIndex, conn);
		
		for (int i = 4; i < MAX_ROW_CHECKED; i++) {
			String sPKValue = PoiExcelUtil.getExcelCellValueOptional(
					i, 
					0,
					sheet).trim();
			
			if(sPKValue.equals("")) break;
			
			for (Language lang : vLanguageSelected) {
				String sValue 
					= PoiExcelUtil.getExcelCellValueOptional(
						i, 
						iarrLangIndex[(int)lang.getId()],
						sheet).trim();
				
				ObjectLocalization ol = new ObjectLocalization();
				ol.setValue(sValue);
				ol.setIdLanguage(lang.getId());
				ol.setIdTypeObject(objType.getId());
				
				switch(iPrimaryKeyType)
				{
				case CoinDatabaseAbstractBean.PRIMARY_KEY_TYPE_LONG:
					ol.setIdReferenceObject(Long.parseLong( sPKValue));
					break;
					
				case CoinDatabaseAbstractBean.PRIMARY_KEY_TYPE_STRING:
					ol.setIdReferenceObjectString(sPKValue);
					break;
					
				}
				
				vOL.add(ol);
			}
		}
		
		return vOL;
	}
	
	

	@SuppressWarnings("unchecked")
	public static Map<String, String>[] prepareAttributeLocalizationMatrixString(
			HSSFWorkbook wb,
			ObjectType objType,
			Connection conn) 
		throws InstantiationException, IllegalAccessException, NamingException, SQLException,
		IllegalArgumentException, SecurityException, ClassNotFoundException, InvocationTargetException,
		NoSuchMethodException 
	{

		Vector<Language> vLanguage = Language.getAllStatic(conn);

		int iMaxLanguage = 0;

		for (Language item : vLanguage) {
			if(item.getId() > iMaxLanguage )
				iMaxLanguage = (int)item.getId() ;
		}

		Vector<ObjectAttributeLocalization> vItem  = getAllObjectAttributeLocalization(wb, objType, conn);


		/**
		 * Create the matrix
		 */
		Map<String, String>[] matrix  
		= new Map [iMaxLanguage + 1];

		for (Language lang : vLanguage) {
			matrix[(int)lang.getId()]
			       = Collections.synchronizedMap(new HashMap<String, String>());
		}

		/**
		 * Populate the matrix
		 */
		for (ObjectAttributeLocalization item : vItem) {
			matrix[(int)item.getIdLanguage()]
			       .put(item.getAttributeName(), item.getAttributeLabel());
		}

		return matrix;
	}
	
    @SuppressWarnings("unchecked")
	public static Map<String, ObjectLocalization>[] prepareObjectLocalizationString(
			HSSFWorkbook wb,
			ObjectType objType,
			Connection conn) 
	throws InstantiationException, IllegalAccessException, NamingException, SQLException, 
	IllegalArgumentException, SecurityException, ClassNotFoundException, InvocationTargetException,
	NoSuchMethodException 
	{
		
		Vector<Language> vLanguage = Language.getAllStatic(conn);
		
		int iMaxLanguage = 0;
		
		for (Language item : vLanguage) {
			if(item.getId() > iMaxLanguage )
				iMaxLanguage = (int)item.getId() ;
		}
		
		Vector<ObjectLocalization> vItem 
			= getAllObjectLocalization(wb, objType, conn);
		
		
		/**
		 * Create the matrix
		 */
		Map<String, ObjectLocalization>[] matrix  
			= new Map [iMaxLanguage + 1];
		
		for (Language lang : vLanguage) {
			matrix[(int)lang.getId()]
				= Collections.synchronizedMap(new HashMap<String, ObjectLocalization>());
		}

		/**
		 * Populate the matrix
		 */
		for (ObjectLocalization item : vItem) {
			matrix[(int)item.getIdLanguage()]
				.put(item.getIdReferenceObjectString(), item);
			
			System.out.println("" + item.getIdLanguage() 
					+ " " + item.getIdReferenceObjectString()
					+ " = " + item.getValue()
					);
		}
		
		return matrix;
	}
	
	
	
	public static ObjectLocalization[][] prepareObjectLocalization(
			HSSFWorkbook wb,
			ObjectType objType,
			Connection conn) 
	throws InstantiationException, IllegalAccessException, NamingException, SQLException,
	IllegalArgumentException, SecurityException, ClassNotFoundException, InvocationTargetException,
	NoSuchMethodException 
	{
		Vector<Language> vLanguage = Language.getAllStatic(conn);
		
		int iMaxLanguage = 0;
		
		for (Language item : vLanguage) {
			if(item.getId() > iMaxLanguage )
				iMaxLanguage = (int)item.getId() ;
		}
		
		Vector<ObjectLocalization> vItem 
			= getAllObjectLocalization(wb, objType, conn);
		
		int iMaxIndex = 0;
		
		for (ObjectLocalization item : vItem) {
			if(item.getIdReferenceObject() > iMaxIndex )
				iMaxIndex = (int)item.getIdReferenceObject() ;
		}

		/**
		 * Create the matrix
		 */
		ObjectLocalization[][] matrix  
			= new ObjectLocalization
				 [iMaxLanguage + 1]
				 [iMaxIndex + 1];
		

		/**
		 * Populate the matrix
		 */
		for (ObjectLocalization item : vItem) {
			matrix
				[(int)item.getIdLanguage()]
				[(int)item.getIdReferenceObject()] = item;
			
			System.out.println("" + item.getIdLanguage() 
					+ " " + item.getIdReferenceObject()
					+ " = " + item.getValue()
					);
			
		}
		
		return matrix;
		
	}
	
	
	
	public static Vector<Language>  getAllLanguageSelectedFromWorkbook(
			HSSFSheet sheet ,
			int [] iarrLangIndex,
			Connection conn)
	throws InstantiationException, IllegalAccessException, NamingException, SQLException
	{
		Vector<Language> vLanguage = Language.getAllStatic(conn);
		Vector<Language> vLanguageSelected = new Vector<Language> ();
				
		vLanguage = Language.getAllStatic(conn);
		for(Language l : vLanguage)
		{
			for(int iLang = 1; iLang < 20 ; iLang++)
			{
				String sLang = PoiExcelUtil.getExcelCellValueOptional(3, iLang, sheet).trim();
				if( l.getShortLabel().equals(sLang)) 
				{
					vLanguageSelected.add(l);
					iarrLangIndex[(int)l.getId()] = iLang;
					break;
				}
			}
		}
		return vLanguageSelected;
	}	
	
	public static Vector<CaptionValue>  getAllCaptionValueFromWorkbook(
			HSSFWorkbook wb,
			Connection conn)
	throws CoinDatabaseLoadException, NamingException, SQLException, InstantiationException, IllegalAccessException
	{
		Vector<CaptionValue> vCaptionValue = new Vector<CaptionValue>();
		HSSFSheet sheet = wb.getSheetAt(0);
		
		int lIdCaptionCategory = getIdCaptionCategoryFromWorkbook(wb);
		int [] iarrLangIndex = new int[20];
		
		Vector<Language> vLanguageSelected = getAllLanguageSelectedFromWorkbook(sheet, iarrLangIndex, conn);
	
		for (int i = 4; i < MAX_ROW_CHECKED; i++) {
			int iIndex = -1;
			try {
				iIndex = Integer.parseInt(
					PoiExcelUtil.getExcelCellValueOptional(
							i, 
							0,
							sheet).trim());
			} catch (Exception e) {
				break;
			}
			
			for (Language lang : vLanguageSelected) {
				String sValue 
					= PoiExcelUtil.getExcelCellValueOptional(
						i, 
						iarrLangIndex[(int)lang.getId()],
						sheet).trim();
				
				CaptionValue captionValue = new CaptionValue();
				captionValue.setValue(sValue);
				captionValue.setIndexValue(iIndex);
				captionValue.setIdLanguage(lang.getId());
				captionValue.setIdCaptionCategory(lIdCaptionCategory);
				vCaptionValue.add(captionValue);
			}
		}
		
		return vCaptionValue;
	}

	public static String[][][] prepareLocalizedMatrix(
			HSSFWorkbook wb,
			Connection conn) 
	throws CoinDatabaseLoadException, NamingException, SQLException, InstantiationException, IllegalAccessException 
	{
		Vector<CaptionValue> vCaptionValue = getAllCaptionValueFromWorkbook(wb, conn);
		return prepareLocalizedMatrix(wb, vCaptionValue, conn);
	}
	
	
	public static String[][][] prepareLocalizedMatrix(
			HSSFWorkbook wb,
			Vector<CaptionValue> vCaptionValue,
			Connection conn) 
	throws CoinDatabaseLoadException, NamingException, SQLException, InstantiationException, IllegalAccessException
	{
		Logger logger = Logger.getLogger(DownloadLocalizationExcelFileServlet.class.getName());
		logger.setLevel(Level.WARNING);
		
		String LOCALIZED_MATRIX[][][];
		int MAX_CAPTION_VALUE_INDEX = 0;

		
		for (CaptionValue captionValue : vCaptionValue) {
			logger.log(Level.INFO,"captionValue:"+captionValue.getValue());
			if(captionValue.iIndexValue > MAX_CAPTION_VALUE_INDEX )
				MAX_CAPTION_VALUE_INDEX = captionValue.iIndexValue ;
		}
		logger.log(Level.INFO,"MAX_CAPTION_VALUE_INDEX:"+MAX_CAPTION_VALUE_INDEX);
		/**
		 * Create the matrix
		 */
		LOCALIZED_MATRIX 
			= new String
			 [Localize.COUNT_LANGUAGE + 1]
			 [Localize.COUNT_CAPTION_CATEGORY + 1]
			 [MAX_CAPTION_VALUE_INDEX + 1 ];
		

		/**
		 * Populate the matrix
		 */
		for (CaptionValue captionValue : vCaptionValue) {
			
			LOCALIZED_MATRIX
				[(int)captionValue.lIdLanguage]
				[(int)captionValue.lIdCaptionCategory]
				[captionValue.iIndexValue] = captionValue.sValue;
		}
		
		return LOCALIZED_MATRIX;
	}

	protected HSSFWorkbook prepareExcelFileCaptionLocalization(
			HttpServletRequest request)
	throws CoinDatabaseLoadException, NamingException, SQLException 
	{
		HSSFWorkbook wb = new HSSFWorkbook();
		HSSFSheet sheet;
		sheet = wb.createSheet();
		wb.setSheetName(0, "Localization");
		long lIdCaptionCategory = HttpUtil.parseLong("lIdCaptionCategory", request);
		CaptionCategory cc = CaptionCategory.getCaptionCategory(lIdCaptionCategory);
		
		PoiExcelUtil.setCellValue( sheet, 0, 0, "Caption Category :");
		PoiExcelUtil.setCellValue( sheet, 0, 1, ""+cc.getId());
		PoiExcelUtil.setCellValue( sheet, 0, 2, cc.getName());
		PoiExcelUtil.setCellValue( sheet, 1, 0, "Localization type : ");
		PoiExcelUtil.setCellValue( sheet, 1, 1, this.sLocalizationType);
		this.sFilename = "Category_" +  cc.getName();
		
		
		int i = 1; 
		int j = 3; 
		for (Language lang : this.vLanguageSelected) {
			PoiExcelUtil.setCellValue( sheet, j, i, lang.getShortLabel());
			i++;
		}	
		
		j++;	
		
		int iMaxIndex = Localize.LOCALIZED_MATRIX[1][(int)lIdCaptionCategory].length;

		for (int k = 1; k < iMaxIndex; k++)
		{
	    	PoiExcelUtil.setCellValue( sheet, j, 0, "" + k);
			i=1;
			for (Language lang : vLanguageSelected) {
				String sValue = "";
				if(Localize.LOCALIZED_MATRIX[(int)lang.getId()][(int)lIdCaptionCategory][k] != null )
				{
					sValue =  Localize.LOCALIZED_MATRIX[(int)lang.getId()][(int)lIdCaptionCategory][k];
				} else {
					sValue = "";
				}
				PoiExcelUtil.setCellValue( sheet, j, i,  sValue);
				i++;
			}
			j++;
		}
		
		return wb;
	}
	
	
	
	protected HSSFWorkbook prepareExcelFileObjectAttributeLocalization(
			HttpServletRequest request)
	throws NamingException, SQLException, CoinDatabaseLoadException,
	InstantiationException, IllegalAccessException, SecurityException,
	IllegalArgumentException, ClassNotFoundException, NoSuchFieldException 
	{
		HSSFWorkbook wb = new HSSFWorkbook();
		HSSFSheet sheet;
		sheet = wb.createSheet();
		wb.setSheetName(0, "Localization");
		
		requestObjectType(request);
		prepareObjectType(sheet, this.objType);
		
		Connection conn = ConnectionManager.getConnection();
		String[] sAttributeName = this.objType.getObjectFieldNames();
		Map<String, String>[] mapOL 
			= ObjectAttributeLocalization
				.generateAttributeLocalizationMatrixString((int) this.objType.getId(), conn);
		ConnectionManager.closeConnection(conn);


		int i = 1; 
		int j = 3; 
		for (Language lang : this.vLanguageSelected) {
			PoiExcelUtil.setCellValue( sheet, j, i, lang.getShortLabel());
			i++;
		}	
		
		j++;	
		for (String sAttribute : sAttributeName) {

			PoiExcelUtil.setCellValue( sheet, j, 0, sAttribute);
			i = 1; 
			
			for (Language lang : this.vLanguageSelected) {
				String sAttributeValue = null;
				sAttributeValue = mapOL[(int)lang.getId()].get(sAttribute);
				
				String sValue = "";
				
				if(sAttributeValue != null)
				{
					sValue = sAttributeValue;
				} else {
					sValue = "";
				}
				PoiExcelUtil.setCellValue( sheet, j, i,  sValue);
				i++;
				
			}	
			j++;
		}	
		return wb;
	}
	
	
	
	protected HSSFWorkbook prepareExcelFileObjectLocalization(
			HttpServletRequest request) 
	throws NamingException, SQLException, CoinDatabaseLoadException, InstantiationException,
	IllegalAccessException, SecurityException, IllegalArgumentException, ClassNotFoundException, 
	NoSuchFieldException, InvocationTargetException, NoSuchMethodException
	{
		// ne marche que pour Excel 2000(pas Excel 5.0)
		HSSFWorkbook wb = new HSSFWorkbook();
		HSSFSheet sheet;
		sheet = wb.createSheet();
		wb.setSheetName(0, "Localization");
		requestObjectType(request);
		prepareObjectType(sheet, this.objType);
		
		ObjectLocalization[][] arrOL = null;
		Map<String, ObjectLocalization>[] mapOL = null;
		
		
		
		Connection conn = ConnectionManager.getConnection();
		CoinDatabaseAbstractBean item = (CoinDatabaseAbstractBean )objType.invokeObjectConstructor();
		item.bUseHttpPrevent=false;
		Vector<CoinDatabaseAbstractBean> vReference = item.getAll();
		
		int iPrimaryKeyType = (Integer)objType.invokeObjectInstanceMethod("getPrimaryKeyType");

		switch(iPrimaryKeyType)
		{
		case CoinDatabaseAbstractBean.PRIMARY_KEY_TYPE_LONG:
			arrOL = ObjectLocalization.generateObjectLocalization(this.objType.getId(), conn);
			break;
			
		case CoinDatabaseAbstractBean.PRIMARY_KEY_TYPE_STRING:
			mapOL = ObjectLocalization.generateObjectLocalizationString(this.objType.getId(), conn);
			break;
			
		}
		ConnectionManager.closeConnection(conn);
		
		
		
		int i = 1; 
		int j = 3; 
		for (Language lang : this.vLanguageSelected) {
			PoiExcelUtil.setCellValue( sheet, j, i, lang.getShortLabel());
			i++;
		}	
		
		j++;	
		for (CoinDatabaseAbstractBean reference : vReference) {
			String sReferenceId = "";
			
			switch(iPrimaryKeyType)
			{
			case CoinDatabaseAbstractBean.PRIMARY_KEY_TYPE_LONG:
				sReferenceId = ""+reference.getId();
				break;
				
			case CoinDatabaseAbstractBean.PRIMARY_KEY_TYPE_STRING:
				sReferenceId = reference.getIdString();
				break;
			}
			PoiExcelUtil.setCellValue( sheet, j, 0, sReferenceId);
			
			i = 1; 
			for (Language lang : this.vLanguageSelected) {
				String sValue = "";
				ObjectLocalization ol = null;
				switch(iPrimaryKeyType)
				{
				case CoinDatabaseAbstractBean.PRIMARY_KEY_TYPE_LONG:
					if(reference.getId()<arrOL[(int)lang.getId()].length)
					    ol = arrOL[(int)lang.getId()][(int)reference.getId()];
					break;
					
				case CoinDatabaseAbstractBean.PRIMARY_KEY_TYPE_STRING:
					ol = mapOL[(int)lang.getId()].get(reference.getIdString());
					break;
					
				}
				if(ol != null)
				{
					sValue = ol.getValue();
				} else {
					sValue = "";
				}
				
				PoiExcelUtil.setCellValue( sheet, j, i,  sValue);
				i++;
			}
			PoiExcelUtil.setCellValue( sheet, j, i,  reference.getName());
			
			
			j++; 
		}	
		
		
		return wb;
		
	}			

	/**
	 * TODO
	 * 
	 * @param request
	 * @return
	 */
	protected HSSFWorkbook prepareExcelFileObjectMethodLocalization(
			HttpServletRequest request) 
	{
		// TODO
		HSSFWorkbook wb = new HSSFWorkbook();
		HSSFSheet sheet;
		sheet = wb.createSheet();
		wb.setSheetName(0, "Localization TODO");
		
		return wb;
	}

	protected void prepareObjectType(
			HSSFSheet sheet,
			ObjectType objType)
	{
		PoiExcelUtil.setCellValue( sheet, 0, 0, "Object type : ");
		PoiExcelUtil.setCellValue( sheet, 0, 1, ""+objType.getId());
		PoiExcelUtil.setCellValue( sheet, 0, 2, objType.getName());
		PoiExcelUtil.setCellValue( sheet, 1, 0, "Localization type : ");
		PoiExcelUtil.setCellValue( sheet, 1, 1, this.sLocalizationType);

	}
	
	protected void prepareLanguageList(
			HSSFSheet sheet)
	{
		int i=0;
		for (Language lang : this.vLanguageSelected) {
			PoiExcelUtil.setCellValue( sheet, 3, i, lang.getShortLabel());
			i++;
		}	

	}
	
	protected void requestObjectType(
			HttpServletRequest request) 
	throws CoinDatabaseLoadException, SQLException, NamingException, 
	InstantiationException, IllegalAccessException
	{
		long lIdTypeObject = HttpUtil.parseLong("lIdTypeObject", request);
		this.objType = ObjectType.getObjectTypeMemory(lIdTypeObject);
		this.sFilename = objType.getName();
		
	}


	protected void doPost(
			HttpServletRequest request,
			HttpServletResponse response) {
		doGet(request, response);
	}
}
