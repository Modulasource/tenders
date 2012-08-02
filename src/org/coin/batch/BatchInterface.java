package org.coin.batch;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.HashMap;

import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.coin.db.CoinDatabaseLoadException;
import org.json.JSONException;
import org.json.JSONObject;



public interface BatchInterface {
	
	public HashMap<String,Object> doTraitment(Connection conn, Connection connStreaming,BatchListener listener) throws Exception ;
	public void init();
	public HashMap<String,Object> execute() throws Exception ;
	public String getName();
	public void doPost(HttpServletRequest req, HttpServletResponse resp);
	public JSONObject doAjax(JSONObject json) throws Exception;
	public JSONObject toJSONObject() throws JSONException, NamingException, SQLException, InstantiationException, IllegalAccessException, CoinDatabaseLoadException;
}
