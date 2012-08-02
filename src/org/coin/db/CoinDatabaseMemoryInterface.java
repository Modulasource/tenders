package org.coin.db;

import java.sql.SQLException;
import java.util.Vector;

import javax.naming.NamingException;

public interface CoinDatabaseMemoryInterface {

	public void populateMemory() throws NamingException, SQLException, InstantiationException, IllegalAccessException;
	public <T> Vector<T> getAllMemory() throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException;
	public Vector getItemMemory();
}
