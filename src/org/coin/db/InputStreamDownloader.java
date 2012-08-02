package org.coin.db;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.naming.NamingException;

public class InputStreamDownloader {
	
	public String sSqlQuery;
	public Connection conn;
	public ResultSet rs ;
	public Statement stat ;
	public InputStream is;
	
	public InputStreamDownloader(
			String sSqlQuery,
			Connection conn) 
	{
		this.sSqlQuery = sSqlQuery;
		this.conn = conn;
	}
	
	
	public void prepareInputStream()
	throws NamingException, SQLException, CoinDatabaseLoadException 
	{
		CoinDatabaseAbstractBean.traceQueryStatic(this.sSqlQuery);
		try {
			rs = ConnectionManager.executeQuery(this.sSqlQuery , this.conn);
			stat =  rs.getStatement();
			if(rs.next()) {
				//Blob blob = rs.getBlob(1);
				//file = blob.getBinaryStream();
				this.is = rs.getBinaryStream(1);
				
			}
			else
			{
				throw new CoinDatabaseLoadException("", this.sSqlQuery);
			}
		} catch (OutOfMemoryError e){
			throw e;
		} finally {
		} 
		
	}
	
	public void close() throws SQLException {
		try{
			is.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		ConnectionManager.closeConnection(this.rs,this.stat);
	}
	
	

}
