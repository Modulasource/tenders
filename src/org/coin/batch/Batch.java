package org.coin.batch;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.HashMap;

import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import mt.modula.batch.RemoteControlServiceConnection;

import org.coin.bean.User;
import org.coin.bean.UserHabilitation;
import org.coin.bean.conf.Configuration;
import org.coin.db.CoinDatabaseLoadException;
import org.coin.db.ConnectionManager;
import org.coin.localization.Language;
import org.coin.security.DwrSession;
import org.coin.util.JavaUtil;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;


public abstract class Batch implements BatchInterface{
	
	public String _ID ;
	public String _NAME ;
	public String _USE_CASE ;
	public String _DESC ;
	
	public String _JS_CONTEXT ;
	public int _OBJECT_CONTEXT ;
	
	protected boolean bUseEventLogger = true;
	protected boolean bIsEnabled = true;
	
	protected Language lang = new Language();
	protected User user = new User();
	protected UserHabilitation habilitation = new UserHabilitation();
	
	protected HttpSession session;
	protected HttpServletRequest request;
	protected HttpServletResponse response;
	
	public HashMap<String,Object> execute() throws BatchException, SecurityException, IllegalArgumentException, SQLException, NamingException, ClassNotFoundException, NoSuchFieldException, IllegalAccessException {
		return execute("local");
	}
	
	public HashMap<String,Object> execute(String selectConn) throws BatchException, SQLException, NamingException, SecurityException, IllegalArgumentException, ClassNotFoundException, NoSuchFieldException, IllegalAccessException {
		int DBTYPE = ConnectionManager.getDbType();
		Connection conn = null;
		/** pour CoinDatabaseTreatment */
		Connection connStreaming = null;
		try{
			if(selectConn.equalsIgnoreCase("local")){
	    		conn = ConnectionManager.getConnection();
	    		connStreaming = ConnectionManager.getConnection();
	    	}else{
	    		RemoteControlServiceConnection rc = BatchConnection.getRequestRemoteConnection(selectConn);
	    		rc.connect();
	    		RemoteControlServiceConnection rcS = BatchConnection.getRequestRemoteConnection(selectConn);
	    		rcS.connect();
	    		ConnectionManager.setDbType(rc.iType);
	    		conn = rc.conn;
	    		connStreaming = rcS.conn;
	    	}
			
			return execute(conn, connStreaming);
			
		}finally{
	    	ConnectionManager.closeConnection(conn);
	    	ConnectionManager.closeConnection(connStreaming);
			ConnectionManager.setDbType(DBTYPE);
	    }
	}
	public HashMap<String,Object> execute(Connection conn, Connection connStreaming) throws BatchException {
		BatchListener listener = new BatchListener(this.bUseEventLogger);
		HashMap<String,Object> map = null;
		try 
	    {
	    	listener.batchToBeExecuted(this, this._USE_CASE);
	    	map = doTraitment(conn, connStreaming,listener);
	    	listener.batchWasExecuted(this,null,this._USE_CASE);
		} 
	    catch (Exception e) 
	    {
	    	listener.batchWasExecuted(this,new BatchException(e),this._USE_CASE);
		}
	    return map;
	}
	
	public String getName(){
		return this._NAME;
	}
	
	public String getId(){
		return this._ID;
	}
	
	public boolean isEnabled(){
		return this.bIsEnabled;
	}
	
	public void setEnabled(boolean bIsEnabled){
		this.bIsEnabled = bIsEnabled;
	}
	
	public static String[] getAllConnection() throws SecurityException, IllegalArgumentException, ClassNotFoundException, NoSuchFieldException, IllegalAccessException{
	    String[] conns = JavaUtil.getFieldNames(BatchConnection.class.getName(),
			    RemoteControlServiceConnection.class,
			    null);
	    return conns;
	}
	
	public static JSONArray getJSONArrayConnection() throws SecurityException, IllegalArgumentException, ClassNotFoundException, NoSuchFieldException, IllegalAccessException, JSONException{
		String[] conns = getAllConnection();
		JSONArray items = new JSONArray();
		
		for(String sConn : conns){
			JSONObject item = new JSONObject();
			item.put("data", sConn);
			item.put("value", sConn);
			items.put(item);
		}
		
		return items;
	}
	
	public void updateFromSession(HttpSession session,HttpServletRequest request,HttpServletResponse response){
		this.lang = (Language)session.getAttribute("sessionLanguage");
		this.user = (User)session.getAttribute("sessionUser");
		this.habilitation = (UserHabilitation)session.getAttribute("sessionUserHabilitation");
		
		this.session = session;
		this.request = request;
		this.response = response;
	}
	public void updateFromAjaxSession(){
		HttpSession session = DwrSession.getSession();
		HttpServletRequest request = DwrSession.getRequest();
		HttpServletResponse response = DwrSession.getResponse();
		updateFromSession(session,request,response);
	}
	 
	
    public static JSONArray getJSONArrayBatch(int iIdObjectContext,HttpSession session,HttpServletRequest request,HttpServletResponse response) throws JSONException, InstantiationException, IllegalAccessException, NamingException, SQLException, CoinDatabaseLoadException, ClassNotFoundException, SecurityException, IllegalArgumentException, NoSuchFieldException {
        JSONArray items = new JSONArray();
        
        Class<?>[] batches = JavaUtil.getClasses(
				Configuration.getConfigurationValueMemory("mt.batch.package","mt.veolia.vfr.batch"), 
				"org.coin.batch.Batch");

		for(Class<?> cl : batches){
			Batch b = (Batch)cl.newInstance();
			if(b.isEnabled()){
				if(session!=null && request!=null && response!=null){
					b.updateFromSession(session,request,response);
				}
				
				int iIdObjectType = (Integer)JavaUtil.getPublicFieldValue(b, cl.getName(), "_OBJECT_CONTEXT");
				if(iIdObjectContext == -1){
					items.put(b.toJSONObject());
				}else if(iIdObjectContext == iIdObjectType){
					items.put(b.toJSONObject());
				}
			}
		}
        
        return items;
    }
    
    public static JSONArray getJSONArrayBatch() throws JSONException, InstantiationException, IllegalAccessException, NamingException, SQLException, CoinDatabaseLoadException, SecurityException, IllegalArgumentException, ClassNotFoundException, NoSuchFieldException {
        return getJSONArrayBatch(-1,null,null,null);
    }
}
