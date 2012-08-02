/*
* Studio Matamore - France 2007, tous droits réservés
* Contact : studio@matamore.com - http://www.matamore.com
*/

package org.coin.bean;

import modula.graphic.DeskUI;

import org.coin.db.*;
import org.coin.localization.Language;
import org.coin.security.DwrSession;
import org.coin.security.SessionException;
import org.coin.servlet.filter.HabilitationFilterUtil;
import org.directwebremoting.annotations.RemoteMethod;
import org.directwebremoting.annotations.RemoteProxy;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.sql.*;
import java.util.Map;
import java.util.Vector;

@RemoteProxy
public class UserTab extends CoinDatabaseAbstractBean {

    private static final long serialVersionUID = 1L;

    protected long lIdCoinUser;
    protected String sTabUrl;
    protected String sTabName;
    
    protected static Map<String,String>[] s_sarrLocalizationLabel;
    protected static String LABEL_TAB_HOME = "LABEL_TAB_HOME";
    
    public UserTab() {
        init();
    }

    public UserTab(long lId) {
        init();
        this.lId = lId;
    }

    public void init() {
        super.TABLE_NAME = "coin_user_tab";
        super.FIELD_ID_NAME = "id_"+ super.TABLE_NAME;
        super.SELECT_FIELDS_NAME =
                " id_coin_user,"
                + " tab_url,"
                + " tab_name";

        super.SELECT_FIELDS_NAME_SIZE = super.SELECT_FIELDS_NAME.split(",").length;
        this.iAbstractBeanIdObjectType = ObjectType.USER_TAB;
        
        super.lId = 0;
        this.lIdCoinUser = 0;
        this.sTabUrl = "";
        this.sTabName = "";
    }

    public void setPreparedStatement(PreparedStatement ps) throws SQLException {
        int i = 0;
        ps.setLong(++i, this.lIdCoinUser);
        ps.setString(++i, this.sTabUrl);
        ps.setString(++i, this.sTabName);
    }

    public void setFromResultSet(ResultSet rs) throws SQLException {
        int i = 0;
        this.lIdCoinUser = rs.getLong(++i);
        this.sTabUrl = rs.getString(++i);
        this.sTabName = rs.getString(++i);
    }

    public static UserTab getUserTab(long lId) throws Exception {
        UserTab item = new UserTab(lId);
        item.load();
        return item;
    }

    public void setFromForm(HttpServletRequest request, String sFormPrefix) {
        try {
            this.lIdCoinUser = Long.parseLong(request.getParameter(sFormPrefix + "lIdCoinUser"));
        } catch(Exception e){}
        try {
            this.sTabUrl = request.getParameter(sFormPrefix + "sTabUrl");
        } catch(Exception e){}
        try {
            this.sTabName = request.getParameter(sFormPrefix + "sTabName");
        } catch(Exception e){}
    }

    public static Vector<UserTab> getAllWithSqlQueryStatic(String sSQLQuery)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
    	UserTab item = new UserTab();
        return getAllWithSqlQuery(sSQLQuery, item);
    }

    public static Vector<UserTab> getAllStatic()
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
    	UserTab item = new UserTab();
        String sSQLQuery
        = "SELECT " + item.SELECT_FIELDS_NAME + ", " + item.FIELD_ID_NAME
        + " FROM " + item.TABLE_NAME;
        return getAllWithSqlQuery(sSQLQuery, item);
    }

    public static Vector<UserTab> getAllStatic(Connection conn)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
    	UserTab item = new UserTab();
        String sSQLQuery
        = "SELECT " + item.SELECT_FIELDS_NAME + ", " + item.FIELD_ID_NAME
        + " FROM " + item.TABLE_NAME;
        return getAllWithSqlQuery(sSQLQuery, item, conn);
    }

    public static Vector<UserTab> getAllWithWhereAndOrderByClauseStatic(String sWhereClause, String sOrderByClause)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
    	UserTab item = new UserTab();
        return item.getAllWithWhereAndOrderByClause(sWhereClause, sOrderByClause);
    }
    
    public static Vector<UserTab> getAllFromUser(long lIdUser)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
    	return getAllWithWhereAndOrderByClauseStatic("WHERE id_coin_user="+lIdUser,"");
    }
    
    public static void removeAllFromUser(long lIdUser)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
    	new UserTab().remove("WHERE id_coin_user="+lIdUser);
    }

    @Override
    public String getName() {
        return "coin_user_tab_"+this.lId;
    }

    public long getIdCoinUser() {return this.lIdCoinUser;}
    public void setIdCoinUser(long lIdCoinUser) {this.lIdCoinUser = lIdCoinUser;}

    public String getTabUrl() {return this.sTabUrl;}
    public void setTabUrl(String sTabUrl) {this.sTabUrl = sTabUrl;}

    public String getTabName() {return this.sTabName;}
    public void setTabName(String sTabName) {this.sTabName = sTabName;}

    public JSONObject toJSONObject() throws JSONException {
        JSONObject item = new JSONObject();
        item.put("lId", this.lId);
        item.put("lIdCoinUser", this.lIdCoinUser);
        item.put("sTabUrl", this.sTabUrl);
        item.put("sTabName", this.sTabName);
        try{
        	HttpServletRequest req = DwrSession.getRequest();
        	HttpServletResponse resp = DwrSession.getResponse();
        	String sRootPath = req.getContextPath()+"/";
        
        	item.put("sTabUrlComplete", resp.encodeURL(sRootPath+this.sTabUrl));
        }catch(Exception e){
        	item.put("sTabUrlComplete", "#");
        }
        return item;
    }

    public static JSONObject getJSONObject(long lId) throws Exception {
    	UserTab item = getUserTab(lId);
        JSONObject data = item.toJSONObject();
        return data;
    }

    public static JSONArray getJSONArray() throws Exception {
        JSONArray items = new JSONArray();
        for (UserTab item:getAllStatic()) items.put(item.toJSONObject());
        return items;
    }

    public void setFromJSONObject(JSONObject item) throws SessionException {
        try {
            this.lIdCoinUser = item.getLong("lIdCoinUser");
        } catch(Exception e){
        	this.lIdCoinUser = DwrSession.getUserSessionLogged(HabilitationFilterUtil.sSessionUserBeanName).getId();
        }
        try {
            this.sTabUrl = item.getString("sTabUrl");
        } catch(Exception e){
        	try{
	        	 String sTabUrlComplete = item.getString("sTabUrlComplete");
	             HttpServletRequest req = DwrSession.getRequest();
	             HttpSession session = DwrSession.getSession();
	             
	             String sRootPath = req.getContextPath()+"/";
	             String sSession = ";jsessionid="+session.getId();
	             
	             sTabUrlComplete = sTabUrlComplete.replaceFirst(sRootPath, "");
	             sTabUrlComplete = sTabUrlComplete.replaceFirst(sSession, "");
	             
	             this.sTabUrl = sTabUrlComplete;
        	}catch(Exception e1){}
        }
        try {
            this.sTabName = item.getString("sTabName");
        } catch(Exception e){}
    }

    public static boolean storeFromJSONString(String jsonStringData) throws Exception {
        return storeFromJSONObject(new JSONObject(jsonStringData));
    }
    
    @RemoteMethod
    public static void storeAllFromJSONString(String jsonStringData) throws Exception {
    	long lIdCoinUser = DwrSession.getUserSessionLogged(HabilitationFilterUtil.sSessionUserBeanName).getId();
    	removeAllFromUser(lIdCoinUser);
    	
    	JSONArray jsonTabs = new JSONArray(jsonStringData);
    	for(int i=0;i<jsonTabs.length();i++ ){
    		JSONObject jsonTab = jsonTabs.getJSONObject(i);
    		storeFromJSONObject(jsonTab);
    	}
    }
    
    public static JSONArray getJSONArrayFromSessionUser() throws Exception {
    	JSONArray items = new JSONArray();
    	
    	HttpServletRequest request = DwrSession.getRequest();
    	boolean bUseTabs = DeskUI.useTabs(request);
    	Language lang = DwrSession.getLanguageSession(HabilitationFilterUtil.SESSION_LANGUAGE);
        long lIdCoinUser = DwrSession.getUserSessionLogged(HabilitationFilterUtil.sSessionUserBeanName).getId();
        Vector<UserTab> vTabs = getAllFromUser(lIdCoinUser);
        
        if(vTabs.isEmpty() || !bUseTabs){
        	vTabs.clear();
        	UserTab mainTab = new UserTab();
        	mainTab.iAbstractBeanIdLanguage = (int)lang.getId();
        	mainTab.sTabName = mainTab.getLocalizedLabel(LABEL_TAB_HOME);
        	mainTab.sTabUrl = "desk/include/main.jsp";
        	vTabs.add(mainTab);
        }

        for (UserTab item:vTabs) items.put(item.toJSONObject());
        return items;
    }

    @RemoteMethod
    public static String getJSONArrayFromSessionUserDWR( ) throws Exception {
        return getJSONArrayFromSessionUser().toString();
    }

    public static boolean storeFromJSONObject(JSONObject data) throws Exception {
        try {
        	UserTab item = null;
            try{
                item = UserTab.getUserTab(data.getLong("lId"));
            } catch(Exception e){
                item = new UserTab();
                item.create();
            }
            item.setFromJSONObject(data);
            item.store();
            return true;
        } catch(Exception e){
            return false;
        }
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

}
