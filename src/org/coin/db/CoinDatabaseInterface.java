package org.coin.db;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Vector;

import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;

public interface CoinDatabaseInterface {

	
	public void load() throws NamingException, CoinDatabaseLoadException, SQLException;
	public void create() throws NamingException,CoinDatabaseCreateException, SQLException, CoinDatabaseDuplicateException, CoinDatabaseLoadException;
	public void store() throws NamingException, SQLException, CoinDatabaseStoreException;
	public void remove() throws NamingException, SQLException;
	//TODO: public void removeWithObjectAttached() throws NamingException, SQLException;
	public <T> Vector<T> getAll() throws NamingException, SQLException, InstantiationException, IllegalAccessException;
	public <T> Vector<T> getAllWithSqlQuery(String sSqlquery) throws NamingException, SQLException, InstantiationException, IllegalAccessException;
	public <T> Vector<T> getAllWithSqlQuery(String sSqlquery,Connection conn) throws NamingException, SQLException, InstantiationException, IllegalAccessException;

	public String getSelectFieldsName(String sAlias);
	public void setPreparedStatement (PreparedStatement ps ) throws SQLException;
	public void setFromResultSet(ResultSet rs) throws SQLException ;
	public void init() throws NamingException, SQLException, InstantiationException, IllegalAccessException ;
	public void setFromForm(HttpServletRequest request, String sFormPrefix) throws SQLException, NamingException;

}
