package org.coin.db;

import java.sql.Connection;
import java.sql.SQLException;

import javax.naming.NamingException;


public interface CoinDatabaseWebServiceInterface {
	/**
	 * need a big brainstorming to define it
	 */
	
	public abstract boolean isSynchronized(
			CoinDatabaseAbstractBean item, 
			Connection conn) 
	throws SQLException, NamingException, InstantiationException,
	IllegalAccessException, CoinDatabaseLoadException ;
	
	public abstract boolean isSynchronized(
			long lIdItem, 
			Connection conn) 
	throws SQLException, NamingException, InstantiationException,
	IllegalAccessException, CoinDatabaseLoadException ;
}
