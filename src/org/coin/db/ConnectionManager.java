package org.coin.db;

import javax.sql.*;
import javax.naming.*;

import mt.modula.batch.RemoteControlServiceConnection;

import org.json.*;

import java.sql.*;
import java.io.*;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Vector;

public class ConnectionManager implements Serializable{

	private static final long serialVersionUID = 1L;
	public final static String JNDI_DB_NAME = "jdbc/coin";
	public final static String JNDI_DB_TYPE = "jdbc/type";
	
	public final static int DBTYPE_MYSQL 		= 1;
	public final static int DBTYPE_ORACLE 		= 2;
	public final static int DBTYPE_SQL_SERVER 	= 3;
	public final static int DBTYPE_POSTGRES 	= 4;
	
	private static int DBTYPE = 0;
	
	/**
	 * Return the database type
	 * @return
	 * @throws NamingException
	 */
	public static int getDbType() {
		if( DBTYPE == 0 ){
			try{
				Context initCtx = new InitialContext();
				Context envCtx = (Context) initCtx.lookup("java:comp/env");
				String sDbType = (String) envCtx.lookup(JNDI_DB_TYPE);
				if( "sqlserver".equalsIgnoreCase(sDbType) ){
					DBTYPE = DBTYPE_SQL_SERVER;
				} else if( "mysql".equalsIgnoreCase(sDbType) ){
					DBTYPE = DBTYPE_MYSQL;
				} else if( "oracle".equalsIgnoreCase(sDbType) ){
					DBTYPE = DBTYPE_ORACLE;
				} else if( "postgresql".equalsIgnoreCase(sDbType) ){
					DBTYPE = DBTYPE_POSTGRES;
				} else {
					DBTYPE = DBTYPE_MYSQL;
					System.out.println("Warning: Value of env. variable : "
							+JNDI_DB_TYPE+" is unknown, default value "+DBTYPE+" will be used.");
				}
			} catch(NamingException ne){
				DBTYPE = DBTYPE_MYSQL;
				System.out.println("Warning: Env. variable is not defined : "
						+JNDI_DB_TYPE+", default value "+DBTYPE+" will be used.");
			}
		}
		return DBTYPE;
	}
	
	/**
	 * Set the database type
	 * @param iDbType
	 */
	public static void setDbType(int iDbType){
		DBTYPE = iDbType;
	}
	
	/**
	 * Méthode permettant d'obtenir un DataSource connecté à la base de données spécifiée
	 * @throws NamingException 
	 */
	public static final DataSource getDataSource() throws NamingException {
		Context initCtx = new InitialContext();
		Context envCtx = (Context) initCtx.lookup("java:comp/env");
		DataSource ds = (DataSource) envCtx.lookup(JNDI_DB_NAME );
		
		return ds;
	}
	
	public static final Connection getConnection() throws NamingException, SQLException {
		
		return getDataSource().getConnection();
	}
	
	
	public static final Statement createStatementForAutoIncrement(Connection conn) throws SQLException, NamingException
	{
		return conn.createStatement(java.sql.ResultSet.TYPE_FORWARD_ONLY,
	            java.sql.ResultSet.CONCUR_UPDATABLE);
	}

	
	public static final Statement createStatementForAutoIncrement() throws SQLException, NamingException
	{
		Connection conn = null;
		
		conn = ConnectionManager.getDataSource().getConnection();
		return createStatementForAutoIncrement(conn);
	}

	public static final int executeUpdateAndGetLastInsertId(Statement stat, PreparedStatement ps, String sSqlQuery, boolean bCloseConnection) throws SQLException, CoinDatabaseCreateException
	{
		Connection conn = stat.getConnection();
		ResultSet rs = null;
		
		ps.executeUpdate();
		ps.close();
		
	    rs = stat.executeQuery("SELECT LAST_INSERT_ID()");
	    if (rs.next()) 
	    {
	        int iVal = rs.getInt(1);
			if(rs != null) rs.close();
			if(stat != null) stat.close();
			if (bCloseConnection && conn != null) conn.close();
			return iVal;
	    } 
	    if(bCloseConnection) {
	    	closeConnection(rs, stat, conn);
	    }else{
	    	closeConnection(rs, stat);
	    }

	    throw new CoinDatabaseCreateException(sSqlQuery);
	    
	}

	// TODO : vérifier que les mtd appelantes ont besoin de fermer la connexion
	public static final int executeUpdateAndGetLastInsertId(Statement stat, PreparedStatement ps, String sSqlQuery) throws SQLException, CoinDatabaseCreateException
	{
			return executeUpdateAndGetLastInsertId(stat, ps, sSqlQuery, true);
	}

	public static void emptyTables(
			String sAllTableName,
			Connection conn)
	throws SQLException 
	{
		String[]  arr = sAllTableName.split(",");
		for (String sTableName : arr) {
			emptyTable(sTableName, conn);
		}
	}
	
	public static void emptyTable(
			String sTableName,
			Connection conn)
	throws SQLException 
	{
		String sSqlQuery = "DELETE FROM " + sTableName;
		ConnectionManager.executeUpdate(sSqlQuery, conn);
	}

	
	public static final int executeUpdate(String sSqlQuery) throws SQLException, NamingException
	{
		CoinDatabaseAbstractBean.traceQueryStatic(sSqlQuery);

		Connection conn = null;
		int ret = -1;
		try {
			conn =  getConnection();
			ret = executeUpdate(sSqlQuery, conn);
		} finally {
			closeConnection(conn);
		}
		return ret;
	}
	
	public static final int executeUpdate(String sSqlQuery, Connection conn) throws SQLException
	{
		return executeUpdate(sSqlQuery, null, conn);
	}
	
	
	public static final int executeUpdate(
			String sSqlQuery,
			Vector<Object> vParams,
			Connection conn) throws SQLException
	{
		CoinDatabaseAbstractBean.traceQueryStatic(sSqlQuery);
		
		PreparedStatement ps = null;
		try {
			ps = conn.prepareStatement(sSqlQuery);
			CoinDatabaseAbstractBean.setAllWithSqlQueryPreparedStatement (ps, vParams);
			
			return ps.executeUpdate();//(sSqlQuery);
		} catch (SQLException e) { 
			closeConnection(ps);
			throw e;
		}
	}


	/**
	 * ATTENTION : Il faut garder la connexion ouverte
	 * @param sSqlQuery
	 * @return
	 * @throws SQLException
	 * @throws NamingException
	 */
	public static final ResultSet executeQuery(String sSqlQuery) throws SQLException, NamingException 
	{
		Connection conn = null;
		try {
			conn = getConnection();
			return executeQuery(sSqlQuery,conn);
		} catch (SQLException e) { 
			closeConnection(conn);
			throw e;
		}
		
	}
	public static final ResultSet executeQuery(
			String sSqlQuery,
			Connection conn) 
	throws SQLException
	{
		return executeQuery(sSqlQuery, null, conn);
	}
	/**
	 * ATTENTION : Il faut garder le Statement ouvert
	 * @param sSqlQuery
	 * @param conn
	 * @return
	 * @throws SQLException
	 */
	public static final ResultSet executeQuery(
			String sSqlQuery,
			Vector<Object> vParams,
			Connection conn) throws SQLException
	{
		CoinDatabaseAbstractBean.traceQueryStatic(sSqlQuery);
		
		PreparedStatement ps = null;
		try {
			ps = conn.prepareStatement(sSqlQuery);
			CoinDatabaseAbstractBean.setAllWithSqlQueryPreparedStatement (ps, vParams);
			
			return ps.executeQuery( );
		} catch (SQLException e) { 
			closeConnection(ps);
			throw e;
		}
	}

	
	public static final void closeConnection(ResultSet rs, Statement stat, Connection conn, PreparedStatement ps) throws SQLException
	{
		if(rs != null ) rs.close();
		if(stat != null  ) stat.close();
		if(conn != null && !conn.isClosed()) conn.close();
		if(ps != null) ps.close();
	}
	
	public static final void closeConnection(ResultSet rs, Statement stat, PreparedStatement ps) throws SQLException
	{
		if(rs != null) rs.close();
		if(stat != null) stat.close();
		if(ps != null) ps.close();
	}

	public static final void closeConnection(Statement stat, Connection conn, PreparedStatement ps) throws SQLException
	{
		if(stat != null) stat.close();
		if(conn != null && !conn.isClosed()) conn.close();
		if(ps != null) ps.close();
	}
	
	public static final void closeConnection(ResultSet rs, Statement stat, Connection conn) throws SQLException
	{
		if(rs != null) rs.close();
		if(stat != null) stat.close();
		if(conn != null && !conn.isClosed()) conn.close();
	}

	public static final void closeConnection(ResultSet rs, Statement stat) throws SQLException
	{
		if(rs != null) rs.close();
		if(stat != null) stat.close();
	}
	
	public static final void closeConnection(Statement stat, Connection conn) throws SQLException
	{
		if(stat != null) stat.close();
		if(conn != null && !conn.isClosed()) conn.close();
	}
	
	public static final void closeConnection(Statement stat) throws SQLException
	{
		if(stat != null) stat.close();
	}
	
	public static final void closeConnection(Connection conn, PreparedStatement ps) throws SQLException
	{
		if(conn != null && !conn.isClosed()) conn.close();
		if(ps != null) ps.close();
	}

	public static final void closeConnection(PreparedStatement ps) throws SQLException
	{
		if(ps != null) ps.close();
	}
	
	public static final void closeConnection(ResultSet rs) throws SQLException
	{
		if(rs != null) {
			rs.close();
			Statement stat = rs.getStatement() ;
			if(stat != null) {
				stat.close();
				Connection conn = stat.getConnection();
				if(conn != null && !conn.isClosed()) conn.close();
			}
		}
	}

	public static final void closeConnection(Connection conn) throws SQLException
	{
		if(conn != null && !conn.isClosed()) conn.close();
	}

	public static final int getCountInt(String sSqlQuery)
	throws NamingException, SQLException, CoinDatabaseLoadException 
	{
		Connection conn = null;
		try {
			conn = getConnection();
			return getCountInt(sSqlQuery,conn);
		} finally {
			closeConnection(conn);
		}
		
	}
	
	public static final int getCountInt(
			CoinDatabaseAbstractBean item,
			String sWhereClause) 
	throws NamingException, SQLException, CoinDatabaseLoadException 
	{
		Connection conn = null;
		try {
			conn = getConnection();
			return getCountInt("SELECT COUNT(*) FROM " + item.TABLE_NAME + " " + sWhereClause,conn);
		} finally {
			closeConnection(conn);
		}
		
	}
	
	
	public static final int getCountInt(String sSqlQuery, Connection conn)
	throws NamingException, SQLException, CoinDatabaseLoadException 
	{
		return getCountInt(sSqlQuery, null, conn);
	}
	
	public static final int getCountInt(
			String sSqlQuery, 
			Vector<Object> vParams,
			Connection conn) 
	throws NamingException, SQLException, CoinDatabaseLoadException 
	{
		ResultSet rs = null;
		Statement stat = null;
	
		try {
			rs = executeQuery(sSqlQuery , vParams, conn);
			stat = rs.getStatement();
			if(rs.next()) {
				return rs.getInt(1);
			}
				throw new CoinDatabaseLoadException("", sSqlQuery);
		} finally {
			closeConnection(rs,stat);
		}
	}

	
	public static final long getLongValueFromSqlQuery(
			String sSqlQuery, 
			Vector<Object> vParams) 
	throws NamingException, SQLException, CoinDatabaseLoadException 
	{
		Connection conn = null;
		try {
			conn = getConnection();
			return getLongValueFromSqlQuery(sSqlQuery, vParams, conn);
		} finally {
			closeConnection(conn);
		}
	}
	
	public static final long getLongValueFromSqlQuery(
			String sSqlQuery, 
			Connection conn) 
	throws NamingException, SQLException, CoinDatabaseLoadException 
	{
		return getLongValueFromSqlQuery(sSqlQuery, null, conn);
	}
	
	public static final long getLongValueFromSqlQuery(
			String sSqlQuery, 
			Vector<Object> vParams,
			Connection conn) 
	throws NamingException, SQLException, CoinDatabaseLoadException 
	{
		ResultSet rs = null;
		Statement stat = null;
	
		try {
			rs = executeQuery(sSqlQuery , vParams, conn);
			stat = rs.getStatement();
			if(rs.next()) {
				return rs.getLong(1);
			}
			throw new CoinDatabaseLoadException("", sSqlQuery);
		} finally {
			closeConnection(rs,stat);
		}
	}
	
	public static final byte[] getBytesValueFromSqlQuery(
			String sSqlQuery, 
			Connection conn) 
	throws NamingException, SQLException, CoinDatabaseLoadException 
	{
		return getBytesValueFromSqlQuery(sSqlQuery, null, conn);
	}
	
	
	public static final byte[] getBytesValueFromSqlQuery(
			String sSqlQuery, 
			Vector<Object> vParams,
			Connection conn) 
	throws NamingException, SQLException, CoinDatabaseLoadException 
	{
		ResultSet rs = null;
		Statement stat = null;
	
		try {
			rs = executeQuery(sSqlQuery , vParams, conn);
			stat = rs.getStatement();
			if(rs.next()) {
				return rs.getBytes(1);
			}
			throw new CoinDatabaseLoadException("", sSqlQuery);
		} finally {
			closeConnection(rs,stat);
		}
	}
	
	
	
	public static final String getStringValueFromSqlQuery(
			String sSqlQuery, 
			Connection conn) 
	throws NamingException, SQLException, CoinDatabaseLoadException 
	{
		return getStringValueFromSqlQuery(sSqlQuery, null, conn);
	}
	
	
	public static final String getStringValueFromSqlQuery(
			String sSqlQuery, 
			Vector<Object> vParams)
	throws NamingException, SQLException, CoinDatabaseLoadException 
	{
		Connection conn = null;
		try {
			conn = getConnection();
			return getStringValueFromSqlQuery(sSqlQuery, vParams, conn);
		} finally {
			closeConnection(conn);
		}
		
	}
	
	public static final String getStringValueFromSqlQuery(
			String sSqlQuery, 
			Vector<Object> vParams,
			Connection conn) 
	throws NamingException, SQLException, CoinDatabaseLoadException 
	{
		ResultSet rs = null;
		Statement stat = null;
	
		try {
			rs = executeQuery(sSqlQuery , vParams, conn);
			stat = rs.getStatement();
			if(rs.next()) {
				return rs.getString(1);
			}
			throw new CoinDatabaseLoadException("", sSqlQuery);
		} finally {
			closeConnection(rs,stat);
		}
	}
	
	
	public static void uploadInputStream(String sSqlQuery, InputStream is)
	throws SQLException, NamingException 
	{
		Connection conn = null;
		try {
			conn = getConnection();
			uploadInputStream(sSqlQuery, is,conn);
		} finally {
			closeConnection(conn);
		} 
		
	}
	
	public static void uploadInputStream(String sSqlQuery, InputStream is, Connection conn) 
	throws SQLException
	{
		PreparedStatement ps = null;
		CoinDatabaseAbstractBean.traceQueryStatic(sSqlQuery);

		
		try {
			ps = conn.prepareStatement(sSqlQuery);
			ps.setBinaryStream(1, is, -1);
			ps.executeUpdate();
		} finally {
			closeConnection(ps);
		}
	}
	

	public static void uploadBytes(String sSqlQuery, byte[] bytes, Vector<Object> vParams,  Connection conn) 
	throws SQLException
	{
		PreparedStatement ps = null;
		CoinDatabaseAbstractBean.traceQueryStatic(sSqlQuery);

		try {
			ps = conn.prepareStatement(sSqlQuery);
			ps.setBytes(1, bytes);
			CoinDatabaseAbstractBean.setAllWithSqlQueryPreparedStatement (ps, 1, vParams);
			ps.executeUpdate();
		} finally {
			closeConnection(ps);
		}
	}
	
	
	

	
	
	public static InputStream downloadInputStream(String sSqlQuery)
	throws SQLException, NamingException, CoinDatabaseLoadException 
	{
		Connection conn = null;
		try {
			conn = getConnection();
			return downloadInputStream(sSqlQuery,conn);
		} finally {
			closeConnection(conn);
		} 
		
	}
	
	public static InputStreamDownloader getInputStreamDownloader(
			String sSqlQuery, 
			Connection conn) 
	throws CoinDatabaseLoadException, NamingException, SQLException
	{
		InputStreamDownloader isd = new InputStreamDownloader(sSqlQuery, conn);
		isd.prepareInputStream();
		return isd;
	}
	
	public static InputStream downloadInputStream(String sSqlQuery, Connection conn)
	throws NamingException, SQLException, CoinDatabaseLoadException 
	{
		InputStream file = null;
		ResultSet rs = null;

		CoinDatabaseAbstractBean.traceQueryStatic(sSqlQuery);
		Statement stat = null;
		try {
			rs = executeQuery(sSqlQuery , conn);
			stat =  rs.getStatement();
			if(rs.next()) {
				//Blob blob = rs.getBlob(1);
				//file = blob.getBinaryStream();
				file = rs.getBinaryStream(1);
				
			}
			else
			{
				throw new CoinDatabaseLoadException("", sSqlQuery);
			}
		} catch (OutOfMemoryError e){
			throw e;
		} finally {
			closeConnection(rs,stat);
		} 
		
		return file;
	}

	public static String computeWhereClause(
			String[] sarrField,
			String sValueList,
			String sOperatorField) 
	{
		return computeWhereClause(
				sarrField, 
				sValueList, 
				"OR", 
				sOperatorField);
	}
	
	public static String computeWhereClause(
			String[] sarrField,
			String sValueList,
			String sOperatorFieldList,
			String sOperatorField) 
	{
		boolean bFirstClause = true;
        boolean bFirstFieldClause = true;
        String sWhereClause = "";
        
        for(String reqFieldName : sarrField )
        {
            String sOperatorFieldListTmp = sOperatorFieldList ;    
            if(bFirstFieldClause )
            {
            	sOperatorFieldListTmp = "" ;    
            	bFirstFieldClause = false;
            }
            
            sWhereClause 
                += "\n " + sOperatorFieldListTmp + " ( ";
            
            bFirstClause = true;
        	for(String str : sValueList.split(" ") )
	        {
        		String sOperatorFieldTmp = sOperatorField;
                if(bFirstClause )
                {
                	sOperatorFieldTmp = "" ;    
                	bFirstClause = false;
                }
                sWhereClause 
                    += "\n " 
                    + sOperatorFieldTmp 
                    + " " + reqFieldName + " LIKE '%" + str +  "%' ";
	        }
        	sWhereClause 
                += " )";
		}		
        
        
        return sWhereClause;
	}

	
	public static Vector<String[]>  getVectorArrayStringResult(
			String sSqlQuery,
			Connection conn) throws SQLException
	{
		return getVectorArrayStringResult(sSqlQuery, -1, conn);
	}
	
	/**
	 * renvoie un tableau de String correspondant aux valeurs de la requête
	 * @param sSqlQuery
	 * @param conn
	 * @return
	 * @throws SQLException
	 */
	public static Vector<String[]>  getVectorArrayStringResult(
			String sSqlQuery,
			long lMaxRowFetched,
			Connection conn) throws SQLException
	{
		Vector<String[]> vs = new Vector<String[]> ();
		ResultSet rs = null;
		try {
			rs = executeQuery(sSqlQuery, conn);
			ResultSetMetaData rsmd = rs.getMetaData();
			
			
			long lRowFetched = 0;
			
			while (rs.next() )
			{
				if(lMaxRowFetched != -1)
				{
					if(lRowFetched > lMaxRowFetched)
						break;
				}
				lRowFetched++;
				String[] sarr = new String[ rsmd.getColumnCount() ];
					
				for (int i = 0; i < sarr.length; i++) {
					sarr[i] = rs.getString(i+1);
				}
				
				vs.add(sarr);
			}
			return vs;
		} finally {
			if(rs != null) 
				closeConnection(rs, rs.getStatement());
		} 
	}
	public static void displayVectorArrayLongResult(
			Vector<long[]> arr) 
	{
		for (long[] ls : arr) {
			for (long l : ls) {
				System.out.print(" " + l);
			}
			System.out.println();
		}
	}

	/**
	 * get only the first column 
	 * 
	 * @param sSqlQuery
	 * @param vParams
	 * @param lMaxRowFetched
	 * @param conn
	 * @return
	 * @throws SQLException
	 */
	public static long[] getArrayLongResult(
			String sSqlQuery,
			Vector<Object> vParams,
			long lMaxRowFetched,
			Connection conn)
	throws SQLException
	{
		Vector<long[]> l =
			getVectorArrayLongResult(
					sSqlQuery, 
					vParams, 
					lMaxRowFetched, 
					conn);
		
		long[] larr = new long[l.size()];
		int i = 0;
		for (long[] ms : l) {
			larr[i] = ms[0];
			i++;
		}
		
	
		return larr;
	}
	
	public static Vector<long[]>  getVectorArrayLongResult(
			String sSqlQuery,
			Vector<Object> vParams,
			long lMaxRowFetched,
			Connection conn) 
	throws SQLException
	{
		Vector<long[]> vs = new Vector<long[]> ();
		ResultSet rs = null;
		try {
			rs = executeQuery(sSqlQuery, vParams, conn);
			ResultSetMetaData rsmd = rs.getMetaData();
			
			
			long lRowFetched = 0;
			
			while (rs.next() )
			{
				if(lMaxRowFetched != -1)
				{
					if(lRowFetched > lMaxRowFetched)
						break;
				}
				lRowFetched++;
				long[] sarr = new long[ rsmd.getColumnCount() ];
					
				for (int i = 0; i < sarr.length; i++) {
					sarr[i] = rs.getLong(i+1);
				}
				
				vs.add(sarr);
			}
			return vs;
		} finally {
			if(rs != null) 
				closeConnection(rs, rs.getStatement());
		} 
	}
	
	
	/**
	 * renvoie un tableau de String correspondant aux valeurs de la requête
	 * @param sSqlQuery
	 * @param conn
	 * @return
	 * @throws SQLException
	 */
	public static Vector<String>  getVectorStringResult(
			String sSqlQuery,
			Connection conn) throws SQLException
	{
		Vector<String> vs = new Vector<String> ();
		ResultSet rs = null;
		try {
			rs = executeQuery(sSqlQuery, conn);
			while (rs.next() )
			{
				vs.add(rs.getString(1));
			}
			return vs;
		} finally {
			if(rs != null) 
				closeConnection(rs, rs.getStatement());
		} 
	}
	
	
	public static Vector<Long>  getVectorLongResult(
			String sSqlQuery,
			Connection conn) throws SQLException
	{
		Vector<Long> vs = new Vector<Long> ();
		ResultSet rs = null;
		try {
			rs = executeQuery(sSqlQuery, conn);
			while (rs.next() )
			{
				vs.add(rs.getLong(1));
			}
			return vs;
		} finally {
			if(rs != null) 
				closeConnection(rs, rs.getStatement());
		} 
	}
	
	
	
	public static String getDatabaseVersion(Connection conn) throws SQLException{
		DatabaseMetaData meta = conn.getMetaData();
		return meta.getDatabaseProductVersion();
	}
	
	public static int getDatabaseMajorVersion(Connection conn) throws SQLException{
		DatabaseMetaData meta = conn.getMetaData();
		return meta.getDatabaseMajorVersion();
	}
	
	public static JSONArray getJSONArrayFromResultSet(ResultSet rs) throws SQLException, JSONException {
		ResultSetMetaData rsMetaData = rs.getMetaData();
    	int iCol = rsMetaData.getColumnCount();
    	
    	JSONArray items = new JSONArray();
    	while(rs.next()) {
    		JSONObject item = new JSONObject();
    		for (int j=1;j<=iCol;j++){
    			item.put(rsMetaData.getColumnName(j), rs.getString(j));
			}
    		items.put(item);
    	}
    	
    	return items;
	}
	
	public static InputStream executeObjectBinarySQL(
			String sSQLQuery)
	throws SQLException, NamingException 
	{
		Connection conn = ConnectionManager.getConnection();

		try{
			return executeObjectBinarySQL(sSQLQuery, conn);
		} finally {
			ConnectionManager.closeConnection(conn);
		}

	}

	
	public static InputStream executeObjectBinarySQL(
			String sSQLQuery,
			Connection conn)
	throws SQLException, NamingException {

		InputStream is= null;
		
		Statement stat = null;
		ResultSet rs = null;
		try {
			stat = conn.createStatement();
			stat = (stat.getConnection()).createStatement();
			rs = stat.executeQuery(sSQLQuery);
			ResultSetMetaData meta = rs.getMetaData();
			while(rs.next())
			{
				switch(meta.getColumnType(1))
				{
				case Types.LONGVARBINARY:
					is = rs.getBinaryStream(1);
					break;
				}
			}
		}
		finally {
			ConnectionManager.closeConnection(rs,stat);
		}
		
		return is;
	}

	
	

	public static ArrayList<String> executeSQLSelectLongVarBinary(
			String sSQLQuery)
	throws SQLException, NamingException 
	{
		Connection conn = ConnectionManager.getConnection();

		try{
			return executeSQLSelectLongVarBinary(sSQLQuery, conn);
		} finally {
			ConnectionManager.closeConnection(conn);
		}

	}

	public static ArrayList<String> executeSQLSelectLongVarBinary(
			String sSQLQuery,
			Connection conn) 
	throws SQLException, NamingException 
	{
		ArrayList<String> aReturn = new ArrayList<String>();

		Statement stat = null;
		ResultSet rs = null;
		try {
			stat = conn.createStatement();
			stat = (stat.getConnection()).createStatement();
			rs = stat.executeQuery(sSQLQuery);
			ResultSetMetaData meta = rs.getMetaData();
			//int iNbCols = meta.getColumnCount();
			while(rs.next())
			{
				switch(meta.getColumnType(1))
				{
				case Types.LONGVARBINARY:
					try{aReturn.add(rs.getString(1));}
					catch(Exception e){}
					break;

				default:
					aReturn.add(rs.getString(1));	
				}
			}
		}
		finally {
			ConnectionManager.closeConnection(rs,stat);
		}


		return aReturn;
	}
	
	public static boolean existsTable(
			String sTableName,
			Connection conn) 
	throws SQLException 
	{		
		String sTableNameLowerCase = sTableName.toLowerCase();
		Vector<String> tables = getAllTableName(conn);
		return existsTable(sTableNameLowerCase, tables);
	}

	public static boolean existsTable(
			String sTableName,
			Vector<String> tables) 
	{
		for (String table : tables) {
			if(table.toLowerCase().equals(sTableName)) return true;
		}
		
		return false;
	}
	
	public static boolean existsTable(
			Table table,
			Vector<Table> tables) 
	{
		for (Table tableTmp : tables) {
			if(tableTmp.sName.equalsIgnoreCase(table.sName)) return true;
		}
		
		return false;
	}
	
	public static Table getTable(
			Table table,
			Vector<Table> tables) 
	{
		for (Table tableTmp : tables) {
			if(tableTmp.sName.equalsIgnoreCase(table.sName)) {
				return tableTmp;
			}
		}
		
		return null;
	}

	public static Vector<String> getAllTableName(
			Connection conn) 
	throws SQLException 
	{
		return getAllTableName(-1, conn);
	}
	
	public static Vector<String> getAllTableName(
			int bLimit,
			Connection conn) 
	throws SQLException 
	{		
		Statement stat = null;
		ResultSet rs = null;
		stat = conn.createStatement();
		rs = stat.executeQuery("show tables");
		Vector<String> tables = new Vector<String>();

		int iCut = -1;
		if(bLimit != -1) iCut = bLimit;
		
		
		while(rs.next()) {
			tables.add(rs.getString(1));
			if(iCut != -1 && (--iCut == 0) ) break;
		} 
		ConnectionManager.closeConnection(rs,stat);
		return tables;
	}
		
	/*** Method add by Miguel ***/
	public static Vector<String> getAllTableNameFromInformationSchema(
			int bLimit		,
			String sSchema	,
			Connection conn) 
	throws SQLException 
	{		
		String sTableSchema = (sSchema == null)? "" : "'"+sSchema+"'";
		Statement stat = null;
		ResultSet rs = null;
		stat = conn.createStatement();
		rs = stat.executeQuery(	" SELECT TABLE_NAME,TABLE_SCHEMA " +
								" FROM information_schema.TABLES " +
								" WHERE TABLE_SCHEMA = "+sTableSchema+" order by 1" );
		Vector<String> tables = new Vector<String>();

		int iCut = -1;
		if(bLimit != -1) iCut = bLimit;
		
		
		while(rs.next()) {
			tables.add(rs.getString(1));
			if(iCut != -1 && (--iCut == 0) ) break;
		} 
		ConnectionManager.closeConnection(rs,stat);
		return tables;
	}
	/************************/			
	
	public static Vector<Table> getAllTable(
			boolean bAddColumnInfo,
			Connection conn) 
	throws SQLException
	{
		return getAllTable(-1, bAddColumnInfo, conn);
	}	

	
	public static Vector<Table> getAllTableFromInformationSchema(
			boolean bAddColumnInfo,
			Connection conn) 
	throws SQLException
	{
		Vector<String> sarrTableName =  ConnectionManager.getAllTableName(conn);
		Vector<Table> vTable = Table.generateAllTable(sarrTableName);


		Vector<Column> vAllColumn =  getAllColumnFromInformationSchema("modula_test", conn);
		
		for (Table table : vTable) {
		
			
			if(bAddColumnInfo)
			{
				table.setAllColumn(vAllColumn);
			}
			
			
		}

		
		return vTable;
	}

	
	public static Vector<Table> getAllTable(
			int bLimit,
			boolean bAddColumnInfo,
			Connection conn) 
	throws SQLException
	{
		Vector<String> sarrTableName =  ConnectionManager.getAllTableName(bLimit, conn);
		Vector<Table> vTable = Table.generateAllTable(sarrTableName);
		
		for (Table table : vTable) {
		
			
			if(bAddColumnInfo)
			{
				/**
				 * add column info
				 */
				
				table.setAllColumnFromDb(conn);
				
			}
			
			
		}
		
		return vTable;
	}

	
	/* Added by Miguel */
	public static Vector<Vector<Object>> getAllColumns(String sSchema , Connection conn)
	throws SQLException {
		String sQuery = " select  " +
							"COL.COLUMN_NAME 		AS 'FIELD'," 	+
							"COL.COLUMN_TYPE		AS 'TYPE',"		+
							"COL.COLLATION_NAME 	AS 'COLLATION',"+
							"COL.IS_NULLABLE 		AS 'NULL',"		+
							"COL.COLUMN_KEY 		AS 'KEY',"		+
							"COL.COLUMN_DEFAULT 	AS 'DEFAULT',"	+
							"COL.EXTRA,"							+
							"COL.PRIVILEGES,"						+	
							"COL.COLUMN_COMMENT 	AS 'COMMENT'," 	+
							"COL.TABLE_NAME 		AS 'TABLE'"		+
						"	from information_schema.COLUMNS COL"	+
					   " where COL.table_schema = ?  order by 10 ";

		ResultSet rs = null;
		PreparedStatement ps;	
		Vector<Vector<Object>> vDataContainer = new Vector<Vector<Object>>();		
			ps = conn.prepareStatement(sQuery);
			ps.setString(1, sSchema);
			
			rs = ps.executeQuery();
			
			while(rs.next()){				
				Column column = new Column();
				column.sName 		= rs.getString("Field");
				column.sDbType 		= rs.getString("TYPE");
				column.sDbCollation = rs.getString("Collation");
				column.sDbNull 		= rs.getString("Null");
				column.sDbKey 		= rs.getString("Key");
				column.sDbDefault 	= rs.getString("Default");
				column.sDbExtra 	= rs.getString("Extra");
				column.sDbPrivileges= rs.getString("Privileges");
				column.sDbComment 	= rs.getString("Comment");
						
				/**
				 * do synchro with scheme of DB Designer
				 * - iId
				 * - bIsPK
				 * - iIdDataType
				 */
				column.bIsPK = false;
				column.iId = -1;
				column.iIdDataType = -1;
				
				Vector<Object> vDataCol = new Vector<Object>();
				vDataCol.add(rs.getString("TABLE"));
				vDataCol.add(column);
				
				vDataContainer.add(vDataCol);
				//System.out.println("column.sName : " + column.sName);				
				//	columnas.put(rs.getString("TABLA"), column);
			}			
		
		ConnectionManager.closeConnection(rs,ps);
		return vDataContainer; 
	}
	/*****************/

	/* Added by Miguel */
	public static Vector<Column> getAllColumnFromInformationSchema(
			String sTableSchema,
			Connection conn)
	throws SQLException {		

		String sSelect = "SELECT table_name, column_name, data_type, collation_name, "
			+ " is_nullable, column_key, column_default, extra, privileges, column_comment"
			+ " FROM INFORMATION_SCHEMA.columns"
			+ " WHERE table_schema = '" + sTableSchema + "' "
			+ " ORDER BY table_name DESC";
		
		ResultSet rs = null;
		PreparedStatement ps = conn.prepareStatement(sSelect);
		//ps.setString(1, sTableName);
		rs = ps.executeQuery();
		Vector<Column> vColumn = new Vector<Column>();		
		while(rs.next()) {
			Column column = new Column();
				column.sTableName 	= rs.getString("table_name");
				column.sName 		= rs.getString("column_name");
				column.sDbType 		= rs.getString("data_type");
				column.sDbCollation = rs.getString("collation_name");
				column.sDbNull 		= rs.getString("is_nullable");
				column.sDbKey 		= rs.getString("column_key");
				column.sDbDefault 	= rs.getString("column_default");
				column.sDbExtra 	= rs.getString("extra");
				column.sDbPrivileges= rs.getString("privileges");
				column.sDbComment 	= rs.getString("column_comment");

			/**
			 * do synchro with scheme of DB Designer
			 * - iId
			 * - bIsPK
			 * - iIdDataType
			 */
				column.bIsPK 		= false;
				column.iId 			= -1;
				column.iIdDataType 	= -1;
			
			//System.out.println("column.sName : " + column.sName);
			
			vColumn.add(column);			
		}
		ConnectionManager.closeConnection(rs,ps);
		return vColumn;
	}	

	

	
	public static Vector<Column> getFieldsFromTableName(
			String sTableName,
			Connection conn)
	throws SQLException 
	{		
		ResultSet rs = null;
		
		PreparedStatement ps = conn.prepareStatement(CoinDatabaseUtil.getSqlShowColumns(sTableName));
		//ps.setString(1, sTableName);
		rs = ps.executeQuery();
		Vector<Column> vColumn = new Vector<Column>();		
		while(rs.next()) {
			Column column = new Column();
			switch (getDbType()) {
			case ConnectionManager.DBTYPE_MYSQL:
				column.sName = rs.getString("Field");
				column.sDbType = rs.getString("Type");
				column.sDbCollation = rs.getString("Collation");
				column.sDbNull = rs.getString("Null");
				column.sDbKey = rs.getString("Key");
				column.sDbDefault = rs.getString("Default");
				column.sDbExtra = rs.getString("Extra");
				column.sDbPrivileges = rs.getString("Privileges");
				column.sDbComment = rs.getString("Comment");
				break;
			case ConnectionManager.DBTYPE_SQL_SERVER:
				column.sName = rs.getString("COLUMN_NAME");
				column.sDbType = rs.getString("TYPE_NAME");
				column.sDbNull = rs.getString("NULLABLE");
				column.sDbKey = rs.getString("TYPE_NAME");
				column.sDbComment = rs.getString("REMARKS");
				break;

			default:
				break;
			}
			

			/**
			 * do synchro with scheme of DB Designer
			 * - iId
			 * - bIsPK
			 * - iIdDataType
			 */
			column.bIsPK = false;
			column.iId = -1;
			column.iIdDataType = -1;
			
			//System.out.println("column.sName : " + column.sName);
			
			vColumn.add(column);			
		}
		ConnectionManager.closeConnection(rs,ps);
		return vColumn;
	}	

	/* Added by Miguel */
	public static Vector <Table> getTableAllFromInformationSchema(
			int bLimit, 
			boolean bAddColumnInfo, 
			Connection conn, 
			String sSchemaName) {
	Vector<Table> tableA = new Vector<Table>();
	try {					
		System.out.println("Test Meta Data ... ");
		
		Vector<String> sarrTableName =  ConnectionManager.getAllTableNameFromInformationSchema(bLimit,sSchemaName, conn);
		Vector<Table> vTable = Table.generateAllTable(sarrTableName);
		Vector<Vector<Object>> vColumnAll  = ConnectionManager.getAllColumns(sSchemaName, conn);			
		
		int size = vColumnAll.size();
		
		for (Table table : vTable){
			int i = 0;
			int pos = 0;					
			if (bAddColumnInfo) { //add columns to the table information
				while (i < size) {						
					Vector<Object> v = (Vector<Object>) vColumnAll.elementAt(i);
					Column c = (Column) v.elementAt(1);
					
					if (table.getName().equals(v.elementAt(0).toString())) {							
						table.addColumn(pos, c);
						pos++;
					}						
					i++;
				}
			}
			tableA.add(table);
		}		
	} catch (SQLException e) {
		System.out.println("Error: "+e.getMessage());
		e.printStackTrace();
	}
		
		return tableA;
	}
	
	/* Added by Miguel
	 * Method return true, Connection Successfull
	 * */	
	public static boolean  testDb(String sUser, String sPassword, String sHost , String sType ){
		
		String sUrlMysql 		= "jdbc:mysql://";
		String sUrlSqlServer 	= "jdbc:sqlserver://";
		String sUrl 			= "";		
		RemoteControlServiceConnection rcsc = null;
		boolean resp 			= false;		
		
		switch(Integer.valueOf(sType).intValue()){		
			case ConnectionManager.DBTYPE_MYSQL:
				sUrlMysql 		+= sHost+"/test?";
				sUrl 			= sUrlMysql; 
				break;
			case ConnectionManager.DBTYPE_SQL_SERVER:
				sUrlSqlServer 	+= sHost;
				sUrl			= sUrlSqlServer+"/"; 
				break;		
		}
		
		rcsc = new RemoteControlServiceConnection(sUrl,sUser,sPassword,Integer.valueOf(sType).intValue()); 	
		try {
			Connection conn = RemoteControlServiceConnection.getConnexion(rcsc);
			if(conn != null){
				resp = true;
				closeConnection(conn);	
			}
			return resp;
		} catch (SQLException e) {		
			e.printStackTrace();
			return false;
		}
		
		
	}
	
	public static Connection  connectDb(String sUser, String sPassword, String sHost , String sType ){
		
		String sUrlMysql 		= "jdbc:mysql://";
		String sUrlSqlServer 	= "jdbc:sqlserver://";
		String sUrl 			= "";		
		RemoteControlServiceConnection rcsc = null;				
		Connection conn = null;
		
		switch(Integer.valueOf(sType).intValue()){		
			case ConnectionManager.DBTYPE_MYSQL:
				sUrlMysql 		+= sHost+"/test?";
				sUrl 			 = sUrlMysql; 
				break;
			case ConnectionManager.DBTYPE_SQL_SERVER:
				sUrlSqlServer 	+= sHost;
				sUrl			 = sUrlSqlServer+"/"; 
				break;		
		}
		
		rcsc = new RemoteControlServiceConnection(sUrl,sUser,sPassword,Integer.valueOf(sType).intValue()); 	
		try {
			conn = RemoteControlServiceConnection.getConnexion(rcsc);			
			return conn;
		} catch (SQLException e) {		
			e.printStackTrace();
			return null;
		}		
		
	}
	
	
	/* Added by Miguel*/
	public static int createTableInDb(String sQuery,Connection conn){
		Statement stm;
		int iResp = -1;
		try {
			stm = conn.createStatement();
			iResp = stm.executeUpdate(sQuery);
			
		} catch (SQLException e) {
			e.printStackTrace();
			return iResp;
		}
		return iResp;
	}
	

	/* Added by Miguel*/
	public static Vector <Schema> getAllSchemaFromInformationSchema(Connection conn){
		Vector <Schema> vSchema = new Vector<Schema> ();
		Statement stm = null;
		ResultSet rs = null;
		String sQuery = " SELECT	SCHEMA_NAME, " +
						"			DEFAULT_CHARACTER_SET_NAME " +
						" FROM information_schema.SCHEMATA; ";
		try {
			stm = conn.createStatement();
			rs  = stm.executeQuery(sQuery);
			while(rs.next()){
				System.out.println(rs.getString(1));
				Schema schema = new Schema();
					schema.setSNameSchema(rs.getString(1));
				vSchema.addElement(schema);
			}			
			closeConnection(rs, stm);
			return vSchema;
		} catch (SQLException e) {			
			e.printStackTrace();
			return null;
		}	
	}
	
}
