package org.coin.db;

import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.security.NoSuchProviderException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;

import java.sql.Statement;
import java.util.Vector;

import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.StringUtils;
import org.coin.bean.User;
import org.coin.bean.conf.Configuration;
import org.coin.security.DwrSession;
import org.coin.security.SecureString;
import org.directwebremoting.annotations.RemoteMethod;
import org.directwebremoting.annotations.RemoteProxy;
import org.json.JSONArray;
import org.json.JSONObject;

@RemoteProxy
public class SearchEngine {

	protected JSONObject joQuery;
	protected JSONObject joResult;
	protected Vector<Object> vParams;
	protected int iPageOffset = 20;
	protected int iPageIndex = 0;
	protected boolean bUsePagination = true;
	
	protected static int iCountLimit = 1000;
	
	@RemoteMethod
	public static String getResults(String sJSONSearch) throws Exception {
		SearchEngine engine = new SearchEngine();
		engine.joQuery = new JSONObject(sJSONSearch);
		engine.iPageIndex = engine.joQuery.getInt("pageIndex")-1;
		engine.vParams = new Vector<Object>();
		
		if (!engine.joQuery.getBoolean("isPaginated")) engine.iPageOffset=iCountLimit;
		
		engine.run();
		return engine.joResult.toString();
	}
	
	public String getQueryString() throws InvalidKeyException, NoSuchAlgorithmException, NoSuchProviderException, NoSuchPaddingException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException, Exception{
		
		// TODO : virer le truc du _USER_, c'était débile
		
		HttpSession session = DwrSession.getSession();
    	User user = (User)session.getAttribute("sessionUser");
		
		String sSelect = "SELECT "+this.joQuery.getString("tableAlias")+".id_"+this.joQuery.getString("tableName")+",\n";
		sSelect += SecureString.getSessionPlainString(this.joQuery.getString("select"), DwrSession.getSession())+"\n";
		
		String sFrom = "FROM "+this.joQuery.getString("tableName")+" "+this.joQuery.getString("tableAlias")+"\n";
		
		String sLeftJoin = "";
		JSONArray tablesWithLeftJoin = this.joQuery.getJSONArray("tablesWithLeftJoin");
		for (int i=0; i<tablesWithLeftJoin.length(); i++){	
			JSONObject obj = tablesWithLeftJoin.getJSONObject(i);
			sLeftJoin += "LEFT JOIN " + obj.getString("jointure")+"\n";
			JSONArray values = obj.getJSONArray("values");
			for (int j=0; j<values.length(); j++){
				if (values.get(j).equals("_USER_")){
					this.vParams.add(user.getIdIndividual());
				} else {
					this.vParams.add(values.get(j));
				}
			}
		}
		
		String sInnerJoin = "";
		JSONArray tablesWithInnerJoin = this.joQuery.getJSONArray("tablesWithInnerJoin");
		for (int i=0; i<tablesWithInnerJoin.length(); i++){	
			JSONObject obj = tablesWithInnerJoin.getJSONObject(i);
			sInnerJoin += "INNER JOIN " + obj.getString("jointure")+"\n";
			JSONArray values = obj.getJSONArray("values");
			for (int j=0; j<values.length(); j++){
				if (values.get(j).equals("_USER_")){
					this.vParams.add(user.getIdIndividual());
				} else {
					this.vParams.add(values.get(j));
				}
			}
		}
		
		String sWhereClause = "";
		Vector<String> vWhereClauses = new Vector<String>();
		JSONArray whereClauses = this.joQuery.getJSONArray("whereClauses");
		for (int i=0; i<whereClauses.length(); i++){
			JSONObject obj = whereClauses.getJSONObject(i);
			vWhereClauses.add(obj.getString("clause"));
			JSONArray values = obj.getJSONArray("values");
			for (int j=0; j<values.length(); j++){
				if (values.get(j).equals("_USER_")){
					this.vParams.add(user.getIdIndividual());
				} else {
					this.vParams.add(values.get(j));
				}
			}
		}
		if (vWhereClauses.size()>0) sWhereClause = "WHERE " + StringUtils.join(vWhereClauses, " AND ")+"\n";
		
		String sGroupBy = "GROUP BY "+this.joQuery.getString("groupByClause")+"\n";
		
		String sOrderBy = "ORDER BY "+this.joQuery.getString("orderByClause")+"\n";
		
		String sLimit = "LIMIT ?,?";
		
		return sSelect+sFrom+sInnerJoin+sLeftJoin+sWhereClause+sGroupBy+sOrderBy+sLimit;
	}
	
	public void run() throws Exception{
		String sQuery = this.getQueryString();
		Connection conn =  ConnectionManager.getDataSource().getConnection();
		
		Statement stat = null;
		ResultSet rs = null;
		ResultSetMetaData rsMetaData = null;
		
		PreparedStatement ps = null;
		
		try {
			
			this.vParams.add(0);
			this.vParams.add(iCountLimit);
			
			//System.out.println(sQuery);
			//System.out.println(this.vParams.toString());
			
			ps = conn.prepareStatement(sQuery);
			CoinDatabaseAbstractBean.setAllWithSqlQueryPreparedStatement(ps, vParams);
			rs = ps.executeQuery();
			
			rsMetaData = rs.getMetaData();
			int iCount = 0;
			int iCol = rsMetaData.getColumnCount();

			JSONArray results = new JSONArray();
			
			while(rs.next()) {
				iCount++;
				if (((this.iPageOffset*this.iPageIndex)<iCount) && (iCount<=((this.iPageIndex+1) * this.iPageOffset))) {
					JSONObject entry = new JSONObject();
					for (int j=1;j<=iCol;j++){
						try{
							String sData = rs.getString(j);
							entry.put(rsMetaData.getColumnLabel(j),sData);
						}catch(Exception e){
							entry.put(rsMetaData.getColumnLabel(j),"");
						}
					}
					results.put(entry);
				}
			}
			
			this.joResult = new JSONObject();
			this.joResult.put("totalCount", iCount);
			this.joResult.put("pageOffset", this.iPageOffset);
			this.joResult.put("dataset", results);
			
			if (Configuration.isEnabledMemory("debug.session")) this.joResult.put("query", sQuery);
			
			
		} catch(Exception e){
			e.printStackTrace();
		} finally {
			ConnectionManager.closeConnection(rs,stat,conn);
		}
		
	}
	
}
