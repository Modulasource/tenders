package org.coin.util;

import java.sql.*;
import java.util.Vector;

import javax.naming.NamingException;

import mt.modula.batch.RemoteControlServiceConnection;

import org.coin.bean.conf.Configuration;
import org.coin.db.CoinDatabaseLoadException;
import org.coin.db.Column;
import org.coin.db.ConnectionManager;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

//TODO: memory with security

public class BeanGenerator {	

	public static boolean bUseSpecificConnection = true;
	public static final String CONFIG_PREFIX = "bean.generator.connection.specific.";
	
	public BeanGenerator() {
		init();
	}
	
	private static void init() {}	
	
	public static JSONArray getTableList() 
	throws SQLException, CoinDatabaseLoadException, NamingException, InstantiationException, IllegalAccessException {		
		Connection conn = getConnection();
		
		try{
			Vector<String> tables = ConnectionManager.getAllTableName(conn);
			JSONArray jsonTables = new JSONArray();
			for (String table : tables) {
				jsonTables.put(table);
			}
			return jsonTables;
		} finally {
			ConnectionManager.closeConnection(conn);
		}
		
	}

	


	public static JSONArray getFieldsFromTableName(String sTableName) 
	throws SQLException, NamingException, JSONException, CoinDatabaseLoadException, 
	InstantiationException, IllegalAccessException 
	{		
		Connection conn = getConnection();
		JSONArray columns = new JSONArray();
		try {
			Vector<Column> vColumn = ConnectionManager.getFieldsFromTableName(sTableName, conn);
			
			
			for (Column column : vColumn) {
				JSONObject obj = new JSONObject();
				obj.put("name", column.sName);
				obj.put("type", column.sDbType);
				
				obj.put("value", column.sName);
				obj.put("data", column.sName);
				columns.put(obj);	
			}
			
				
		} finally {
			ConnectionManager.closeConnection(conn);
		}
		
		return columns;
	}
	
	
	
	public static Connection getConnection() 
	throws SQLException, NamingException, InstantiationException, IllegalAccessException, CoinDatabaseLoadException
	{
		Connection conn = null;
		
		if(bUseSpecificConnection && Configuration.isTrueMemory(CONFIG_PREFIX + "use", false))
		{
			RemoteControlServiceConnection c =  
				new RemoteControlServiceConnection(
						Configuration.getConfigurationValueMemory(CONFIG_PREFIX + "url"),
						Configuration.getConfigurationValueMemory(CONFIG_PREFIX + "username"), 
						Configuration.getConfigurationValueMemory(CONFIG_PREFIX + "password"));
			
			c.iType = Configuration.getIntValueMemory(CONFIG_PREFIX + "db.type", 1);
			
			conn = c.getConnexion();
		}
		else
		{
			conn = ConnectionManager.getConnection();
		}
	
		
		return conn;
	}
	
	
}