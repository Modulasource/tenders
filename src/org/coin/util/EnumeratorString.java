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
import javax.sql.DataSource;

import org.coin.db.CoinDatabaseAbstractBean;
import org.coin.db.ConnectionManager;
import org.json.JSONException;
import org.json.JSONObject;

/**
 *
 * @author david
 *
 */
public abstract class EnumeratorString extends CoinDatabaseAbstractBean{
    protected String sName;
    public String FIELD_NAME_NAME = "";
    public ResultSet rsAllLoad = null;
	
    public void init() {
        this.lId = 0;
        this.sId = "";
        this.sName = "";
        this.bAutoIncrement = false;

        this.SELECT_FIELDS_NAME_SIZE = 1;
        this.PRIMARY_KEY_TYPE = PRIMARY_KEY_TYPE_STRING;
    }
    public EnumeratorString() {
        init();
    }

    public EnumeratorString(
    		String sId,
            String sName) {
        this();
        this.sId = sId;
        this.sName = sName;
    }

	public EnumeratorString(String sId) {
	    this();
        this.sId = sId;
	}


	public void setPreparedStatement(PreparedStatement ps) throws SQLException {
		int i = 0;
		ps.setString(++i, preventStore(this.sName));
	}

	public void setFromResultSet(ResultSet rs) throws SQLException {
		int i = 0;
		this.sName = preventLoad(rs.getString(++i));
	}

	abstract protected EnumeratorString getAll_onNewItem(String sId, String sName);

	abstract protected EnumeratorString getAll_onNewItem(String sId, String sName,boolean bUseHttpPrevent);
	
	public Vector getAllOrderByIdWithPrefix(String sIdPrefix) throws NamingException, SQLException
	{
		String sWhereClause = " WHERE " + this.FIELD_ID_NAME+ " LIKE '" + sIdPrefix + "%' ";
		String sOrderByClause  = " ORDER BY " + this.FIELD_ID_NAME + " ASC";
		return getAllWithWhereAndOrderByClauses(sWhereClause, sOrderByClause) ;

	}

	public Vector getAllOrderById() throws NamingException, SQLException
	{
		String sOrderByClause  = " ORDER BY " + this.FIELD_ID_NAME + " ASC";
		return getAllWithWhereAndOrderByClauses("", sOrderByClause) ;

	}

	public Vector getAllOrderById(Connection conn) throws NamingException, SQLException
	{
		String sOrderByClause  = " ORDER BY " + this.FIELD_ID_NAME + " ASC";
		return getAllWithWhereAndOrderByClauses("", sOrderByClause, conn) ;

	}
	
	public Vector getAll() throws NamingException, SQLException
	{
		// in default, sort by Name
		String sOrderByClause  = " ORDER BY " + this.FIELD_NAME_NAME + " ASC";
		return getAllWithWhereAndOrderByClauses("", sOrderByClause) ;

	}

	
	public Vector getAllWithSQLQuery(String sSqlQuery) throws NamingException, SQLException {
		Connection conn = this.getConnection();
		try {
			return getAllWithSQLQuery(sSqlQuery, conn);
		} finally{
			this.releaseConnection(conn);	
		}
	}
	
	/*
	 * FIELD_NAME_ID, TABLE_NAME et FIELD_NAME_NAME ne sont renseignés !!
	 */
	public Vector getAllWithSQLQuery(String sSqlQuery, Connection conn) throws NamingException, SQLException 
	{
		traceQuery(sSqlQuery);
		if (conn == null ) throw new SQLException("getAllWithSQLQuery() conn is null");
		Vector<EnumeratorString> vItemList = new Vector<EnumeratorString>();

		Statement stat = null;
		ResultSet rs = null;
		try {
			stat = conn.createStatement();
			rs = stat.executeQuery(sSqlQuery);
			rsAllLoad =rs;
			while (rs.next()) {
				/**
				 * C'est normal que l'id soit le dernier champ, c'est dans la définition de abstractbean
				 */
				vItemList.addElement(
						getAll_onNewItem(
								preventLoad(rs.getString(this.SELECT_FIELDS_NAME_SIZE+1)), 
								preventLoad(rs.getString(1)),
								this.bUseHttpPrevent));
			}
			rsAllLoad = null;
		}finally {
			ConnectionManager.closeConnection(rs, stat);
		}


		return vItemList ;
	}
	/*
	 * FIELD_NAME_ID, TABLE_NAME et FIELD_NAME_NAME ne sont renseignés !!
	 */
	public Vector getAllWithWhereAndOrderByClauses(String sWhereClause, String sOrderByClause ) throws NamingException, SQLException {
		String sSQLQuery =  "SELECT " +	this.SELECT_FIELDS_NAME + "," + this.FIELD_ID_NAME
		+ " FROM " + this.TABLE_NAME
		+ sWhereClause
		+ sOrderByClause;

		return getAllWithSQLQuery(sSQLQuery );
	}

	public Vector getAllWithWhereAndOrderByClauses(String sWhereClause, String sOrderByClause ,Connection conn ) throws NamingException, SQLException {
		String sSQLQuery = "SELECT " + this.SELECT_FIELDS_NAME+ "," + this.FIELD_ID_NAME
		+ " FROM " + this.TABLE_NAME
		+ sWhereClause
		+ sOrderByClause;

		return getAllWithSQLQuery(sSQLQuery , conn );
	}
	
	/**
	 * @param id The iId to set.
	 */
	public void setId(String sId) {
		this.sId = sId;
	}
	/**
	 * @return Returns the sName.
	 */
	public String getName() {
		return this.sName;
	}
	/**
	 * @param name The sName to set.
	 */
	public void setName(String name) {
		this.sName = name;
	}

	public String getHTMLComboList() throws SQLException, NamingException
	{
		return getHTMLComboList(this.FIELD_ID_NAME ,1);
	}

	public String getHTMLComboList(String sFormSelectName) throws SQLException, NamingException
	{
		return getHTMLComboList(sFormSelectName,1);
	}

	public String getHTMLComboList(String sFormSelectName, int iSize) throws SQLException, NamingException
	{
		Vector vEnum = getAllOrderById();
		return  getHTMLComboList( sFormSelectName, iSize, vEnum) ;
	}
	
	public String getHTMLComboList(String sFormSelectName, int iSize, Vector vEnum) throws SQLException, NamingException
	{
		return getHTMLComboList(sFormSelectName, iSize, vEnum, false);
	}
	
	public String getHTMLComboList(String sFormSelectName, int iSize, Vector vEnum,boolean bAddUndefined) throws SQLException, NamingException
	{
		String sListe = "";
		String sSelected = "selected=\"selected\"";

		sListe += "<select name=\""+ sFormSelectName +"\" id=\""+ sFormSelectName +"\" size=\""+iSize+"\">\n";
		if(bAddUndefined){
			sListe += "<option value=\"\" "
			+ ((this.sId.equalsIgnoreCase(""))?sSelected:"") +">select</option>\n";
		}
		for (int i = 0; i < vEnum.size(); i++)
		{
			EnumeratorString oEnum = (EnumeratorString)vEnum.get(i);
			sListe += "<option value=\""+ oEnum.getIdString() +"\" "
			+ ((oEnum.getIdString().equalsIgnoreCase(this.sId))?sSelected:"") +">"+ oEnum.getName() +"</option>\n";
		}
		sListe += "</select>";

		return sListe;
	}


	@SuppressWarnings("unchecked")
	public <T>Vector<T> getAllWithSqlQuery(String sSqlQuery) throws NamingException, SQLException
	{
		DataSource ds = org.coin.db.ConnectionManager.getDataSource();
        Vector<EnumeratorString> vItemList = new Vector<EnumeratorString>();
		Connection conn = null;
		Statement stat = null;
		ResultSet rs = null;
		
		traceQuery(sSqlQuery);
		 

		try {
			conn = ds.getConnection();
			stat = conn.createStatement();
			rs = stat.executeQuery(sSqlQuery);
			rsAllLoad =rs;

			while (rs.next()) {
				/**
				 * C'est normal que l'id soit le dernier champ, c'est dans la définition de abstractbean
				 */
				vItemList.addElement(getAll_onNewItem(
						preventLoad(rs.getString(this.SELECT_FIELDS_NAME_SIZE+1)), 
						preventLoad(rs.getString(1)),
						this.bUseHttpPrevent));
			}
			rsAllLoad =rs;
		}finally {
			ConnectionManager.closeConnection(rs,stat,conn);
		}
		
		return (Vector<T>) vItemList;
	}

	public void setFromForm(HttpServletRequest request, String sFormPrefix) throws SQLException, NamingException {
		this.sName= request.getParameter(sFormPrefix + "sName");
	}
	
    public JSONObject toJSONObject() throws JSONException {
		JSONObject item = new JSONObject();
		item.put("sId", this.sId);
		item.put("sName", this.getName());
		
		return item;
	}
    
    public void setFromJSONObject(JSONObject item) throws Exception {
		try {
			this.sName = item.getString("sName");
		} catch(Exception e){}
	}
}
