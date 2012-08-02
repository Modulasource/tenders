
/*
* Studio Matamore - France 2008, tous droits réservés
* Contact : studio@matamore.com - http://www.matamore.com
*/

package org.coin.bean;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Vector;

import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;

import org.coin.db.CoinDatabaseAbstractBean;
import org.coin.db.CoinDatabaseCreateException;
import org.coin.db.CoinDatabaseDuplicateException;
import org.coin.db.CoinDatabaseLoadException;
import org.coin.db.ConnectionManager;
import org.coin.util.Outils;
import org.directwebremoting.annotations.RemoteMethod;
import org.directwebremoting.annotations.RemoteProxy;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

@RemoteProxy
public class UserGroup extends CoinDatabaseAbstractBean {

    private static final long serialVersionUID = 1L;

    protected long lIdCoinGroup;
    protected long lIdCoinUser;
    protected long lIdCoinUserGroupType;

    public UserGroup() {
        init();
    }

    public UserGroup(long lId) {
        init();
        this.lId = lId;
    }
    
    public UserGroup(int iIdUser, int iIdGroup) {
    	init();
    	this.lIdCoinUser = iIdUser;
    	this.lIdCoinGroup = iIdGroup;
    }

    public void init() {
        super.TABLE_NAME = "coin_user_group";
        super.FIELD_ID_NAME = "id_"+ super.TABLE_NAME;
        super.SELECT_FIELDS_NAME =
                " id_coin_group,"
                + " id_coin_user,"
                + " id_coin_user_group_type";

        super.SELECT_FIELDS_NAME_SIZE = super.SELECT_FIELDS_NAME.split(",").length;

        super.lId = 0;
        this.lIdCoinGroup = 0;
        this.lIdCoinUser = 0;
        this.lIdCoinUserGroupType = CoinUserGroupType.TYPE_HABILITATE;
    }

    public void setPreparedStatement(PreparedStatement ps) throws SQLException {
        int i = 0;
        ps.setLong(++i, this.lIdCoinGroup);
        ps.setLong(++i, this.lIdCoinUser);
        ps.setLong(++i, this.lIdCoinUserGroupType);
    }

    public void setFromResultSet(ResultSet rs) throws SQLException {
        int i = 0;
        this.lIdCoinGroup = rs.getLong(++i);
        this.lIdCoinUser = rs.getLong(++i);
        this.lIdCoinUserGroupType = rs.getLong(++i);
    }

    public static UserGroup getUserGroup(long lId)
    throws CoinDatabaseLoadException, SQLException, NamingException {
    	UserGroup item = new UserGroup(lId);
        item.load();
        return item;
    }

    public void setFromForm(HttpServletRequest request, String sFormPrefix) {
        try {
            this.lIdCoinGroup = Long.parseLong(request.getParameter(sFormPrefix + "lIdCoinGroup"));
        } catch(Exception e){}
        try {
            this.lIdCoinUser = Long.parseLong(request.getParameter(sFormPrefix + "lIdCoinUser"));
        } catch(Exception e){}
        try {
            this.lIdCoinUserGroupType = Long.parseLong(request.getParameter(sFormPrefix + "lIdCoinUserGroupType"));
        } catch(Exception e){}
    }

    public static Vector<UserGroup> getAllWithSqlQueryStatic(String sSQLQuery)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
    	UserGroup item = new UserGroup();
        return getAllWithSqlQuery(sSQLQuery, item);
    }

    public static Vector<UserGroup> getAllStatic()
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
    	UserGroup item = new UserGroup();
        String sSQLQuery
        = "SELECT " + item.SELECT_FIELDS_NAME + ", " + item.FIELD_ID_NAME
        + " FROM " + item.TABLE_NAME;
        return getAllWithSqlQuery(sSQLQuery, item);
    }

    public static Vector<UserGroup> getAllStatic(Connection conn)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
    	UserGroup item = new UserGroup();
        String sSQLQuery
        = "SELECT " + item.SELECT_FIELDS_NAME + ", " + item.FIELD_ID_NAME
        + " FROM " + item.TABLE_NAME;
        return getAllWithSqlQuery(sSQLQuery, item, conn);
    }

    public static Vector<UserGroup> getAllWithWhereAndOrderByClauseStatic(String sWhereClause, String sOrderByClause)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
    	UserGroup item = new UserGroup();
        return item.getAllWithWhereAndOrderByClause(sWhereClause, sOrderByClause);
    }

    @Override
    public String getName() {
        return "coin_user_group_"+this.lId;
    }

    public long getIdCoinGroup() {return this.lIdCoinGroup;}
    public void setIdCoinGroup(long lIdCoinGroup) {this.lIdCoinGroup = lIdCoinGroup;}

    public long getIdCoinUser() {return this.lIdCoinUser;}
    public void setIdCoinUser(long lIdCoinUser) {this.lIdCoinUser = lIdCoinUser;}

    public long getIdCoinUserGroupType() {return this.lIdCoinUserGroupType;}
    public void setIdCoinUserGroupType(long lIdCoinUserGroupType) {this.lIdCoinUserGroupType = lIdCoinUserGroupType;}

    public JSONObject toJSONObject() throws JSONException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException, NamingException, SQLException {
        JSONObject item = new JSONObject();
        item.put("lId", this.lId);
        item.put("lIdCoinGroup", this.lIdCoinGroup);
        item.put("lIdCoinUser", this.lIdCoinUser);
        item.put("lIdCoinUserGroupType", this.lIdCoinUserGroupType);
        return item;
    }

    public static JSONObject getJSONObject(long lId) throws CoinDatabaseLoadException, SQLException, NamingException, JSONException, InstantiationException, IllegalAccessException {
    	UserGroup item = getUserGroup(lId);
        JSONObject data = item.toJSONObject();
        return data;
    }

    public static JSONArray getJSONArray() throws JSONException, InstantiationException, IllegalAccessException, NamingException, SQLException, CoinDatabaseLoadException {
        JSONArray items = new JSONArray();
        for (UserGroup item:getAllStatic()) items.put(item.toJSONObject());
        return items;
    }

    public void setFromJSONObject(JSONObject item) {
        try {
            this.lIdCoinGroup = item.getLong("lIdCoinGroup");
        } catch(Exception e){}
        try {
            this.lIdCoinUser = item.getLong("lIdCoinUser");
        } catch(Exception e){}
        try {
            this.lIdCoinUserGroupType = item.getLong("lIdCoinUserGroupType");
        } catch(Exception e){}
    }

    public static boolean storeFromJSONString(String jsonStringData) throws JSONException {
        return storeFromJSONObject(new JSONObject(jsonStringData));
    }

    public static boolean storeFromJSONObject(JSONObject data) {
        try {
        	UserGroup item = null;
            try{
                item = UserGroup.getUserGroup(data.getLong("lId"));
            } catch(Exception e){
                item = new UserGroup();
                item.create();
            }
            item.setFromJSONObject(data);
            item.store();
            return true;
        } catch(Exception e){
            return false;
        }
    }
    
    public static void removeAllByIdUser(int iIdUser) throws SQLException, NamingException {
    	UserGroup item = new UserGroup();
        item.remove("WHERE id_coin_user="+iIdUser);
	 }

    public static Vector<User> getAllUser(String sGroupName) throws Exception
	{
    	Group group = new Group ();
    	sGroupName = Outils.replaceAll(sGroupName, "'" , "\\'");
    	User user = new User ();
    	
    	String sSQLQuery = "SELECT usr." + user.FIELD_ID_NAME 
						+ " FROM " 	+ user.TABLE_NAME + " usr,  " 
									+ "coin_user_group usergroup, "
									+ group.TABLE_NAME + " grp "
						+ " WHERE usr.id_coin_user=usergroup.id_coin_user"
						+ " AND usergroup.id_coin_group=grp.id_coin_group"
    					+ " AND grp.name = '" + sGroupName + "'";
   	
    	return user.getAllWithSqlQuery(sSQLQuery);
 	}
   
    public static Vector<User> getAllUser(int iIdGroup) throws Exception
	{
    	User user = new User ();
    	String sSQLQuery = "SELECT usr." + user.FIELD_ID_NAME 
						+ " FROM " 	+ user.TABLE_NAME  + " usr,  coin_user_group usergroup" 
						+ " WHERE usr.id_coin_user=" + "usergroup.id_coin_user" 
						+ " AND usergroup.id_coin_group=" + iIdGroup;
   	
    	return user.getAllWithSqlQuery(sSQLQuery);
 	}

    public static Vector<Group> getAllGroup(
    		long iIdUser)
    throws SQLException, NamingException, InstantiationException, IllegalAccessException
	{
    	return getAllGroup(iIdUser, CoinUserGroupType.TYPE_HABILITATE);
	}
    
    public static Vector<Group> getAllGroup(
    		long iIdUser,
    		int iIdCoinUserGroupType)
    throws SQLException, NamingException, InstantiationException, IllegalAccessException
	{
    	Connection conn = ConnectionManager.getConnection();
    	try {
			return getAllGroup(iIdUser,iIdCoinUserGroupType, false, conn);
		} finally {
			ConnectionManager.closeConnection(conn);
		}
	}
    public static Vector<Group> getAllGroup(
    		long iIdUser,
    		boolean bUseHttpPrevent,
    		Connection conn)
    throws SQLException, NamingException, InstantiationException, IllegalAccessException
	{
    	return getAllGroup(iIdUser, CoinUserGroupType.TYPE_HABILITATE, bUseHttpPrevent, conn);
	}
    
    public static Vector<Group> getAllGroup(
    		long iIdUser,
    		int iIdCoinUserGroupType,
    		boolean bUseHttpPrevent,
    		Connection conn)
    throws SQLException, NamingException, InstantiationException, IllegalAccessException
	{
    	Group item = new Group();
    	String sSQLQuery = item.getAllSelect("gp.")+", coin_user_group usergroup " 
						+ " WHERE gp.id_coin_group =" + "usergroup.id_coin_group"
						+ " AND usergroup.id_coin_user_group_type=" + iIdCoinUserGroupType 
						+ " AND usergroup.id_coin_user=" + iIdUser;
   	
    	item.bUseHttpPrevent = bUseHttpPrevent;
    	return item.getAllWithSqlQuery(sSQLQuery, conn);
	}

    
    public static Vector<Group> getAllGroup(
    		long iIdUser,
    		int iIdCoinUserGroupType,
    		Vector<Group> vGroupAll,
    		Vector<UserGroup> vUserGroupAll)
    throws SQLException, NamingException, InstantiationException, IllegalAccessException, CoinDatabaseLoadException
	{
    	Vector<Group> vGroup =  new Vector<Group>();
    	for (UserGroup ug : vUserGroupAll) {
			if(ug.getIdCoinUser() == iIdUser
			&& ug.getIdCoinUserGroupType() == iIdCoinUserGroupType){
				vGroup.add(Group.getGroup(ug.getIdCoinGroup(), vGroupAll));
			}
		}
    	return vGroup;
	}

    
	public static Vector<UserGroup> getAllHabilitateFromUser(long lIdUser) throws CoinDatabaseLoadException, InstantiationException, IllegalAccessException, NamingException, SQLException{
		return getAllFromUser(lIdUser, CoinUserGroupType.TYPE_HABILITATE);
	}
	
	public static Vector<UserGroup> getAllManageableFromUser(long lIdUser) throws CoinDatabaseLoadException, InstantiationException, IllegalAccessException, NamingException, SQLException{
		return getAllFromUser(lIdUser, CoinUserGroupType.TYPE_MANAGEABLE);
	}
	
	public static Vector<UserGroup> getAllHabilitateFromUser(long lIdUser, Connection conn) throws CoinDatabaseLoadException, InstantiationException, IllegalAccessException, NamingException, SQLException{
		return getAllFromUser(lIdUser, CoinUserGroupType.TYPE_HABILITATE, conn);
	}

	
	public static Vector<UserGroup> getAllFromUser(long lIdUser,int iIdCoinUserGroupType) throws InstantiationException, IllegalAccessException, NamingException, SQLException{
		
		Connection conn = ConnectionManager.getConnection();
		try {
			return getAllFromUser(lIdUser, iIdCoinUserGroupType, conn);
		} finally {
			ConnectionManager.closeConnection(conn);
		}
	}

	public static Vector<UserGroup> getAllFromUser(
			long lIdUser,
			int iIdCoinUserGroupType, 
			Connection conn) 
	throws InstantiationException, IllegalAccessException, NamingException, SQLException
	{
		return getAllFromUser(lIdUser, iIdCoinUserGroupType, false, conn);
	}
	
	public static Vector<UserGroup> getAllFromUser(
			long lIdUser,
			int iIdCoinUserGroupType, 
			boolean bUseHttpPrevent,
			Connection conn) 
	throws InstantiationException, IllegalAccessException, NamingException, SQLException
	{
		UserGroup item = new UserGroup();
		item.setAbstractBeanConnexion(conn);
		item.bUseHttpPrevent = bUseHttpPrevent ;
		return item.getAllWithWhereAndOrderByClause(
				"WHERE id_coin_user="+lIdUser
				+ " AND id_coin_user_group_type="+iIdCoinUserGroupType, 
				"");
	}
		
    
	public static Vector<UserGroup> getAllHabilitateFromUser(long lIdUser, Vector<UserGroup> vItems) throws CoinDatabaseLoadException{
		return getAllFromUser(lIdUser, CoinUserGroupType.TYPE_HABILITATE, vItems);
	}
	
	public static Vector<UserGroup> getAllManageableFromUser(long lIdUser, Vector<UserGroup> vItems) throws CoinDatabaseLoadException{
		return getAllFromUser(lIdUser, CoinUserGroupType.TYPE_MANAGEABLE, vItems);
	}

	public static Vector<UserGroup> getAllFromGroup(
			long lIdGroup) 
	throws CoinDatabaseLoadException, SQLException, InstantiationException,
	IllegalAccessException, NamingException
	{
		Connection conn = ConnectionManager.getConnection();
		try {
			return getAllFromGroup(lIdGroup, true, conn);
		} finally {
			ConnectionManager.closeConnection(conn);
		}
	}
	
	public static Vector<UserGroup> getAllFromGroup(
			long lIdGroup,
			boolean bUseHttpPrevent,
			Connection conn) 
	throws CoinDatabaseLoadException, SQLException, InstantiationException, IllegalAccessException
	{
		UserGroup item = new UserGroup();
    	item.bUseHttpPrevent = bUseHttpPrevent;
    	return item.getAllWithWhereAndOrderByClause(
    			"WHERE id_coin_group=" + lIdGroup , 
    			"",
    			conn);
	}
	
	public static Vector<UserGroup> getAllFromUser(
			long lIdUser,
			int iIdCoinUserGroupType, 
			Vector<UserGroup> vItems) 
	throws CoinDatabaseLoadException
	{
		Vector<UserGroup> vItemsReturn = new Vector<UserGroup>();
		for(UserGroup item : vItems){
			if(lIdUser == item.getIdCoinUser() && iIdCoinUserGroupType==item.getIdCoinUserGroupType())
				vItemsReturn.add(item);
		}
		return vItemsReturn;
	}
	
	public static Vector<UserGroup> getAllFromUser(long lIdUser, Vector<UserGroup> vItems) throws CoinDatabaseLoadException{
		return getAllFromUser(lIdUser, CoinUserGroupType.TYPE_HABILITATE, vItems);
	}
	
	@RemoteMethod
    public static void updateHabilitate(long iIdUser, String sGroup) throws JSONException, InstantiationException, IllegalAccessException, NamingException, SQLException, CoinDatabaseCreateException, CoinDatabaseDuplicateException, CoinDatabaseLoadException {
    	updateGroup(iIdUser, CoinUserGroupType.TYPE_HABILITATE, sGroup);
    }

	@RemoteMethod
    public static void updateManageable(long iIdUser, String sGroup) throws JSONException, InstantiationException, IllegalAccessException, NamingException, SQLException, CoinDatabaseCreateException, CoinDatabaseDuplicateException, CoinDatabaseLoadException {
		updateGroup(iIdUser, CoinUserGroupType.TYPE_MANAGEABLE, sGroup);
    }
	
    private static void updateGroup(long iIdUser,int iIdCoinUserGroupType, String sGroup) throws JSONException, InstantiationException, IllegalAccessException, NamingException, SQLException, CoinDatabaseCreateException, CoinDatabaseDuplicateException, CoinDatabaseLoadException {
    	JSONArray jsonGroup = new JSONArray(sGroup);
    	Vector<UserGroup> vUserGroup = UserGroup.getAllFromUser(iIdUser,iIdCoinUserGroupType);
    	for(int i=0;i<jsonGroup.length();i++){
    		JSONObject group = jsonGroup.getJSONObject(i);
    		long lIdGroup = group.getLong("id");
    		int iValue = group.getInt("value");
    		boolean bFindGroup = false;

    		for(UserGroup ug : vUserGroup){
    			if(ug.getIdCoinGroup()==lIdGroup 
    			&& ug.getIdCoinUserGroupType()==iIdCoinUserGroupType){
    				bFindGroup = true;
    				if(iValue==0) ug.remove();
    			}
    		}

    		if(iValue==1 && !bFindGroup){
    			UserGroup ug = new UserGroup();
    			ug.setIdCoinGroup(lIdGroup);
    			ug.setIdCoinUser(iIdUser);
    			ug.setIdCoinUserGroupType(iIdCoinUserGroupType);
    			ug.create();
    		}
    	}
    }
    	
    
}
