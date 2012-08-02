/****************************************************************************
Studio Matamore - France 2004
Contact : studio@matamore.com - http://www.matamore.com
****************************************************************************/


package org.coin.util;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Vector;

import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;

import org.coin.db.CoinDatabaseAbstractBean;
import org.coin.db.ConnectionManager;
import org.json.JSONException;
import org.json.JSONObject;
import org.w3c.dom.Node;

public abstract class Enumerator extends CoinDatabaseAbstractBean {
	private static final long serialVersionUID = 1L;
	
	protected String sName;
	public String FIELD_NAME_NAME = "";

	
    public void init() {
        this.lId = 0;
        this.sName = "";
        
        this.SELECT_FIELDS_NAME_SIZE = 1; 
    }

	public void setPreparedStatement (PreparedStatement ps ) throws SQLException 
	{
		int i = 0;
		ps.setString(++i, preventStore(this.sName));
	}
	
	public void setFromResultSet(ResultSet rs) throws SQLException 
	{
		int i = 0;
		this.sName = preventLoad(rs.getString(++i));
	}
    

    public Enumerator() {
        init();
    }
    
    public Enumerator(
    		int iId, 
            String sName) {
        
    	this();
    	this.lId = iId;
        this.sName = sName;
    }
        
	public Enumerator(int iId) {
	    this();
	    this.lId = iId;
	}
	public Enumerator(long lId) {
	    this();
	    this.lId = lId;
	}
	
	public Enumerator(String sName) {
	    this();
        this.sName = sName;
	}
	
	@Override
	public String getName() {
		return this.sName;
	}
	
	public void setName(String sName) {
		this.sName = sName;
	}
	
	abstract protected Enumerator getAll_onNewItem(int iId, String sName);
	
	abstract protected Enumerator getAll_onNewItem(int iId, String sName,boolean bUseHttpPrevent);


	public <T>Vector<T> getAllOrderById() throws SQLException, NamingException
	{
		String sOrderByClause  = " ORDER BY " + this.FIELD_ID_NAME + " ASC";
		return getAllWithWhereAndOrderByClauses("", sOrderByClause) ;
		
	}
	
	public <T>Vector<T> getAll() throws SQLException, NamingException
	{
		// in default, sort by Name  
		String sOrderByClause  = " ORDER BY " + this.FIELD_NAME_NAME + " ASC";
		return getAllWithWhereAndOrderByClauses("", sOrderByClause) ;
		
	}

	/*
	 * FIELD_NAME_ID, TABLE_NAME et FIELD_NAME_NAME ne sont renseignés !!
	 * à voir comment modifier cette procédure un jour ...
	 */
	public <T>Vector<T> getAllWithWhereAndOrderByClauses(String sWhereClause, String sOrderByClause ) throws SQLException, NamingException {
		
		// ajouté ici pour plus de sécurité
		this.SELECT_FIELDS_NAME = " " + this.FIELD_NAME_NAME; 
		
		String sSQLQuery = 	"SELECT " 
			+ this.FIELD_NAME_NAME + "," + this.FIELD_ID_NAME  
			+ " FROM " + this.TABLE_NAME
			+ sWhereClause
			+ sOrderByClause;

		return getAllWithSqlQuery(sSQLQuery );
		
	}

	/*
	 * FIELD_NAME_ID, TABLE_NAME et FIELD_NAME_NAME ne sont renseignés !!
	 * à voir comment modifier cette procédure un jour ...
	 */
	@SuppressWarnings("unchecked")
	public <T>Vector<T> getAllWithSqlQuery(String sSqlquery) 
	throws NamingException, SQLException 
	//public  Vector getAllWithSQLQuery(String sSQLQuery) throws SQLException, NamingException 
	{
		Vector<Enumerator> vItemList = new Vector<Enumerator>();
		Connection conn = null;
		Statement stat = null;
		ResultSet rs = null;
		
		traceQuery(sSqlquery);
		
		try {
			conn = this.getConnection();
			stat = conn.createStatement();
			rs = stat.executeQuery(sSqlquery);
			
			while (rs.next()) {	
				Enumerator item = getAll_onNewItem(
						rs.getInt(2), 
						preventLoad(
							rs.getString(1)));
				
				item.bPropagateEmbeddedConnection=this.bPropagateEmbeddedConnection;
				item.bUseEmbeddedConnection=this.bUseEmbeddedConnection;
				item.bUseLocalization=this.bUseLocalization;
				item.connEmbeddedConnection=this.connEmbeddedConnection;
				item.iAbstractBeanIdLanguage=this.iAbstractBeanIdLanguage;
				item.iAbstractBeanIdObjectType=this.iAbstractBeanIdObjectType;
				
				vItemList.addElement(item);
			}
		}
		catch (SQLException e) {
			throw e;
		} finally{
			ConnectionManager.closeConnection(rs,stat);
			this.releaseConnection(conn);
		}
		
		return (Vector<T>) vItemList;
	}
	
	/**
	 * @param sObjet - the name of the node
	 */
	public String serialize(String sObjet)
	{
		 String sEnumerator 
		 	= "<"+sObjet+">\n"
		 	+ "<id>" +  this.lId + "</id>\n" 
		 	+ "<name>" +  this.sName + "</name>\n" 
			+ "</"+sObjet+">\n";
		 
		 return sEnumerator;
	
	}
	
	public void deserialize (Node node) throws Exception{
		try{
			this.lId = Integer.parseInt(BasicDom.getChildNodeValueByNodeName(node, "id"));
		}
		catch(Exception e){}
		try{
			this.sName = BasicDom.getChildNodeValueByNodeName(node, "name");
		}
		catch(Exception e){}
	}

	public void synchroniser(Node node) throws Exception{
		deserialize(node);
		if(this.lId !=-1) 
		{
			try {
				store();
			}
			catch(Exception e){
				create();
				e.getMessage();
			}
		}
		else create();
		
	}

	
	public void setFromForm(HttpServletRequest request, String sFormPrefix) {
		// TODO Auto-generated method stub
		
	}
	
	public JSONObject toJSONObject() throws JSONException {
		JSONObject item = new JSONObject();
		item.put("lId", this.lId);
		item.put("sName", this.sName);
		
		item.put("data", this.lId);
		item.put("value", this.sName);
		
		return item;
	}
	
	public void setFromJSONObject(JSONObject item) throws Exception {
		try {
			this.sName = item.getString("sLibelle");
		} catch(Exception e){}
	}
}
