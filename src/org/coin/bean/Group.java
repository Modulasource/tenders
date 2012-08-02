/*
* Studio Matamore - France 2009, tous droits réservés
* Contact : studio@matamore.com - http://www.matamore.com
*/

package org.coin.bean;

import org.coin.db.*;
import org.coin.util.Outils;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;
import java.sql.*;
import java.util.Vector;

public class Group extends CoinDatabaseAbstractBeanMemory {

    private static final long serialVersionUID = 1L;

    protected String sName;
    protected String sReference;
    protected String sReferenceExterne;

    public static Vector<Group> m_vGroup = null;
    public static Vector<Group> m_unprevent_vGroup = null; 
    
    protected static String[][] s_sarrLocalization;

    public Group() {
        init();
    }

    public Group(long lId) {
        init();
        this.lId = lId;
    }
    
    public Group(String sName) {
    	init();
    	this.sName = sName;
    }
    
    public Group(int iId) {
    	init();
        this.lId = iId;
    }
    
    public Group(int iId, String sName) {
    	init();
        this.lId = iId;
        this.sName = sName;
    }
    
	public Group(int iId, String sName,boolean bUseHttpPrevent) {
		init();
        this.lId = iId;
        this.sName = sName;
		this.bUseHttpPrevent = bUseHttpPrevent;
	}

    public void init() {
        super.TABLE_NAME = "coin_group";
        super.FIELD_ID_NAME = "id_"+ super.TABLE_NAME;
        super.SELECT_FIELDS_NAME =
                " name,"
                + " reference,"
                + " reference_externe";

        super.SELECT_FIELDS_NAME_SIZE = super.SELECT_FIELDS_NAME.split(",").length;
        this.iAbstractBeanIdObjectType = ObjectType.GROUP;
        
        super.lId = 0;
        this.sName = "";
        this.sReference = "";
        this.sReferenceExterne = "";
    }

    public void populateMemory()
    throws NamingException, SQLException, InstantiationException, IllegalAccessException {
        m_vGroup = getAllStatic(true,this.connEmbeddedConnection);
		m_unprevent_vGroup = getAllStatic(false,this.connEmbeddedConnection);
    }

    public Vector<Group> getItemMemory() {
		return (this.bUseHttpPrevent?m_vGroup:m_unprevent_vGroup);
	}

    @SuppressWarnings("unchecked")
    public <T> Vector<T> getAllMemory()
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException {
        return (Vector<T>) getAllStaticMemory();
    }

    public void setPreparedStatement(PreparedStatement ps) throws SQLException {
        int i = 0;
        ps.setString(++i, preventStore(this.sName));
        ps.setString(++i, preventStore(this.sReference));
        ps.setString(++i, preventStore(this.sReferenceExterne));
    }

    public void setFromResultSet(ResultSet rs) throws SQLException {
        int i = 0;
        this.sName = preventLoad(rs.getString(++i));
        this.sReference = preventLoad(rs.getString(++i));
        this.sReferenceExterne = preventLoad(rs.getString(++i));
    }

    public static Group getGroup(long lId) throws CoinDatabaseLoadException, SQLException, NamingException {
       return getGroup((int)lId);
    }

    public static Group getGroup(int iId) throws CoinDatabaseLoadException, SQLException, NamingException {
		Group group = new Group(iId);
		group.load();
		return group; 
	}
    
    public static String getGroupeName(int iId) throws CoinDatabaseLoadException, SQLException, NamingException {
    	return getGroup(iId).getName();
    }
    
    public static String getGroupNameMemory(int iId,boolean bUseHttpPrevent,Connection conn) 
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException  {
    	return getGroupMemory(iId,bUseHttpPrevent,conn).getName();
    }
    public static String getGroupNameMemory(int iId,boolean bUseHttpPrevent) 
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException  {
    	return getGroupMemory(iId,bUseHttpPrevent).getName();
    }
    public static String getGroupNameMemory(int iId) throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException  {
    	return getGroupNameMemory(iId,true);
    }

    public static Vector<Group> getAllGroup() throws SQLException, NamingException, InstantiationException, IllegalAccessException
	{
    	return getAllStatic();
	}
    
    public static Group getGroupMemory(
    		long iId,
    		boolean bUseHttpPrevent,
    		Connection conn) 
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException 
    {
    	Vector<Group> vItems = getAllStaticMemory(bUseHttpPrevent,conn);
    	for (Group item : vItems) {
        	if(item.getId()==iId) return item;
		}

    	throw new CoinDatabaseLoadException("" + iId, "getGroupMemory");
    }
    
    public static Group getGroupMemory(
    		long iId,
    		boolean bUseHttpPrevent) 
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException 
    {
    	return getGroupMemory(iId,true,null);
    }
    
    public static Group getGroupMemory(long iId) 
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException 
    {
    	return getGroupMemory(iId,true);
    }

    public void setFromForm(HttpServletRequest request, String sFormPrefix) {
        try {
            this.sName = request.getParameter(sFormPrefix + "sName");
        } catch(Exception e){}
        try {
            this.sReference = request.getParameter(sFormPrefix + "sReference");
        } catch(Exception e){}
        try {
            this.sReferenceExterne = request.getParameter(sFormPrefix + "sReferenceExterne");
        } catch(Exception e){}
    }

    public static Vector<Group> getAllWithSqlQueryStatic(String sSQLQuery)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        Group item = new Group();
        return getAllWithSqlQuery(sSQLQuery, item);
    }
    
	public static Vector<Group> getAllStatic(boolean bUseHttpPrevent)
	throws SQLException, NamingException, InstantiationException, IllegalAccessException
    {
		return getAllStatic(bUseHttpPrevent, null);
    }
	
	public static Vector<Group> getAllStatic(boolean bUseHttpPrevent, Connection conn)
	throws SQLException, NamingException, InstantiationException, IllegalAccessException
    {
		Group item = new Group();
    	item.bUseHttpPrevent = bUseHttpPrevent;
    	if(conn != null){
        	item.bUseEmbeddedConnection = true;
        	item.connEmbeddedConnection = conn;
    	}
    	return item.getAll();
    }

    public static Vector<Group> getAllStatic()
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        Group item = new Group();
        String sSQLQuery
        = "SELECT " + item.SELECT_FIELDS_NAME + ", " + item.FIELD_ID_NAME
        + " FROM " + item.TABLE_NAME;
        return getAllWithSqlQuery(sSQLQuery, item);
    }

    public static Vector<Group> getAllStatic(Connection conn)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        Group item = new Group();
        String sSQLQuery
        = "SELECT " + item.SELECT_FIELDS_NAME + ", " + item.FIELD_ID_NAME
        + " FROM " + item.TABLE_NAME;
        return getAllWithSqlQuery(sSQLQuery, item, conn);
    }
    
    public static Vector<Group> getAllStaticMemory(boolean bUseHttpPrevent,Connection conn)
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException
    {
		Group item = new Group();
    	item.bUseHttpPrevent = bUseHttpPrevent;
    	if(conn != null){
        	item.bUseEmbeddedConnection = true;
        	item.connEmbeddedConnection = conn;
    	}
    	reloadMemoryStatic(item);
    	return item.getItemMemory();
    }
	
	public static Vector<Group> getAllStaticMemory(boolean bUseHttpPrevent)
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException
    {
		return getAllStaticMemory(bUseHttpPrevent,null);
    }
    
	public static Vector<Group> getAllStaticMemory()
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException
    {
    	return getAllStaticMemory(true,null);
    }

    public static Vector<Group> getAllMemoryFromXXXX(long lIdXXXX)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException, CoinDatabaseLoadException {
        Vector<Group> vResult = new Vector<Group>();
        /*for (Group item : getAllStaticMemory()) {
            if (item.getIdXXXX() == lIdXXXX) vResult.add(item);
        }*/
        return vResult;
    }

    public static Vector<Group> getAllWithWhereAndOrderByClauseStatic(String sWhereClause, String sOrderByClause)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        Group item = new Group();
        return item.getAllWithWhereAndOrderByClause(sWhereClause, sOrderByClause);
    }

    @Override
    public String getName() {
    	if(this.bUseLocalization)
    	{
    		String s = getLocalizedName(!(s_sarrLocalization==null));
    		if(s == null) return this.sName;
    		return s;
    	}
        return this.sName;
    }
    public void setName(String sName) {this.sName = sName;}

    public String getReference() {return this.sReference;}
    public String getReferenceNotNull() {return (Outils.isNull(this.sReference)?"":this.sReference);}
    public void setReference(String sReference) {this.sReference = sReference;}

    public String getReferenceExterne() {return this.sReferenceExterne;}
    public String getReferenceExterneNotNull() {return (Outils.isNull(this.sReferenceExterne)?"":this.sReferenceExterne);}
    public void setReferenceExterne(String sReferenceExterne) {this.sReferenceExterne = sReferenceExterne;}

    public JSONObject toJSONObject() throws JSONException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException, NamingException, SQLException {
        JSONObject item = new JSONObject();
        item.put("lId", this.lId);
        item.put("sName", this.sName);
        item.put("sReference", this.sReference);
        item.put("sReferenceExterne", this.sReferenceExterne);
        return item;
    }

    public static JSONObject getJSONObject(long lId) throws CoinDatabaseLoadException,
    SQLException, NamingException, JSONException, InstantiationException, IllegalAccessException {
        Group item = getGroup(lId);
        JSONObject data = item.toJSONObject();
        return data;
    }

    public static JSONArray getJSONArray() throws JSONException, InstantiationException,
    IllegalAccessException, NamingException, SQLException, CoinDatabaseLoadException {
        JSONArray items = new JSONArray();
        for (Group item:getAllStaticMemory(false)) items.put(item.toJSONObject());
        return items;
    }

	public void removeWithObjectAttached(
			Connection conn)
	throws NamingException, SQLException, InstantiationException, IllegalAccessException,
	CoinDatabaseLoadException 
	{

		ConnectionManager.executeUpdate(
    			"DELETE FROM coin_role_group "
    			+ " WHERE id_coin_group=" + this.lId, 
    			conn);


		ConnectionManager.executeUpdate(
    			"DELETE FROM coin_user_group "
    			+ " WHERE id_coin_group=" + this.lId, 
    			conn);
		

		remove(conn);
	}
    
    public void setFromJSONObject(JSONObject item) {
        try {
            this.sName = item.getString("sName");
        } catch(Exception e){}
        try {
            this.sReference = item.getString("sReference");
        } catch(Exception e){}
        try {
            this.sReferenceExterne = item.getString("sReferenceExterne");
        } catch(Exception e){}
    }

    public static boolean storeFromJSONString(String jsonStringData) throws JSONException {
        return storeFromJSONObject(new JSONObject(jsonStringData));
    }

    public static boolean storeFromJSONObject(JSONObject data) {
        try {
            Group item = null;
            try{
                item = Group.getGroup(data.getLong("lId"));
            } catch(Exception e){
                item = new Group();
                item.create();
            }
            item.setFromJSONObject(data);
            item.store();
            return true;
        } catch(Exception e){
            return false;
        }
    }
    
    public static Group getGroup(
    		long lId, 
    		Vector<Group> vItems) 
    throws CoinDatabaseLoadException
    {
		for(Group item : vItems){
			if(lId == item.getId()) return item;
		}
		throw new CoinDatabaseLoadException("le groupe "+lId+" est inconnu","");
	}
    
    public static Group getGroupFromName(String sName, Vector<Group> vItems) throws CoinDatabaseLoadException{
		for(Group item : vItems){
			if(Outils.removeAllSpaces(sName.toLowerCase())
					.equalsIgnoreCase(Outils.removeAllSpaces(item.getName().toLowerCase())))
				return item;
		}
		throw new CoinDatabaseLoadException("le groupe "+sName+" est inconnu","");
	}
    
    public static Group getGroupFromReferenceExterne(String sReferenceExterne, Vector<Group> vItems) throws CoinDatabaseLoadException{
		for(Group item : vItems){
			if(item.getReferenceExterne() != null &&
			Outils.removeAllSpaces(sReferenceExterne.toLowerCase())
					.equalsIgnoreCase(Outils.removeAllSpaces(item.getReferenceExterne().toLowerCase())))
				return item;
		}
		throw new CoinDatabaseLoadException("le groupe avec la référence externe "+sReferenceExterne+" est inconnu","");
	}
    
    @Override
    public String getLocalizedName(Connection conn) {
    	s_sarrLocalization = getLocalizationMatrixOptional(s_sarrLocalization, conn);
		return s_sarrLocalization[this.iAbstractBeanIdLanguage][(int)this.lId];
    }
    
    @Override
    public void updateLocalization(Connection conn)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException
	{
    	s_sarrLocalization =  ObjectLocalization.generateLocalizationMatrix(this, conn);
	}

}
