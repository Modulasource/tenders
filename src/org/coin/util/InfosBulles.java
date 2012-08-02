/****************************************************************************
Studio Matamore - France 2004
Contact : studio@matamore.com - http://www.matamore.com
 ****************************************************************************/

package org.coin.util;



import java.sql.SQLException;
import java.util.Vector;

import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.coin.db.CoinDatabaseLoadException;
import org.coin.security.PreventInjection;
import org.json.JSONArray;
import org.json.JSONObject;

public class InfosBulles extends EnumeratorMemory {

	private static final long serialVersionUID = 1L;

	public static Vector<InfosBulles> m_vTItem = null;
	public static Vector<InfosBulles> m_unprevent_vItem = null; 

	public void setConstantes(){
		super.TABLE_NAME = "infos_bulles";
		super.FIELD_ID_NAME = "id_infos_bulles";
		super.FIELD_NAME_NAME = "contenu";
		super.SELECT_FIELDS_NAME = super.FIELD_NAME_NAME;
		super.SELECT_FIELDS_NAME_SIZE = 1;
	}

	public InfosBulles() {
		super();
		setConstantes();
	}

	public InfosBulles(int iId, String sContenu) {
		super(iId,sContenu);
		setConstantes();
	}

	public InfosBulles(int iId) {
		super(iId);
		setConstantes();
	}

	public InfosBulles(int iId, String sName,boolean bUseHttpPrevent) {
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
		return new InfosBulles(iId, sName,bUseHttpPrevent);
	}

	public static InfosBulles getInfosBulles(int iId) throws Exception {
		InfosBulles infos = new InfosBulles(iId);
		infos.load();
		return infos; 
	}

	public static String getInfosBullesContenu(int iId) throws Exception {
		InfosBulles infos = new InfosBulles(iId);
		infos.load();
		return infos.getName();
	}

	public static String getInfosBullesContenu(
			int iId,
			boolean bUseHttpPrevent) throws Exception {
		InfosBulles infos = new InfosBulles(iId);
		infos.bUseHttpPrevent = bUseHttpPrevent;
		infos.load();
		return infos.getName();
	}

	public static String getHtmlAvertissementJuridique(HttpServletResponse response, String rootPath, long lIdInfoBulle)
	{
		return "<a href='javascript:OuvrirPopup(\""
				+ response.encodeURL(rootPath+"include/infosBulles.jsp?id="+lIdInfoBulle)
				+ "\",400,250,\"menubar=no,scrollbars=yes,statusbar=no\")' >"
				+ "<img src=\"" + rootPath+modula.graphic.Icone.ICONE_AJ + "\" style=\"vertical-align:middle\" "
				+ "alt=\"Avertissement juridique\" Title=\"Avertissement juridique\"/>\n"
				+ "</a>\n";
	}

	public static String getModal(long lIdInfoBulle,String rootPath) throws Exception
	{
		return getModal(lIdInfoBulle, rootPath, "");
	}
	
	public static String getModal(long lIdInfoBulle,String rootPath, String sText) throws Exception
	{
		String sContent = PreventInjection.preventForJavascript(InfosBulles.getInfosBullesContenuMemory((int)lIdInfoBulle));
		sContent = prepareContentWeb(sContent, rootPath);
		String sDeskHeaderBarBouton = 
			"<span id=\"infobulle_" + lIdInfoBulle + "\" class=\"infobulle\">\n"
			+ " <img src=\""+rootPath + "images/icons/information.png\"/> "+sText+"\n"
			+ "</span>"
			+ "<script>"
			+ " new Control.Modal(\"infobulle_" + lIdInfoBulle + "\",{"
			+ " position: 'mouse',"
			+ " offsetTop: -40,"
			+ " offsetLeft: 15,"
			+ " fade:true,"
			+ " fadeDuration:1,"
			+ " containerClassName:'infobulle_tooltip'," 
			+ " contents: \"" + Outils.replaceDoubleCoteSlashes(sContent)  + "\""
			+ " });" 
			+ "</script >";

		return sDeskHeaderBarBouton;
	}

	public static Vector<InfosBulles> getAllStatic(boolean bUseHttpPrevent)
	throws SQLException, NamingException
	{
		InfosBulles item = new InfosBulles();
		item.bUseHttpPrevent = bUseHttpPrevent;
		return item.getAllOrderById();
	}

	public void populateMemory()
	throws NamingException, SQLException, InstantiationException, IllegalAccessException{
		m_vTItem = getAllStatic(true);
		m_unprevent_vItem = getAllStatic(false);
	}

	@SuppressWarnings("unchecked")
	public <T> Vector<T> getAllMemory() 
	throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException{
		return (Vector<T>) getAllStaticMemory();
	}

	public static Vector<InfosBulles> getAllStaticMemory(boolean bUseHttpPrevent)
	throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException
	{
		InfosBulles item = new InfosBulles();
		item.bUseHttpPrevent = bUseHttpPrevent;
		reloadMemoryStatic(item);
		return item.getItemMemory();
	}

	public static Vector<InfosBulles> getAllStaticMemory()
	throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException
	{
		return getAllStaticMemory(true);
	}

	public static InfosBulles getInfosBullesMemory(
			long iId,
			boolean bUseHttpPrevent) 
	throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException 
	{
		Vector<InfosBulles> vItems = getAllStaticMemory(bUseHttpPrevent);
		for (InfosBulles item : vItems) {
			if(item.getId()==iId) return item;
		}

		throw new CoinDatabaseLoadException("" + iId, "getInfosBullesMemory");
	}

	public static String getInfosBullesContenuMemory(long iId) 
	throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException 
	{
		return getInfosBullesMemory(iId).getName();
	}
	
	public static String getInfosBullesContenuWeb(
			long iId,
			boolean bUseHttpPrevent,
			String rootPath) throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException {
		String sContent = getInfosBullesContenuMemory(iId, bUseHttpPrevent);
		sContent = prepareContentWeb(sContent, rootPath);
		return sContent;
	}
	
	public static String prepareContentWeb(String sContent,
			String rootPath){
		sContent = Outils.replaceAll(sContent, "img src=\"", "img src=\""+rootPath+"");
		return sContent;
	}
	
	public static String getInfosBullesContenuMemory(
			long iId,
			boolean bUseHttpPrevent) 
	throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException 
	{
		return getInfosBullesMemory(iId, bUseHttpPrevent).getName();
	}

	public static InfosBulles getInfosBullesMemory(long iId) 
	throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException 
	{
		return getInfosBullesMemory(iId,true);
	}

	public Vector<InfosBulles> getItemMemory() {
		return (this.bUseHttpPrevent?m_vTItem:m_unprevent_vItem);
	}

	public static JSONObject getJSONObject(long lId) throws Exception {
		InfosBulles item = getInfosBullesMemory(lId);
		JSONObject data = item.toJSONObject();
		return data;
	}

	public static JSONArray getJSONArray() throws Exception {
		return getJSONArray(true);
	}

	public static JSONArray getJSONArray(boolean bUseHttpPrevent) throws Exception {
		JSONArray items = new JSONArray();
		for (InfosBulles item:getAllStaticMemory(bUseHttpPrevent)) items.put(item.toJSONObject());
		return items;
	}

	public static boolean storeFromJSONString(String jsonStringData) throws Exception {
		return storeFromJSONObject(new JSONObject(jsonStringData));
	}

	public static boolean storeFromJSONObject(JSONObject data) throws Exception {
		try {
			InfosBulles item = null;
			try{
				item = InfosBulles.getInfosBullesMemory(data.getLong("lId"));
			} catch(Exception e){
				item = new InfosBulles();
				item.create();
			}
			item.setFromJSONObject(data);
			item.store();
			return true;
		} catch(Exception e){
			return false;
		}
	}
	
	public void setFromForm(HttpServletRequest request, String sFormPrefix) {
		this.sName = HttpUtil.parseStringBlank(sFormPrefix+"sName", request);
	}

}